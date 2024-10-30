{
    config,
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        reaper
    ];
    homebrew = {
        casks = [
          "4k-video-downloader"
          "ableton-live-suite@12"
          "arturia-software-center"
          "ilok-license-manager"
          "izotope-product-portal"
          "midi-monitor"
          # "native-access"
          "propresenter"
          # "waves-central"
        ];
        masApps = {
          "Capo" = 696977615;
          "Compressor" = 424390742;
          "Logic Pro" = 634148309;
          "Wireguard" = 1451685025;
        };
    };
}
