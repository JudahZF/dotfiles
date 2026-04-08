{ pkgs, options, ... }:
(if options ? environment.systemPackages then {
  environment.systemPackages = [ pkgs.starship ];
} else { })
// (if options ? programs.starship then {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
} else { })
