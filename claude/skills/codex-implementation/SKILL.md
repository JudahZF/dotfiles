---
name: codex-implementation
description: Delegate bounded mechanical implementation, migrations, bulk edits, or isolated fixes to Codex (GPT-5.5), usually in a worktree.
---

# Codex Implementation

Use this skill for clear-spec implementation, migrations, bulk edits, simple data analysis, or isolated fixes. Do not use it as the final authority for public API design, UI polish, or taste-heavy work unless Fable or Opus reviews the result afterward.

## Workflow

1. Make the task bounded and self-contained.
2. Prefer a worktree for anything that might conflict with current work.
3. Give Codex the relevant repo instructions in the prompt; it reads the repo's `AGENTS.md` but does not inherit Claude's global `CLAUDE.md`.
4. Require a concise summary of files changed and checks run.
5. Review the patch before final acceptance.

## Command Pattern

```sh
codex exec -C "$WORKTREE" --sandbox workspace-write "<bounded implementation prompt>"
```

Model and reasoning effort come from `~/.codex/config.toml` (`gpt-5.5`); override with `-m <model>` or `-c model_reasoning_effort=<level>` only when the default is wrong for the task.

## Guardrails

- Use `--sandbox workspace-write` for delegated edits; do not escalate to `danger-full-access` for ordinary implementation work.
- Keep the prompt plain and specific.
- Ask for the smallest working change.
- If the delegated agent touches too much, stop and review before continuing.
