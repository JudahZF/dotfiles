---
name: Workflows and Subagents
description: How to run workflows optimally and pick subagent models
---

# Workflows

Workflows should be used when a piece of work can be split into multiple parallel tasks and phases, and should not be used for serial work.

A good usecase of workflows is triaging all PRs in a repo, which may often contain 3 stages: Understading the PR purpose, deciding whether it is needed, evaluating how effectively it achieves this, and the quality of the code. The first two stages can be run on dumber models with less taste, whilst the last stage requires a model with better taste.

When severial agents do work in parellel, state file ownership up front so they do not colide.

## Calling models

When inside t3code use T3 Codes MCP and 'delegate_task' tool to call models from any harness.

## Picking models

Below are my feelings about each of the models you can use for subagents and workflows. Higher is better, but it is a relative scale.

| model       | cost | intelligence | taste | perseverance |
| ----------- | ---- | ------------ | ----- | ------------ |
| gpt-6-astra | 6    | 7            | 5     | 9            |
| gpt-6.1-sol | 8    | 7            | 4     | 8            |
| gpt-6-luna  | 9    | 3            | 1     | 2            |
| opus 5.5    | 7    | 8            | 7     | 5            |
| fable 5.1   | 4    | 9            | 9     | 7            |

Cost reflects the cost on this machine, not public list price.
Intelligence represents how hard a problem the model can handle mostly unsupervised.
Taste covers UI/UX, code quality, API design, and copy.
Perseverance shows how willing a model is to run for a long time when solve a problem, sometimes doing extra unnecessary work.

### Extra context

- These are loose defaults, feel free to change the model if it's not performing well.
- User-facing work such as UI, copy, and API design needs taste >= 7.
- Reviews of plans, content or implementations require intelligence >= 7.

