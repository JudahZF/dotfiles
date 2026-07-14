{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Default sops age key location differs between Linux and macOS, so pin
  # one path everywhere.
  keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
in
{
  home.sessionVariables.SOPS_AGE_KEY_FILE = keyFile;

  home.activation.generateSopsAgeKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "${keyFile}" ]; then
      mkdir -p "$(dirname "${keyFile}")"
      ${lib.getExe' pkgs.age "age-keygen"} -o "${keyFile}"
      chmod 600 "${keyFile}"
      echo "sops: generated a new age key for this machine." >&2
      echo "sops: either replace it with your personal age key, or add this key's public half to .sops.yaml and run 'sops updatekeys' on existing secrets." >&2
    fi
  '';
}
