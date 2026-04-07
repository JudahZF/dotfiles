{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.system;
in {
  environment.systemPackages =
    if builtins.hasAttr system inputs.t3code.packages then
      [ inputs.t3code.packages.${system}.default ]
    else
      [ ];
}
