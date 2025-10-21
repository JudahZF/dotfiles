{ pkgs, lib, ... }:
{
  config.vim = {
    theme = {
      enabled = true;
      theme.name = "tokyonight";
      theme.style = "night";
    };
    languages.nix.enable = true;
  };
}
