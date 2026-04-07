{ inputs, pkgs }:
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = [ "${inputs.dotfiles}/nvim/config.nix" ];
}).neovim
