{ lib, ... }: {
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs;
        [
          cachix
          deadnix
          nil
          nix-output-monitor
          nix-tree
          nixd
          nixfmt-rfc-style
          statix
        ] ++ lib.optionals (pkgs ? colmena) [ colmena ]
        ++ lib.optionals (pkgs ? nh) [ nh ]
        ++ lib.optionals (pkgs ? nvd) [ nvd ];

      shellHook = ''
        echo "Nix dotfiles shell: just --list"
        echo "Tools: nixfmt, statix, deadnix, nil, nixd, nom, nix-tree"
      '';
    };
  };
}
