{ self, mkNixosHost, ... }:
{
  flake.nixosConfigurations.zevlor = mkNixosHost {
    inherit self;
    name = "zevlor";
    modules = [ ./configuration.nix ];
  };
}
