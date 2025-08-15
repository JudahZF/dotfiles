{
  inputs,
  ...
}:
{
  mkDarwin =
    {
      hostname,
      username ? "judahfuller",
      system ? "aarch64-darwin",
    }:
    let
      customConfPath = ./../hosts/darwin/${hostname};
      customConf =
        if builtins.pathExists customConfPath then
          (customConfPath + "/default.nix")
        else
          ./../hosts/common/darwin/default-dock.nix;
    in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit system inputs username; };
      modules = [
        ../hosts/common/default.nix
        ../hosts/common/darwin/default.nix
        customConf
        inputs.home-manager.darwinModules.home-manager
        {
          networking.hostName = hostname;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.${username} = {
            imports = [ ./../home/${username}.nix ];
          };
        }
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            autoMigrate = true;
            mutableTaps = true;
            user = "${username}";
            taps = with inputs; {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
          };
        }
      ];
    };
}
