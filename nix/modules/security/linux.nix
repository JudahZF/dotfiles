{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "judahf" ];
      GSSAPIAuthentication = false;
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitEmptyPasswords = false;
      PermitRootLogin = "no";
      UseDns = false;
      X11Forwarding = false;
    };
  };

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "fc00::/7"
      "fe80::/10"
    ];
  };

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = true;
    extraRules = [
      {
        users = [ "judahf" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  environment.systemPackages = [ pkgs.libnotify ];

  systemd = {
    services.update-dotfiles-flake = {
      description = "Pull dotfiles and update the local Nix flake lock";
      serviceConfig = {
        Type = "oneshot";
        User = "judahf";
        WorkingDirectory = "/home/judahf/dotfiles";
      };
      path = [
        pkgs.git
        pkgs.nix
      ];
      script = ''
        set -euo pipefail

        repo=/home/judahf/dotfiles
        lock=nix/flake.lock

        if ${pkgs.git}/bin/git -C "$repo" diff --quiet -- "$lock"; then
          :
        else
          ${pkgs.git}/bin/git -C "$repo" restore --source=HEAD -- "$lock"
        fi

        if ! ${pkgs.git}/bin/git -C "$repo" pull --rebase --autostash; then
          unmerged="$(${pkgs.git}/bin/git -C "$repo" diff --name-only --diff-filter=U)"
          if [ "$unmerged" = "$lock" ]; then
            ${pkgs.git}/bin/git -C "$repo" checkout --ours -- "$lock"
            ${pkgs.git}/bin/git -C "$repo" add "$lock"
            ${pkgs.git}/bin/git -C "$repo" rebase --continue || ${pkgs.git}/bin/git -C "$repo" rebase --skip
          else
            echo "git pull had conflicts outside $lock:" >&2
            echo "$unmerged" >&2
            exit 1
          fi
        fi

        ${pkgs.nix}/bin/nix flake update "$repo/nix"
      '';
    };

    timers.update-dotfiles-flake = {
      description = "Daily dotfiles pull and flake lock update";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "02:30";
        RandomizedDelaySec = "30min";
        Persistent = true;
      };
    };

    user = {
      services.nixos-reboot-needed-notify = {
        description = "Notify when a reboot is recommended after NixOS updates";
        serviceConfig = {
          Type = "oneshot";
        };
        script = ''
          booted_kernel="$(${pkgs.coreutils}/bin/readlink -f /run/booted-system/kernel 2>/dev/null || true)"
          current_kernel="$(${pkgs.coreutils}/bin/readlink -f /run/current-system/kernel 2>/dev/null || true)"

          if [ -n "$booted_kernel" ] && [ -n "$current_kernel" ] && [ "$booted_kernel" != "$current_kernel" ]; then
            ${pkgs.libnotify}/bin/notify-send "NixOS updates installed" "Reboot recommended" || true
          fi
        '';
      };

      timers.nixos-reboot-needed-notify = {
        description = "Check whether NixOS updates require a reboot";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "04:45";
          RandomizedDelaySec = "30min";
          Persistent = true;
        };
      };
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = "path:/home/judahf/dotfiles/nix#${config.networking.hostName}";
    operation = "switch";
    dates = "03:30";
    randomizedDelaySec = "45min";
    allowReboot = false;
  };
}
