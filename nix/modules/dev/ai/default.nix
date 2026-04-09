{ inputs, pkgs, pkgs-unstable ? null, lib, ... }:
let
  unstable = if pkgs-unstable != null then pkgs-unstable else pkgs;
  system = pkgs.stdenv.system;
in
lib.mkMerge [
  {
    environment.systemPackages =
      [ unstable.claude-code unstable.opencode unstable.prettier pkgs.ollama ]
      ++ (
        if builtins.hasAttr system inputs.t3code.packages then
          [ inputs.t3code.packages.${system}.default ]
        else
          [ ]
      );
    environment.shellAliases = {
      cc = "claude --dangerously-skip-permissions";
    };
  }
]
