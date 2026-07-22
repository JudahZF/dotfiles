# Dotfiles Agent Instructions

## Repository Management

- This repo manages machine configuration through Nix and Home Manager.
- Do not edit generated home files directly when a source exists in this repo.
- Pi agent configuration is managed from `pi/agent`, not directly in `~/.pi/agent`.
- Never rg in /nix/store

## Verification

When you write or modify code, typecheck, lint, and format before finishing.

- Prefer repository commands first: `just fmt`, `just lint-nix`, `just fmt-check`, and `just check-current`.
- If a required check cannot run or fails because of existing unrelated repo state, report that clearly.
- Do not invent one-off checks when this repo already has a standard command.

## Model Routing

Use Fable as the main orchestrator for planning, architecture, user-facing APIs, UI/copy, and final judgment. Keep Fable reasoning at high or below unless explicitly told otherwise.

Use cheaper models for bounded mechanical work, log/PDF/spec reading, broad investigation, computer-use verification, and independent review. For shippable work, prioritize intelligence, then taste, then cost.

| model    | cost | intelligence | taste |
| -------- | ---- | ------------ | ----- |
| gpt-5.6  | 9    | 8            | 5     |
| sonnet-5 | 5    | 5            | 7     |
| opus-4.8 | 4    | 6            | 8     |
| fable-5  | 2    | 9            | 9     |
| grok-4.5 | 2    | 7            | 6     |

## Goal Mode

Theo-style long-running goal mode is opt-in only. Only close PRs, merge branches, rebase, or run until completion when the user explicitly grants that permission in the prompt.
