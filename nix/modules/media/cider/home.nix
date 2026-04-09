{ pkgs, lib, ... }:
let
  ciderAppImage = ./cider-v3.1.8-linux-x64.AppImage;
in
lib.mkIf pkgs.stdenv.isLinux {
  home.packages = [
    (pkgs.appimageTools.wrapType2 {
      pname = "cider";
      version = "3.1.8";
      src = ciderAppImage;

      meta = with lib; {
        description = "The perfect client for Apple Music users";
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        homepage = "https://cider.sh/";
        license = licenses.unfree;
        platforms = platforms.linux;
        mainProgram = "cider";
      };
    })
  ];

  xdg.desktopEntries.cider = {
    name = "Cider";
    comment = "Apple Music client";
    exec = "cider %U";
    icon = "cider";
    terminal = false;
    type = "Application";
    categories = [ "Audio" "Music" "Player" "AudioVideo" ];
    mimeType = [ "x-scheme-handler/cider" "x-scheme-handler/itms" "x-scheme-handler/itmss" "x-scheme-handler/musics" "x-scheme-handler/music" ];
  };
}
