{ pkgs, options, ... }:
(if options ? environment.shellAliases then {
  environment.shellAliases = {
    # Replace find with fd for faster searches and saner defaults.
    find = "fd";
  };
} else { })
// (if options ? environment.systemPackages then {
  environment.systemPackages = [ pkgs.fd ];
} else { })
// (if options ? programs.fd then {
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [ ".git/" ];
  };
} else { })
