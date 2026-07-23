# Automatic dependency and machine updates

Dependency updates are generated centrally by Codeberg Actions and consumed from the protected `main` branch. Machines never update flake inputs locally.

## Codeberg setup

1. Enable repository Actions.
2. Register an isolated x86_64 Linux runner with the label `nix-linux`.
   - The runner must provide Nix with flakes enabled, Git, Bash, curl, and jq.
   - Do not run untrusted fork pull requests on a personal workstation.
3. Create a dedicated Codeberg automation account with write access only to this repository.
4. Add these repository Actions secrets:
   - `DOTFILES_AUTOMATION_USER`: the automation account username.
   - `DOTFILES_AUTOMATION_TOKEN`: an access token for pushing the bot branch and managing its pull request.
   - `NIX_GITHUB_TOKEN`: optional GitHub token used only for GitHub API-backed Nix inputs and T3 Code release checks.
5. Protect `main`:
   - require changes to arrive through pull requests;
   - require the `Required gate` status from the `Flake Check` workflow;
   - do not allow the automation account to bypass required checks.

The automation token is intentionally separate from Forgejo's per-workflow token. Forgejo suppresses new workflow runs for pushes authenticated with its automatic token, which would prevent the update pull request checks from starting.

## Scheduled updater

`.forgejo/workflows/update-pins.yml` runs at 00:00, 03:00, 06:00, and every three hours thereafter in UTC. It can also be started from the Actions UI.

The workflow:

1. runs `nix/_internal_update.sh`, which updates T3 Code before the flake lock;
2. exits without creating a pull request when nothing changed;
3. rejects changes outside `nix/flake.lock` and `nix/packages/t3code.nix`;
4. replaces the bot-owned `automation/update-pins` branch;
5. creates or refreshes one pull request and schedules a squash merge after required checks pass.

Disable dependency updates by disabling the workflow in Codeberg or removing its schedule. Existing machines will continue consuming already-approved commits.

## Machine behavior

- `popper` and `squirrel` check after boot and one hour after each completed run.
- `zevlor` checks once after boot.
- `gale` checks at user login and hourly while the user session is available.

A machine updates only when its checkout:

- is the configured repository on `main`;
- has no tracked or untracked changes;
- has no Git operation in progress;
- can fetch `origin/main` noninteractively; and
- can be advanced with a fast-forward-only merge.

No reset, restore, rebase, autostash, or automatic conflict resolution is used. If any precondition fails, the checkout and active system are left unchanged. The failure is logged and shown as a desktop notification when a graphical session is available.

Automated rebuilds use one Nix job and one core. A failed rebuild leaves the previous system generation active and is retried on the next scheduled run.

## Logs and troubleshooting

### NixOS

```sh
systemctl status dotfiles-auto-update.service
journalctl -u dotfiles-auto-update.service
systemctl list-timers dotfiles-auto-update.timer
```

Run once manually:

```sh
sudo systemctl start dotfiles-auto-update.service
```

### macOS

Logs are written to:

- `~/Library/Logs/dotfiles-auto-update.out.log`
- `~/Library/Logs/dotfiles-auto-update.err.log`

Run once manually:

```sh
launchctl kickstart -k "gui/$(id -u)/org.judahfuller.dotfiles-auto-update"
```

The passwordless Darwin rules permit only the exact unattended `darwin-rebuild` command and the exact command used by `just rebuild`. Because those commands evaluate the user-writable checkout as root, the checkout owner has root-equivalent control through Nix activation; this is an accepted tradeoff of using the editable checkout.
