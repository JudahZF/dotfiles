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

    # Sol remains the default; per-call subagents route Haiku to Luna and Sonnet to Terra.
    claudex = "ANTHROPIC_BASE_URL=http://127.0.0.1:8317 ANTHROPIC_AUTH_TOKEN=sk-localhost ANTHROPIC_DEFAULT_FABLE_MODEL=gpt-5.6-sol ANTHROPIC_DEFAULT_OPUS_MODEL=gpt-5.6-sol ANTHROPIC_DEFAULT_SONNET_MODEL=gpt-5.6-terra ANTHROPIC_DEFAULT_HAIKU_MODEL=gpt-5.6-luna CLAUDE_CODE_SUBAGENT_MODEL=inherit CLAUDE_CODE_ALWAYS_ENABLE_EFFORT=1 CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY=3 ENABLE_TOOL_SEARCH=false claude --model gpt-5.6-sol";
  };
}
