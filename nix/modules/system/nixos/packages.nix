{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  hardware.firmware = [ pkgs.linux-firmware ];

  environment.systemPackages = with pkgs; [
    btrfs-progs
    git
    (python313.withPackages (ps:
      with ps;
      [ meshtastic ]))
    sops
    wget
    zsh
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  programs.zsh.enable = true;

  services.fstrim.enable = true;
  services.fwupd.enable = true;
}
