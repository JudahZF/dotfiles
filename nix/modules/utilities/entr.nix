{ pkgs, options, ... }:
(
  if options ? environment.shellAliases then {
    environment.shellAliases = {
      # Treat watch as entr so file-driven reruns use the preferred tool.
      watch = "entr";
    };
  } else { }
)
// (if options ? environment.systemPackages then {
  environment.systemPackages = [ pkgs.entr ];
} else { })
