{ pkgs, options, ... }:
if options ? environment.systemPackages then {
  environment.systemPackages = [ pkgs.zellij ];
} else { }
