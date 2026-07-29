{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  # T3 Code registers its own user service via T3 Connect; linger keeps it
  # running without an active login session.
  users.users.judahf.linger = true;
}
