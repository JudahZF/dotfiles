{ pkgs, lib, username, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  system = {
    stateVersion = 6;
    primaryUser = username;
  };

  users.users.${username}.home = "/Users/${username}";
}
