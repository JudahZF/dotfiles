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
            "affinity-designer"
            "affinity-photo"
            "affinity-publisher"
            "pika"
        ];
        onActivation.cleanup = "zap";
    };
}
