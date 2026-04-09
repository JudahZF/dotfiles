{ pkgs, ... }:
{
  environment.shellAliases = {
    # Replace du with dua for a more readable disk-usage view.
    du = "dua";
  };
  environment.systemPackages = [ pkgs.dua ];
}
