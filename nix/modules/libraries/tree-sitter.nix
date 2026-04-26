{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.tree-sitter ];
}
