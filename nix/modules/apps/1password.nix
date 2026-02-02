{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
  ];

  # NixOS-specific 1Password configuration
  environment.etc = lib.mkIf pkgs.stdenv.isLinux {
    "1password/custom_allowed_browsers" = {
      text = ''
        .zen
      '';
      mode = "0755";
    };
  };
}
