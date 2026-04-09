{ pkgs, ... }:
{
  environment.shellAliases = {
    # Keep the neofetch muscle-memory while using fastfetch underneath.
    neofetch = "fastfetch";
  };
  environment.systemPackages = [ pkgs.fastfetch ];
}
