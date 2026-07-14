---
name: codex-review
description: Ask Codex (GPT-5.5) for an independent review of uncommitted changes, a branch diff, a commit, a plan, or a specific implementation.
---

# Codex Review

Use this skill when the user asks for a second pass, an independent review, or when a change is broad enough that another agent perspective is useful.

## Workflow

1. Identify the exact review target: uncommitted changes, a branch diff, a commit, a plan, or a named implementation.
2. Run Codex read-only with a focused, self-contained review prompt.
3. Read the report.
4. Verify important claims against the code before presenting them.
5. If GPT-5.5 finds nothing, say that clearly and name the reviewed target.

## Command Pattern

```sh
codex exec -C "$PWD" --sandbox read-only -o "$REPORT_FILE" "<focused review prompt>"
```

For diff reviews, Codex's built-in review mode already collects the diff:

```sh
codex exec review --uncommitted      # staged, unstaged, and untracked changes
codex exec review --base main        # branch diff against main
```

Model and reasoning effort come from `~/.codex/config.toml` (`gpt-5.5`); override with `-m <model>` or `-c model_reasoning_effort=<level>` only when the default is wrong for the task.

## Prompt Shape

Keep the delegated prompt simple. Tell GPT-5.5:

- what to review
- that it must not edit files
- to prioritize correctness bugs, regressions, security/data-loss risks, and missing tests
- to write findings with file/line references when possible
- to say clearly when it finds no issues

Do not forward a giant conversation transcript when a short target description plus the relevant diff is enough.
