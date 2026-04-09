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

    secrets.git-crypt-key = {
      sopsFile = "${dotfiles}/secrets/git-crypt-key";
      format = "binary";
      path = "${homeDir}/.git-crypt-key";
      owner = username;
      mode = "0400";
    };
  };
}
