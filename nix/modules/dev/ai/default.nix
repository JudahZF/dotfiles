{
  inputs,
  pkgs,
  pkgs-unstable ? null,
  lib,
  ...
}:
let
  unstable = if pkgs-unstable != null then pkgs-unstable else pkgs;
  system = pkgs.stdenv.system;
  clawhub = import ../../../packages/clawhub.nix { inherit pkgs lib; };
  clawpack-cli = import ../../../packages/clawpack-cli.nix { inherit pkgs lib; };
in
lib.mkMerge [
  {
    environment.systemPackages = [
      unstable.claude-code
      unstable.opencode
      unstable.pi-coding-agent
      unstable.prettier
      clawhub
      clawpack-cli
      pkgs.ollama
    ]
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
