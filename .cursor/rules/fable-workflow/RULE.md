---
description: "Fable 5 model routing, workflows, and Claude/Cursor delegation rules for this dotfiles repo"
alwaysApply: true
---

# Fable Workflow

Managed Claude source files live under `claude/` and are linked into `~/.claude` by Home Manager. Cursor should use this project rule plus `AGENTS.md`; do not edit generated files directly in `~/.claude` or Cursor's private storage.

Use Fable for orchestration, architecture, user-facing APIs, UI/copy, and final judgment. Keep Fable reasoning at high or below by default. Use GPT-5.5 through Cursor Agent for bounded mechanical work, broad investigation, computer-use verification, and independent reviews.

Model routing defaults:

- `gpt-5.5`: cheap, strong intelligence, lower taste
- `sonnet-5`: moderate cost, decent taste
- `opus-4.8`: strong review/taste fallback
- `fable-5`: primary high-intelligence, high-taste orchestrator

For this dotfiles repo:

- Config is managed through Nix/Home Manager.
- Make pi agent changes under `pi/agent`, not directly under `~/.pi/agent`.
- Respect the dirty worktree. Never revert unrelated user changes.
- Theo-style goal mode is opt-in only; do not close or merge PRs unless the user explicitly grants that permission.
