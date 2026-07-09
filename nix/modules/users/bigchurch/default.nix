import ../mk-linux-guest.nix {
  username = "bigchurch";
  extraPackages =
    pkgs: with pkgs; [
      google-chrome
      libreoffice-qt6-fresh
      haruna
      kdePackages.okular
      kdePackages.gwenview
      kdePackages.ark
    ];
}
