{ pkgs, options, ... }:
(if options ? environment.shellAliases then {
  environment.shellAliases = {
    # Replace grep with ripgrep for fast recursive searches by default.
    grep = "rg";
  };
} else { })
// (if options ? environment.systemPackages then {
  environment.systemPackages = [ pkgs.ripgrep ];
} else { })
// (if options ? programs.ripgrep then {
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/*"
    ];
  };
} else { })
