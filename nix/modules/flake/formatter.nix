_: {
  perSystem = { pkgs, ... }: {
    formatter = pkgs.writeShellApplication {
      name = "nixfmt-tree";
      runtimeInputs = [ pkgs.nixfmt ];
      text = ''
        if [ "$#" -eq 0 ]; then
          exec nixfmt .
        fi

        exec nixfmt "$@"
      '';
    };
  };
}
