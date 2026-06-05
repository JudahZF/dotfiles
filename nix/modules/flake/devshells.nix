{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages =
          with pkgs;
          [
            cachix
            deadnix
            gitleaks
            nil
            nix-output-monitor
            nix-tree
            nixd
            nixfmt-rfc-style
            statix

            # Native build dependencies for Rust/C crates that probe with cc/pkg-config.
            pkg-config
            openssl
            stdenv.cc
          ]
          ++ lib.optionals (pkgs ? colmena) [ colmena ]
          ++ lib.optionals (pkgs ? nh) [ nh ]
          ++ lib.optionals (pkgs ? nvd) [ nvd ];

        shellHook = ''
          echo "Nix dotfiles shell: just --list"
          echo "Tools: nixfmt, statix, deadnix, gitleaks, nil, nixd, nom, nix-tree"
        '';
      };
    };
}
