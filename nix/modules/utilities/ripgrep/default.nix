{ pkgs, ... }:
{
  environment.shellAliases = {
    # Replace grep with ripgrep for fast recursive searches by default.
    grep = "rg";
  };
  environment.systemPackages = [ pkgs.ripgrep ];
}
