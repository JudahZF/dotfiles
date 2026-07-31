---
name: file-pr
description: File, open or create a consise pull request. 
---

# File PR

Before filing, check if a PR for this branch already exisits. Review the diff locally against 'origin/main' or whatever the working branch is to make sure it's content matches the goal.

PR titles should be human readable follow the purpose of the change, not one effect the change has. Following the users inital message for the change is often a good way to reach this. Use convential commit messages for PR titles and / or follow the repos conventions based on recently merged PRs.

Good PR title
> perf(server): negotiate per message deflate

Bad PR title
> perf(server): cut websocket frame size by 70%+ witch gzip

For the description, open with a simple explaination of the problems based on the original prompt, then a breif summary of the solution. Don't lead with an implemention inventory:

BAD
> Removed implicit workspace carry-over from every "new thread" entry point (cmd +n / cmd+shift+o, sidebar v1/v2 buttons, command palette). New threads inherit only the project from context; branch, worktree, and env mode always come from the configured defaults. Deleted buildContextualThreadOptions, startNewThreadInProjectFromContext, and the v1 sidebar's seed-context machinery.

GOOD
> My "new worktree" default was ignored when starting new threads on existing worktrees. Super unintuitive. Now your preferences always apply.

Open real PRs rather than drafts so review bots run. It the user asks you to babysite, continue with the `babysit-pr` skill.
