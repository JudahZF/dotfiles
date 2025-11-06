{ inputs, ... }: {
  imports = [
    ./app-config.nix
    ./common-config.nix
    ./common-packages.nix
    ./default-config.nix
    inputs.nix-index-database.darwinModules.nix-index
  ];
}
