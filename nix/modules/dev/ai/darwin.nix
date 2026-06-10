{ ... }:
{
  nix-zerobrew = {
    casks = [
      "cursor"
      "cursor-cli"
      "codex"
      "codex-app"
      # Disabled because the upstream Homebrew cask currently points at a 404
      # ToDesktop build URL, which makes `darwin-rebuild switch` fail.
      # "comfyui"
      "lm-studio"
      "steipete/tap/codexbar"
    ];
  };
}
