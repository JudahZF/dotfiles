{ pkgs, pkgs-unstable ? null, ... }:
let
  unstable = if pkgs-unstable != null then pkgs-unstable else pkgs;
in {
  environment.systemPackages = [ unstable.zed-editor ];
}
