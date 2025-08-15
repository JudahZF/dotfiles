{
  dotfiles,
  ...
}:
{
  home = {
    stateVersion = "24.05";

    file = {
      nix = {
        recursive = true;
        source = "${dotfiles}/nix";
        target = ".config/nix";
      };
      nvim = {
        recursive = true;
        source = "${dotfiles}/nvim";
        target = ".config/nvim";
      };
    };

    sessionPath = [
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
    ];
  };
}
