# Secrets

Files in this directory are encrypted with [sops](https://github.com/getsops/sops)
using the [age](https://age-encryption.org) recipients listed in `.sops.yaml`.
They are committed encrypted — there is no git smudge/clean filter — so pulling
this repo never requires sops to be installed. A nix rebuild installs `sops`
and `age`. System secrets use the personal age key at
`/home/judahf/.config/sops/age/keys.txt` on NixOS and
`/Users/judahfuller/.config/sops/age/keys.txt` on macOS.

## Conventions

| Kind | Pattern | Storage |
| --- | --- | --- |
| Structured secrets (small) | `secrets/**/*.{yaml,yml,json,env,ini}` | plain git, decrypted `git diff` via `diff=sops` |
| Large encrypted blobs | `secrets/**/*.enc` | sops binary mode + Git LFS |

Wallpapers (`wallpapers/**`) are plain Git LFS, not encrypted.

## Day-to-day

```sh
just secret-edit secrets/foo.yaml          # create or edit in $EDITOR (encrypts on save)
just secret-encrypt big.tar.gz secrets/big.tar.gz.enc
just secret-decrypt secrets/big.tar.gz.enc big.tar.gz
```

## Tailscale enrollment

`secrets/tailscale.yaml` is optional. While it is absent, the flake declares no
Tailscale auth secret or enrollment job.

1. Before rebuilding, ensure the personal age private key exists at
   `/home/judahf/.config/sops/age/keys.txt` on each NixOS host and
   `/Users/judahfuller/.config/sops/age/keys.txt` on gale.
2. In the Tailscale admin console, create one reusable, preauthorized,
   user-owned auth key.
3. Run `just secret-edit secrets/tailscale.yaml` and add:

   ```yaml
   auth_key: <key>
   ```

4. Commit only the resulting SOPS ciphertext, then rebuild popper, squirrel,
   zevlor, and gale.
5. On gale, approve the macOS Tailscale system extension once when prompted.

The enrollment job retries startup, daemon, and network races only during the
current boot or login and stops after Tailscale reports `Running`. It has no
timer or periodic self-heal, so a later manual logout remains effective until
the next boot, login, or manual service start.

Auth-key expiry prevents future enrollment or re-enrollment; it does not end an
existing node session. If local Tailscale state is lost after the key expires,
rotate the encrypted `auth_key` before rebuilding. For ordinary user-owned
nodes that must stay logged in uninterrupted, disable device key expiry in the
Tailscale admin console. One reusable key and one shared age identity simplify
bootstrap, but compromise of either can permit unauthorized enrollment into the
shared tailnet; rotate both promptly if that shared trust is no longer
acceptable.

## Adding a machine

Pull works with nothing installed (encrypted files and LFS pointers check out
fine); rebuild to get the tooling. Then either put the personal age key at
`~/.config/sops/age/keys.txt`, or keep the auto-generated machine key and
grant it access:

1. Get its public key: `age-keygen -y ~/.config/sops/age/keys.txt`
2. Add it to `.sops.yaml` (under `keys:` and the `creation_rules` age list).
3. From a machine that already has access:
   `find secrets -type f ! -name README.md -exec sops updatekeys -y {} \;`
