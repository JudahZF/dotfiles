{ pkgs, ... }:
{
  environment.shellAliases = { lg = "lazygit"; };
  environment.systemPackages = with pkgs; [
    git
    git-cliff
    git-crypt
    git-lfs
    lazygit
  ];
}
