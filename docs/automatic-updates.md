# Automatic dependency and machine updates

Dependency updates are generated centrally by GitHub Actions and consumed from the protected `main` branch. Machines never update flake inputs locally.

## GitHub setup

1. Create a fine-grained personal access token scoped to this repository only, with **Contents** and **Pull requests** set to read and write. Store it as the repository Actions secret `DOTFILES_AUTOMATION_TOKEN`.
2. Turn on **Allow auto-merge** in the repository settings.
3. Protect `main`:
   - require changes to arrive through pull requests;
   - require the `Required gate` status from the `Flake Check` workflow;
   - do not allow bypassing the required checks.

The automation token is separate from the workflow's `GITHUB_TOKEN` on purpose. GitHub does not start workflow runs for pushes and pull requests made with `GITHUB_TOKEN`, so the update pull request checks would never run. The workflow's own `GITHUB_TOKEN` is still used for GitHub API-backed Nix inputs and release checks.

Checks run on GitHub-hosted `ubuntu-latest` runners, which install Nix on each run. Fork pull requests skip the jobs.

## Scheduled updater

`.github/workflows/update-pins.yml` runs at 00:00, 03:00, 06:00, and every three hours thereafter in UTC. It can also be started from the Actions UI.

The workflow:

1. runs `nix/_internal_update.sh`, which updates T3 Code and the Origin CLI before the flake lock;
2. exits without creating a pull request when nothing changed;
3. rejects changes outside `nix/flake.lock`, `nix/packages/t3code.nix` and `nix/packages/origin.nix`;
4. replaces the bot-owned `automation/update-pins` branch;
5. creates one pull request if none is open and enables a squash auto-merge that runs once the required checks pass.

Disable dependency updates by disabling the workflow in GitHub or removing its schedule. Existing machines will continue consuming already-approved commits.

## Machine behavior

- `popper` and `squirrel` check after boot and one hour after each completed run.
- `zevlor` checks once after boot.
- `gale` checks at user login and hourly while the user session is available.

A machine updates only when its checkout:

- is the configured repository (`origin` must be exactly `https://github.com/JudahZF/dotfiles.git`) on `main`;
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
