{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  environment.gnome.excludePackages = (with pkgs; [
    atomix
    cheese
    epiphany
    evince
    geary
    gedit
    gnome-characters
    gnome-music
    gnome-photos
    gnome-terminal
    gnome-tour
    hitori
    iagno
    tali
    totem
  ]);

  services.gnome.at-spi2-core.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [ adwaita-icon-theme ];
  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  services.xserver = {
    desktopManager.gnome.enable = true;
  };
}
