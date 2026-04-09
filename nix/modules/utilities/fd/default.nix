{ pkgs, ... }:
{
  environment.shellAliases = {
    # Replace find with fd for faster searches and saner defaults.
    find = "fd";
  };
  environment.systemPackages = [ pkgs.fd ];
}
