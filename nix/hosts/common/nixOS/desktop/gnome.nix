{ pkgs, ... }: {
  environment.gnome.excludePackages = (with pkgs; [
    atomix # puzzle game
    cheese # webcam tool
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gedit # text editor
    gnome-characters
    gnome-music
    gnome-photos
    gnome-terminal
    gnome-tour
    hitori # sudoku game
    iagno # go game
    tali # poker game
    totem # video player
  ]);

  # Disable accessibility/screen reader
  services.gnome.at-spi2-core.enable = false;

  # Cursor theme
  environment.systemPackages = with pkgs; [ adwaita-icon-theme ];
  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  services.xserver = {
    desktopManager.gnome.enable = true;
  };
}
