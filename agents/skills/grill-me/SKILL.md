---
name: grill-me
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

# Grill Me

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round, then wait for the user's answers before the next round.

## Asking a round

Ask with your harness's built-in question tool: `AskUserQuestion` in Claude Code, `request_user_input` in Codex, `AskQuestion` in Cursor. For each question:

- Give it a short header and put the context the user needs to decide in the question itself.
- Offer 2-3 distinct options, each with a one-line trade-off. Put your recommended option first and end its label with "(Recommended)".
- Don't add an "Other" option, the tools add free-text input themselves. For open questions, offer your best concrete guesses as options.

If the frontier has more questions than one call allows, split the round across back-to-back calls.

If no question tool is available, ask the round as a numbered list instead. Give each question its options and your recommended answer, and word it so "yes" accepts the recommendation.

## Moving the frontier

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. Don't ask the user for anything you could look up yourself (filesystem, tools, docs, etc.). If a lookup is wide or slow, run it in a background subagent and don't block on it: only the questions downstream of it wait, ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
