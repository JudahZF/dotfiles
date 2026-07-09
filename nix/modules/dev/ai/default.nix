{
  pkgs,
  pkgs-unstable ? null,
  lib,
  ...
}:
let
  unstable = if pkgs-unstable != null then pkgs-unstable else pkgs;
  t3codeNightlySupported =
    pkgs.stdenv.isDarwin || (pkgs.stdenv.isLinux && pkgs.stdenv.hostPlatform.isx86_64);
  t3codeNightly = import ../../../packages/t3code.nix { inherit pkgs lib; };
  clawhub = import ../../../packages/clawhub.nix { inherit pkgs lib; };
  clawpack-cli = import ../../../packages/clawpack-cli.nix { inherit pkgs lib; };
in
{
  environment.systemPackages = [
    unstable.claude-code
    unstable.codex
    unstable.opencode
    unstable.pi-coding-agent
    unstable.prettier
    clawhub
    clawpack-cli
    pkgs.ollama
  ]
  ++ lib.optional t3codeNightlySupported t3codeNightly;

  # Explicitly opt into skipping Claude Code permission prompts.
  environment.shellAliases = {
    cc-yolo = "claude --dangerously-skip-permissions";
  };
}
