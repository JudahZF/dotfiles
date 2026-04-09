{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.judah-neovim = import ./package.nix {
      inherit inputs pkgs;
    };
  };
}
