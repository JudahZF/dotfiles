{ dotfiles, ... }:
let
  managed = source: {
    inherit source;
    force = true;
  };
in
{
  home.file = {
    ".claude/CLAUDE.md" = managed "${dotfiles}/claude/CLAUDE.md";
    ".claude/settings.json" = managed "${dotfiles}/claude/settings.json";
    ".claude/skills/codex-review" = managed "${dotfiles}/claude/skills/codex-review";
    ".claude/skills/codex-implementation" = managed "${dotfiles}/claude/skills/codex-implementation";
    ".claude/skills/codex-computer-use" = managed "${dotfiles}/claude/skills/codex-computer-use";
  };
}
