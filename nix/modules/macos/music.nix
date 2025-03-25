{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        reaper
    ];
    homebrew = {
        casks = [
          "ableton-live-suite"
          "arturia-software-center"
          "ilok-license-manager"
          "izotope-product-portal"
          "midi-monitor"
          "native-access"
          "waves-central"
        ];
    };
}
