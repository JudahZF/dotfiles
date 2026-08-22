_: {
  # nixfmt 1.4 deprecates directory arguments, so expand to an explicit file
  # list. With no arguments, format every .nix file under the current directory.
  perSystem = { pkgs, ... }: {
    formatter = pkgs.writeShellApplication {
      name = "nixfmt-tree";
      runtimeInputs = [
        pkgs.nixfmt
        pkgs.findutils
      ];
      text = ''
        if [ "$#" -eq 0 ]; then
          set -- .
        fi

        find "$@" -type f -name '*.nix' -exec nixfmt {} +
      '';
    };
  };
}
