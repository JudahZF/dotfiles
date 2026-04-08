{ pkgs, options, ... }:
(
  if options ? environment.shellAliases then {
    environment.shellAliases = {
      # Replace du with dua for a more readable disk-usage view.
      du = "dua";
    };
  } else { }
)
// (if options ? environment.systemPackages then {
  environment.systemPackages = [ pkgs.dua ];
} else { })
