{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./kernel.nix
    ./localisation.nix
    ./network.nix
    ./ssh.nix
    ./tailscale.nix
  ];

  hardware.firmware = [ pkgs.linux-firmware ];

  # PACKAGES
  environment.systemPackages = with pkgs; [
    btrfs-progs
    git
    wget
    zsh
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  programs.zsh.enable = true;

  services.fstrim.enable = true;
  services.fwupd.enable = true;
}
