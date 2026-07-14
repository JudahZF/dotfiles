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
    ".claude/skills/codex-review" = managed "${dotfiles}/claude/skills/codex-review";
    ".claude/skills/codex-implementation" = managed "${dotfiles}/claude/skills/codex-implementation";
    ".claude/skills/codex-computer-use" = managed "${dotfiles}/claude/skills/codex-computer-use";
    ".claude/skills/html-plans" = managed "${dotfiles}/claude/skills/html-plans";
    ".codex/skills/html-plans" = managed "${dotfiles}/claude/skills/html-plans";
  };
}
