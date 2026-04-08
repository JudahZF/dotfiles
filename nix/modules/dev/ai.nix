{ inputs, pkgs, pkgs-unstable ? null, lib, options, ... }:
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
  }
  (lib.mkIf (options ? environment.shellAliases) {
    environment.shellAliases = {
      cc = "claude --dangerously-skip-permissions";
    };
  })
  (lib.mkIf (pkgs.stdenv.isDarwin && options ? homebrew.casks) {
    homebrew.casks = [
      "codex"
      "codex-app"
      "comfyui"
      "lm-studio"
    ];
  })
  (lib.mkIf (pkgs.stdenv.isDarwin && options ? homebrew.casks) {
    homebrew = {
      casks = [ "steipete/tap/codexbar" ];
      taps = [ "steipete/tap" ];
    };
  })
]
