{ dotfiles, ... }:
let
  managed = source: {
    inherit source;
    force = true;
  };
in
{
  home.file = {
    ".pi/agent/AGENTS.md" = managed "${dotfiles}/pi/agent/AGENTS.md";
    ".pi/agent/settings.json" = managed "${dotfiles}/pi/agent/settings.json";
    ".pi/agent/package.json" = managed "${dotfiles}/pi/agent/package.json";
    ".pi/agent/pnpm-lock.yaml" = managed "${dotfiles}/pi/agent/pnpm-lock.yaml";
    ".pi/agent/extensions" = managed "${dotfiles}/pi/agent/extensions";
    ".pi/agent/themes" = managed "${dotfiles}/pi/agent/themes";
  };
}
