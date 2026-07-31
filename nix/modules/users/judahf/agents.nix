{ dotfiles, lib, ... }:
let
  managed = source: {
    inherit source;
    force = true;
  };

  skills = [
    "babysit-pr"
    "design"
    "file-pr"
    "html-communication"
    "postplan"
    "workflows"
  ];

  # Symlink every shared skill into an agent's skills directory.
  skillLinks =
    dir:
    lib.listToAttrs (
      map (name: {
        name = "${dir}/${name}";
        value = managed "${dotfiles}/agents/skills/${name}";
      }) skills
    );

  globalInstructions = managed "${dotfiles}/agents/AGENTS.md";
in
{
  home.file = {
    ".claude/CLAUDE.md" = globalInstructions;
    ".codex/AGENTS.md" = globalInstructions;
    ".cursor/AGENTS.md" = globalInstructions;
  }
  // skillLinks ".claude/skills"
  // skillLinks ".codex/skills"
  // skillLinks ".cursor/skills";
}
