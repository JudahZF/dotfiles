{ pkgs, lib, ... }:
{
  vim.theme.enabled = true;
  vim.theme.name = "tokyonight";
  vim.theme.style = "night";

  vim.languages.nix.enable = true;
}
