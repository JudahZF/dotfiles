---
name: codex-review
description: Ask Cursor Agent with GPT-5.5 for an independent review of uncommitted changes, a branch diff, a commit, a plan, or a specific implementation.
---

# Codex Review

Use this skill when the user asks for a second pass, an independent review, or when a change is broad enough that another agent perspective is useful.

## Workflow

1. Identify the exact review target: uncommitted changes, a branch diff, a commit, a plan, or a named implementation.
2. Create a temporary report directory under `/tmp`.
3. Run Cursor Agent in read-only mode with a focused, self-contained review prompt.
4. Read the report.
5. Verify important claims against the code before presenting them.
6. If GPT-5.5 finds nothing, say that clearly and name the reviewed target.

## Command Pattern

```sh
agent -p --trust --workspace "$PWD" --model gpt-5.5-high --mode ask "<focused review prompt>"
```

## Prompt Shape

Keep the delegated prompt simple. Tell GPT-5.5:

- what to review
- that it must not edit files
- to prioritize correctness bugs, regressions, security/data-loss risks, and missing tests
- to write findings with file/line references when possible
- to say clearly when it finds no issues

Do not forward a giant conversation transcript when a short target description plus the relevant diff is enough.
