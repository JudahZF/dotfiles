{
  inputs,
  mkUnstablePkgs,
  unfreeConfig,
  ...
}:
{
  flake.colmena = {
    meta = {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config = unfreeConfig;
      };
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
        username = "judahf";
        dotfiles = inputs.dotfiles;
        pkgs-unstable = mkUnstablePkgs "x86_64-linux";
      };
    };
  };
}
