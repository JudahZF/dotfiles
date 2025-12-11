{ pkgs, lib, ... }:
let
  ciderAppImage = ./cider-v3.1.8-linux-x64.AppImage;
in
{
  home.packages = [
    (pkgs.appimageTools.wrapType2 {
      name = "cider";
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
}
