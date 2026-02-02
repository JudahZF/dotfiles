{ pkgs, inputs, ... }: {
  environment.systemPackages = [
    (inputs.nvf.lib.neovimConfiguration {
      pkgs = pkgs;
      modules = [ "${inputs.dotfiles}/nvim/config.nix" ];
    }).neovim
  ];
}
