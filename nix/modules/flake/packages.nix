{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = lib.optionalAttrs pkgs.stdenv.isDarwin {
        cmux = import ../../packages/cmux.nix { inherit pkgs lib; };
      };
    };
}
