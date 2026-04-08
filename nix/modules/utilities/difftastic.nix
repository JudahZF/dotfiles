{ pkgs, options, ... }:
(
  if options ? environment.shellAliases then {
    environment.shellAliases = {
      # Route diff to difftastic for syntax-aware structural diffs.
      diff = "difftastic";
    };
  } else { }
)
// (if options ? environment.systemPackages then {
  environment.systemPackages = [ pkgs.difftastic ];
} else { })
