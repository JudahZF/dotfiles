{ pkgs, options, ... }:
(if options ? environment.systemPackages then {
  environment.systemPackages = [ pkgs.zoxide ];
} else { })
// (if options ? programs.zoxide then {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };
} else { })
