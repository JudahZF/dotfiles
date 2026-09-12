{
  config,
  dotfiles,
  pkgs,
  pkgs-unstable ? null,
  lib,
  username,
  ...
}:
let
  unstable = if pkgs-unstable != null then pkgs-unstable else pkgs;

  # Claude Code routed through CLIProxyAPI. These wrappers are the single source
  # of truth for the `cl`/`clx` aliases and T3 Code's Claude provider instances.
  # Codex holds the same key in ~/.codex/config.toml; rotating means both places.
  cliproxySecret = dotfiles + "/secrets/cliproxyapi.yaml";
  hasCliproxyKey = builtins.pathExists cliproxySecret;
  cliproxyKeyPath = config.sops.secrets.cliproxyapi-key.path;
  cliproxyEnv = {
    ANTHROPIC_BASE_URL = "https://cliprox.tabby-ilish.ts.net";
  };
  claudeWrapper =
    name: runtimeEnv:
    pkgs.writeShellApplication {
      inherit name runtimeEnv;
      text = ''
        ANTHROPIC_AUTH_TOKEN="$(cat ${cliproxyKeyPath})"
        export ANTHROPIC_AUTH_TOKEN
        exec ${lib.getExe unstable.claude-code} "$@"
      '';
    };
  claude-cl = claudeWrapper "claude-cl" cliproxyEnv;
  # Astra is the default; Opus and subagents route to Sol, Sonnet to Terra, Haiku to Luna.
  # The context cap matches Astra (272k), the smallest window in the set.
  claude-clx = claudeWrapper "claude-clx" (
    cliproxyEnv
    // {
      ANTHROPIC_MODEL = "gpt-6-astra";
      ANTHROPIC_DEFAULT_FABLE_MODEL = "gpt-6-astra";
      ANTHROPIC_DEFAULT_OPUS_MODEL = "gpt-5.6-sol";
      ANTHROPIC_DEFAULT_SONNET_MODEL = "gpt-5.6-terra";
      ANTHROPIC_DEFAULT_HAIKU_MODEL = "gpt-5.6-luna";
      CLAUDE_CODE_SUBAGENT_MODEL = "gpt-5.6-sol";
      CLAUDE_CODE_ALWAYS_ENABLE_EFFORT = "1";
      CLAUDE_CODE_MAX_CONTEXT_TOKENS = "272000";
      CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY = "3";
      CLAUDE_CODE_MAX_RETRIES = "2";
      ENABLE_TOOL_SEARCH = "false";
    }
  );

  # Codex CLI on the cliproxyapi provider from ~/.codex/config.toml. `codex` stays
  # PATH-resolved because the npm release runs ahead of the nixpkgs one.
  codex-cx = pkgs.writeShellApplication {
    name = "codex-cx";
    text = ''
      exec codex \
        -c model_provider="cliproxyapi" \
        --dangerously-bypass-approvals-and-sandbox \
        "$@"
    '';
  };

  t3codeNightlySupported =
    pkgs.stdenv.isDarwin || (pkgs.stdenv.isLinux && pkgs.stdenv.hostPlatform.isx86_64);
  t3codeNightly = import ../../../packages/t3code.nix { inherit pkgs lib; };
  clawhub = import ../../../packages/clawhub.nix { inherit pkgs lib; };
  clawpack-cli = import ../../../packages/clawpack-cli.nix { inherit pkgs lib; };
  postplan = import ../../../packages/postplan.nix { inherit pkgs lib; };
in
{
  environment.systemPackages = [
    unstable.claude-code
    unstable.ccusage
    unstable.codex
    unstable.opencode
    unstable.pi-coding-agent
    unstable.prettier
    clawhub
    clawpack-cli
    postplan
    claude-cl
    claude-clx
    codex-cx
  ]
  ++ lib.optional t3codeNightlySupported t3codeNightly;

  sops.secrets = lib.mkIf hasCliproxyKey {
    cliproxyapi-key = {
      sopsFile = cliproxySecret;
      key = "api_key";
      owner = username;
      group = if pkgs.stdenv.isDarwin then "staff" else "users";
      mode = "0400";
    };
  };

  # Explicitly opt into skipping Claude Code permission prompts.
  environment.shellAliases = {
    cl = "claude-cl --dangerously-skip-permissions";
    clx = "claude-clx --dangerously-skip-permissions";

    # config.toml already sets approval_policy = never and danger-full-access.
    cx = "codex-cx";
  };
}
