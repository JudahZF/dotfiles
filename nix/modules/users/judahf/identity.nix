{ config, pkgs, ... }:
{
  home = {
    username = if pkgs.stdenv.isDarwin then "judahfuller" else "judahf";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/judahfuller" else "/home/judahf";
  };

  programs.git = {
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/personal";
      signByDefault = true;
    };
    settings.user = {
      email = "judah@judahfuller.com";
      name = "Judah Fuller";
    };
  };
}
