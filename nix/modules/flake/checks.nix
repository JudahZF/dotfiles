{ inputs, self, ... }: {
  perSystem =
    { system, pkgs, ... }:
    let
      src = inputs.dotfiles;
    in
    {
      checks = {
        judah-neovim = self.packages.${system}.judah-neovim;

        nixfmt = pkgs.runCommand "nixfmt-check" { } ''
          ${pkgs.nixfmt}/bin/nixfmt --check ${src}/nix
          touch $out
        '';

        statix = pkgs.runCommand "statix-check" { } ''
          ${pkgs.statix}/bin/statix check ${src}/nix
          touch $out
        '';

        deadnix = pkgs.runCommand "deadnix-check" { } ''
          ${pkgs.deadnix}/bin/deadnix --fail ${src}/nix
          touch $out
        '';
      }
      // (
        if system == "x86_64-linux" then
          {
            popper = self.nixosConfigurations.popper.config.system.build.toplevel;
            zevlor = self.nixosConfigurations.zevlor.config.system.build.toplevel;
          }
        else
          { }
      )
      // (
        if system == "aarch64-linux" && self.nixosConfigurations ? jfpi then
          {
            jfpi = self.nixosConfigurations.jfpi.config.system.build.toplevel;
          }
        else
          { }
      )
      // (
        if system == "aarch64-darwin" then
          {
            gale = self.darwinConfigurations.gale.config.system.build.toplevel;
          }
        else
          { }
      );
    };
}
