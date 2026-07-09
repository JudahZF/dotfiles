{ self, mkNixosHost, ... }:
{
  flake.nixosConfigurations.popper = mkNixosHost {
    inherit self;
    name = "popper";
    modules = [ ./configuration.nix ];
  };
}
