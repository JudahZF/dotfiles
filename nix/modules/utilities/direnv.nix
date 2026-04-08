{ options, ... }:
if options ? programs.direnv then {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
} else { }
