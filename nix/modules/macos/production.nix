{
    config,
    lib,
    pkgs,
    ...
}: {
    homebrew = {
        enable = true;
        brews = [
            "mas"
        ];
        casks = [
            "ableset"
            "lightkey"
            "propresenter"
        ];
        onActivation.cleanup = "zap";
    };
}
