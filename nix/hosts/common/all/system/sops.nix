{ pkgs, username, dotfiles, ... }:
let
  homeDir = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  sops = {
    defaultSopsFile = "${dotfiles}/secrets/secrets.yaml";

    age = {
      # Use SSH key for age decryption
      sshKeyPaths = [ "${homeDir}/.ssh/personal" ];
      # Generate age key from SSH key if it doesn't exist
      generateKey = false;
    };
  };
}
