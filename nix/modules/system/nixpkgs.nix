{ lib, system, ... }: {
  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePredicate = _: true;
    hostPlatform = lib.mkDefault "${system}";
  };
}
