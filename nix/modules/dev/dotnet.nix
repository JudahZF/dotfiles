{
  pkgs,
  pkgs-unstable ? null,
  ...
}:
let
  dotnetPkgs = if pkgs-unstable != null then pkgs-unstable else pkgs;
in
{
  environment.systemPackages = [ dotnetPkgs.dotnet-sdk_9 ];
}
