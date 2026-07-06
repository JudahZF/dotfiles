---
name: codex-computer-use
description: Ask Cursor Agent with GPT-5.5 to verify local app behavior that needs computer use, browser automation, simulators, screenshots, app launching, or independent runtime inspection.
---

# Codex Computer Use

Use this skill when testing a flow, verifying UI behavior, inspecting a running app, capturing screenshots, using simulators, launching apps, or independently checking runtime behavior would help complete or verify the work.

## Workflow

1. State the exact runtime behavior to verify.
2. Ask for concrete evidence: steps taken, screenshots or logs where useful, failures, passes, and a short verdict.
3. Keep the prompt simple and direct.
4. If the task times out, ask for partial evidence and next recommended step instead of silently retrying forever.

## Command Pattern

```sh
agent -p --trust --workspace "$PWD" --model gpt-5.5-high --force "<runtime verification prompt>"
```

## Prompt Shape

Tell GPT-5.5:

- what app or flow to launch
- what success looks like
- what evidence to return
- whether it may edit files or should only inspect

Use this for runtime confidence. Still run the repository's normal typecheck, lint, format, and test commands before calling the task done.
