{ lib, system, ... }: {
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${system}";
  };
}
