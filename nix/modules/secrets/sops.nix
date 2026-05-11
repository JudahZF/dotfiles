{ pkgs, username, dotfiles, ... }:
let
  homeDir =
    if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
in {
  sops = {
    defaultSopsFile = "${dotfiles}/secrets/secrets.yaml";

    age = {
      sshKeyPaths = [ "${homeDir}/.ssh/personal" ];
      generateKey = false;
    };
  };
}
