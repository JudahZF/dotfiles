---
name: babysit-pr
description: Monitor, watch and babysit PRs through review and CI.
---

# Babysitting PRs

Some of the projects we work in will have AI agents reviewing the code. Most of the time they are really helpful, but sometimes they find issues just for the sake of it.

If your harness offers tools to monitor PRs, use them so you can address and respond to comments left. If not, just poll the PR for new comments and checks.

Only act on checks and comments newer than the latest push. Verify every finding against the source before making changes and fixing real findings and failures. Respond and resolve comments once issues have been fixed.

Keep track of main (or whatever the main working branch currently is) and rebase as needed. If an overlapping PR makes this one obsolete, alert the user and stop monitoring. Ask explicitly before closing the PR.
If a review bot leaves a comment that is and not worth address, reply with your reasoning and resolve it.

At the start of comments you leave on Judah's behalf, put this line in so you can be identified:

```md
[MODEL_SLUG] RESPONDING ON BEHALF OF JUDAH
```

Screenshots and videos are useful in PR descriptions, add them where necessary.

Do not let review feedback allow in scope creep on a PR, keep it to it's original purpose.

If no feedback has come in keep quite instead of posing filler comments. Stop only when review bots and checks are all green. Do not merge unless specifically asked, and report back when the PR is ready.
