# Secrets

Files in this directory are encrypted with [sops](https://github.com/getsops/sops)
using the [age](https://age-encryption.org) recipients listed in `.sops.yaml`.
They are committed encrypted — there is no git smudge/clean filter — so pulling
this repo never requires sops to be installed. A nix rebuild installs `sops`
and `age`, sets `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt`, and generates
a key there if the file is missing (replace it with the personal key if that
machine should use it instead).

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

## Adding a machine

Pull works with nothing installed (encrypted files and LFS pointers check out
fine); rebuild to get the tooling. Then either put the personal age key at
`~/.config/sops/age/keys.txt`, or keep the auto-generated machine key and
grant it access:

1. Get its public key: `age-keygen -y ~/.config/sops/age/keys.txt`
2. Add it to `.sops.yaml` (under `keys:` and the `creation_rules` age list).
3. From a machine that already has access:
   `find secrets -type f ! -name README.md -exec sops updatekeys -y {} \;`
