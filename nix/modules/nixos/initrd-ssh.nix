{
  config,
  lib,
  ...
}:
let
  cfg = config.boot.initrd.remoteUnlock;
in
{
  options.boot.initrd.remoteUnlock = {
    enable = lib.mkEnableOption "unlocking LUKS over SSH during early boot";

    port = lib.mkOption {
      type = lib.types.port;
      default = 2222;
      description = ''
        Port the initrd sshd listens on. Deliberately not 22: the initrd has its
        own host key, and sharing the port with the running system's sshd would
        trip host key verification on every boot.
      '';
    };

    kernelModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "r8169" ];
      description = ''
        Network drivers to include in the initrd. The stage-1 hardware scan only
        covers storage, so the NIC driver has to be named explicitly or there is
        no network to SSH into.
      '';
    };

    hostKey = lib.mkOption {
      type = lib.types.path;
      default = /etc/secrets/initrd/ssh_host_ed25519_key;
      description = ''
        Host key for the initrd sshd, generated on the machine with ssh-keygen.

        systemd-boot sets boot.loader.supportsInitrdSecrets, so this is appended
        to the initrd at bootloader-install time rather than copied into the nix
        store. Do not point this at the running system's host key: a leak here
        is a leak of the machine's identity.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd = {
      availableKernelModules = cfg.kernelModules;

      network = {
        enable = true;
        ssh = {
          enable = true;
          inherit (cfg) port;
          hostKeys = [ cfg.hostKey ];
          # Same key that authenticates to the booted system, so unlocking needs
          # no separate credential.
          authorizedKeys = config.users.users.judahf.openssh.authorizedKeys.keys;
        };
      };

      # DHCP in the initrd, matching how the booted system addresses itself.
      # A static address here would be a second place the network config lives.
      systemd.network.enable = true;
    };

    # Drop to the unlock prompt on login rather than an empty shell, so the
    # session has one obvious purpose. The agent is already part of the systemd
    # initrd; it lives on PATH at /usr/bin, not /bin.
    boot.initrd.systemd.users.root.shell = "/usr/bin/systemd-tty-ask-password-agent";
  };
}
