{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./docker.nix
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
    (python313.withPackages (ps:
      with ps;
      [ meshtastic ])) # Meshtastic CLI (Linux only, use pipx on macOS)
    sops
    wget
    zsh
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  programs.zsh.enable = true;

  services.fstrim.enable = true;
  services.fwupd.enable = true;
}
