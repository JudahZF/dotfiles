# Code Verification Requirements

When you write or modify code, you must typecheck, lint, and format it before finishing the task.

- Prefer the repository's own commands and tools first, such as package scripts, Make targets, task runners, or documented project commands.
- If the repo does not define its own commands, use the default language or ecosystem tooling for the files you changed.
- Do not invent custom one-off commands when the repo already provides a standard way to run checks.
- If a formatter can fix files directly, run it on the changed files or use the repo's normal format command.
- If any required check cannot be run, or fails, say so clearly and explain why.
- In your final response, briefly state which typecheck, lint, and format commands or tools you ran.

## Picking Models for Workflows and Subagents

Rankings are defaults, not hard limits. Higher is better. Cost reflects the practical cost/availability on this machine, not public list price. Intelligence means how hard a problem the model can handle mostly unsupervised. Taste covers UI/UX, code quality, API design, and copy.

| model         | cost | intelligence | taste |
| ------------- | ---- | ------------ | ----- |
| gpt-5.6-sol   | 5    | 8            | 7     |
| gpt-5.6-terra | 7    | 5            | 5     |
| gpt-5.6-luna  | 9    | 3            | 3     |
| fable 5       | 3    | 9            | 9     |

How to apply:

- These are defaults, not limits. You have standing permission to escalate when the output is not good enough. Judge the output, not the price tag.
- Cost is a tie-breaker only. For anything that ships, intelligence > taste > cost.
- Bulk or mechanical work such as clear-spec implementation, migrations, and simple data analysis can go to GPT-5.6-luna first.
- User-facing work such as UI, copy, and API design needs taste >= 7.
- Reviews of plans or implementations should use Fable 5 or gpt-5.6-sol when an external second opinion is worthwhile.
- Never use Haiku unless the user explicitly asks for the cheapest possible Claude-family pass.


## Goal Mode

Theo-style long-running goal mode is opt-in only. Treat it as active only when the user explicitly says something like "start a goal", "run until complete", "keep going until these conditions pass", or "you have permission to branch/rebase/merge".

When goal mode is active, you may create worktrees, branch, rebase, open or close PRs, and merge only within the exact permissions the user granted in that prompt. Production deploys remain human-in-the-loop unless project-specific instructions explicitly say otherwise.

## Workflows and Subagents

- Use workflows for fan-out/fan-in analysis and verification, such as triaging many PRs or running independent review passes.
- Use session orchestration plus worktrees for checkpoint-driven work that needs CI, review, merges, rebases, or product decisions.
- Let Fable define task-specific subagents and reviewer archetypes instead of relying on a fixed stable of generic agents.
- Ask clarifying questions when a product decision blocks safe progress.
