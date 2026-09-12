{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.headlessRdp;

  # krdpserver confirms the highest-numbered capability set the client
  # advertises, without checking it is one it can actually encode for. The
  # Windows App advertises undocumented sets that outrank every documented one,
  # so the server confirms a set it never sends frames for and the client shows
  # a blank screen. Drop this once the fix lands upstream in krdp.
  plasma = pkgs.kdePackages.overrideScope (
    _: kdeSuper: {
      krdp = kdeSuper.krdp.overrideAttrs (prev: {
        patches = (prev.patches or [ ]) ++ [ ./caps-prefer-usable.patch ];
      });
    }
  );

  home = config.users.users.${cfg.user}.home;
  stateDir = "${home}/.local/state/headless-rdp";
  certificate = "${stateDir}/rdp-tls.crt";
  certificateKey = "${stateDir}/rdp-tls.key";
  # krdpserver's own XDG_CONFIG_HOME, so generating krdpserverrc never touches
  # the user's real ~/.config (where Plasma's KCM would also write it).
  configDir = "${stateDir}/config";

  # krdpserver 6.6.x refuses to start without an existing certificate: cert
  # generation lives in the KCM, not the server binary, so an unattended
  # session has to provide one itself.
  #
  # It also reads PAM authentication purely from krdpserverrc; with no users
  # and SystemUserEnabled unset it exits non-zero immediately.
  prepare = pkgs.writeShellApplication {
    name = "headless-rdp-prepare";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.openssl
    ];
    text = ''
      mkdir -p ${lib.escapeShellArg stateDir} ${lib.escapeShellArg configDir}
      chmod 700 ${lib.escapeShellArg stateDir}

      if [ ! -s ${lib.escapeShellArg certificate} ] || [ ! -s ${lib.escapeShellArg certificateKey} ]; then
        openssl req -newkey rsa:4096 -nodes -x509 -days 3650 \
          -subj "/CN=${config.networking.hostName}" \
          -keyout ${lib.escapeShellArg certificateKey} \
          -out ${lib.escapeShellArg certificate}
        chmod 600 ${lib.escapeShellArg certificateKey}
      fi

      # Authenticate against PAM as the session's own user, so the RDP password
      # is the account password. Nothing is stored in the nix store, passed on a
      # command line, or kept in a keyring no unattended session could unlock.
      cat > ${lib.escapeShellArg "${configDir}/krdpserverrc"} <<EOF
      [General]
      SystemUserEnabled=true
      Autostart=false
      ListenPort=${toString cfg.port}
      EOF
    '';
  };

  # Everything that runs inside the virtual compositor. kwin_wayland exits when
  # this exits, which tears the session down as a unit.
  #
  # --plasma makes krdpserver capture through KWin's zkde_screencast_unstable_v1
  # rather than xdg-desktop-portal-kde, which would prompt for consent nobody is
  # present to give.
  sessionBody = pkgs.writeShellApplication {
    name = "headless-rdp-body";
    runtimeInputs = [
      pkgs.dbus
      pkgs.systemd
      plasma.krdp
      plasma.plasma-workspace
    ]
    ++ lib.optional cfg.steam config.programs.steam.package;
    text = ''
      # plasmashell and everything it activates need a Qt platform. Without
      # this Qt tries xcb, fails, and kactivitymanagerd aborts -- which makes
      # plasmashell refuse to load.
      export QT_QPA_PLATFORM=wayland
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=KDE

      # kactivitymanagerd is D-Bus activated, so it inherits the bus activation
      # environment rather than this shell's. Push the session variables into
      # both systemd --user and D-Bus before anything needs activating.
      systemctl --user import-environment \
        WAYLAND_DISPLAY QT_QPA_PLATFORM XDG_SESSION_TYPE XDG_CURRENT_DESKTOP DISPLAY
      dbus-update-activation-environment --systemd \
        WAYLAND_DISPLAY QT_QPA_PLATFORM XDG_SESSION_TYPE XDG_CURRENT_DESKTOP DISPLAY

      XDG_CONFIG_HOME=${lib.escapeShellArg configDir} krdpserver \
        --plasma \
        --port ${toString cfg.port} \
        --certificate ${lib.escapeShellArg certificate} \
        --certificate-key ${lib.escapeShellArg certificateKey} \
        --virtual-monitor ${toString cfg.width}x${toString cfg.height}@1 &

      plasmashell &
      ${lib.optionalString cfg.steam "steam -silent &"}

      # Exit as soon as any of them dies so systemd restarts a coherent session
      # instead of leaving a half-dead one holding the RDP port.
      wait -n
    '';
  };

  # KWin's virtual backend is not software rendering: GpuManager picks a render
  # device independently of the output backend and the virtual EGL backend
  # allocates through GBM on it. So this is GPU-accelerated without a VKMS
  # module or a forced physical connector.
  session = pkgs.writeShellApplication {
    name = "headless-rdp-session";
    runtimeInputs = [
      plasma.kwin
      # kwin_wayland resolves Xwayland through PATH. Steam's updater and login
      # windows are X11, so the session needs it.
      pkgs.xwayland
    ];
    text = ''
      ${lib.getExe prepare}

      # zkde_screencast_unstable_v1 is a restricted interface: KWin only hands
      # it to clients whose executable path maps back to a .desktop file
      # declaring X-KDE-Wayland-Interfaces. That reverse lookup does not
      # resolve for krdpserver here, so the protocol is withheld and the
      # --plasma path segfaults on a null proxy. Lift the check for this
      # compositor only; it serves exactly one known client.
      export KWIN_WAYLAND_NO_PERMISSION_CHECKS=1

      # No dbus-run-session: the unit already inherits the user bus at
      # $XDG_RUNTIME_DIR/bus. Starting a second bus put krdpserver and the rest
      # of the session on different buses.
      # Any logind lock request -- including one meant for another session on
      # the same user bus -- reaches this compositor and locks it. The greeter
      # then cannot authenticate, because there is no seat to read a password
      # from, leaving the RDP client on a lock screen it can never dismiss.
      # kscreenlockerrc does not help: ksldapp acts on the logind signal
      # without consulting Autolock. Access is already gated by krdpserver's
      # PAM check on connect, so drop lock screen support entirely.
      exec kwin_wayland \
        --no-lockscreen \
        --virtual \
        --width ${toString cfg.width} \
        --height ${toString cfg.height} \
        --xwayland \
        --exit-with-session=${lib.getExe sessionBody}
    '';
  };

  # The headless session must not coexist with a session on the physical seat:
  # both are the same Unix user, and Steam holds a single lockfile in ~/.steam.
  # SDDM's greeter also occupies seat0, so match Class=user only — otherwise the
  # login screen alone would suppress the session forever.
  guard = pkgs.writeShellApplication {
    name = "headless-rdp-guard";
    runtimeInputs = [
      pkgs.systemd
      pkgs.gnugrep
      pkgs.gawk
    ];
    text = ''
      user_session_on_seat() {
        local id seat class
        while read -r id _; do
          [ -n "$id" ] || continue
          seat="$(loginctl show-session "$id" --property=Seat --value 2>/dev/null || true)"
          class="$(loginctl show-session "$id" --property=Class --value 2>/dev/null || true)"
          if [ "$seat" = "seat0" ] && [ "$class" = "user" ]; then
            return 0
          fi
        done < <(loginctl list-sessions --no-legend | awk '{print $1}')
        return 1
      }

      sync_state() {
        if user_session_on_seat; then
          systemctl --user --machine=${cfg.user}@.host stop headless-rdp.service || true
        else
          systemctl --user --machine=${cfg.user}@.host start headless-rdp.service || true
        fi
      }

      sync_state

      # Re-evaluate on every logind session change. dbus-monitor would need a
      # session bus; busctl talks to the system bus directly.
      busctl monitor --system --match \
        "type='signal',interface='org.freedesktop.login1.Manager'" \
        | grep --line-buffered -E 'SessionNew|SessionRemoved' \
        | while read -r _; do
            # logind emits the signal before the session is fully registered.
            sleep 1
            sync_state
          done
    '';
  };
in
{
  options.services.headlessRdp = {
    enable = lib.mkEnableOption "a headless Plasma session exposed over RDP while the physical seat is unused";

    user = lib.mkOption {
      type = lib.types.str;
      default = "judahf";
      description = "User that owns the headless session and authenticates over RDP.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3389;
      description = "Port krdpserver listens on.";
    };

    width = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1920;
      description = "Width of the virtual output.";
    };

    height = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1080;
      description = "Height of the virtual output.";
    };

    steam = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start Steam in the headless session and open the Remote Play ports.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ plasma.krdp ];

    # The session has to survive having no logind session of its own.
    users.users.${cfg.user}.linger = true;

    systemd.user.services.headless-rdp = {
      description = "Headless Plasma session exposed over RDP";
      # Started and stopped exclusively by the guard.
      wantedBy = [ ];
      serviceConfig = {
        Type = "exec";
        ExecStart = lib.getExe session;
        Restart = "on-failure";
        RestartSec = "5s";
        # Steam and KWin both dislike being killed by group signal mid-write.
        KillMode = "mixed";
        TimeoutStopSec = "20s";
      };
    };

    systemd.services.headless-rdp-guard = {
      description = "Run the headless RDP session only while the physical seat is unused";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-logind.service" ];
      requires = [ "systemd-logind.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe guard;
        Restart = "always";
        RestartSec = "5s";
      };
    };

    # tailscale0 is already a trusted interface, so these rules only cover LAN.
    networking.firewall = {
      allowedTCPPorts = [
        cfg.port
      ]
      ++ lib.optionals cfg.steam [
        27036
        27037
      ];
      allowedUDPPortRanges = lib.optionals cfg.steam [
        {
          from = 27031;
          to = 27036;
        }
      ];
    };
  };
}
