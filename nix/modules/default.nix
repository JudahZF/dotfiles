{ lib, ... }: {
  # Flake-level modules only. Category modules (browsers, desktop, utilities, …)
  # are not imported here; they are exposed as nixosModules/darwinModules/homeModules
  # via ./flake/exports.nix and pulled in per host.
  imports = [
    ./flake
    ./dev
    ./hosts/darwin/gale
    ./hosts/nixos/popper
    ./hosts/nixos/squirrel
    ./hosts/nixos/zevlor
  ]
  ++ lib.optionals (builtins.pathExists ./production) [ ./production ]
  ++ lib.optionals (builtins.pathExists ./hosts/nixos/jfpi) [ ./hosts/nixos/jfpi ];
}
