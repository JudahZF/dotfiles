{ self, lib, ... }:
{
  perSystem =
    { system, pkgs, ... }:
    {
      checks = {
        judah-neovim = self.packages.${system}.judah-neovim;
      }
      // (
        if system == "x86_64-linux" then
          {
            popper = self.nixosConfigurations.popper.config.system.build.toplevel;
            zevlor = self.nixosConfigurations.zevlor.config.system.build.toplevel;
          }
          // lib.optionalAttrs (self.nixosConfigurations ? gitlab) {
            gitlab = self.nixosConfigurations.gitlab.config.system.build.toplevel;
          }
          // lib.optionalAttrs (self.nixosConfigurations ? clawdbot) {
            clawdbot = self.nixosConfigurations.clawdbot.config.system.build.toplevel;
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
