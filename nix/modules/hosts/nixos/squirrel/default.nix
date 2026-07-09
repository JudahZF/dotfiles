{ self, mkNixosHost, ... }:
{
  flake.nixosConfigurations.squirrel = mkNixosHost {
    inherit self;
    name = "squirrel";
    modules = [ ./configuration.nix ];
  };
}
