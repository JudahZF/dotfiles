{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  environment.systemPackages = with pkgs; [
    pavucontrol
    pamixer
  ];

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
