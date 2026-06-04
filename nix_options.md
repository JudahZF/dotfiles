 8. Impermanence / persistence planning

 If you ever want cleaner NixOS machines, consider adding impermanence for selected hosts.

 Great for:

 - keeping / ephemeral
 - explicitly declaring persisted dirs
 - reducing config drift

 Probably not urgent, but high payoff.

 ────────────────────────────────────────────────────────────────────────────────

 9. Declarative backup module

 I didn’t see backup tooling. Good candidates:

 - restic
 - borgbackup
 - syncthing

 A small reusable nix/modules/backups/restic.nix would be a strong addition.

 ────────────────────────────────────────────────────────────────────────────────

 10. Secrets audit / SOPS helper docs

 You already have sops-nix. A small docs/secrets.md or just secrets-edit command could make secret management
 easier months later.

 Example:

 ```sh
   just secrets-edit
   just secrets-rekey
