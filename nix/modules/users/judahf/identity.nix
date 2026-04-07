{ pkgs, ... }: {
  home = {
    username = if pkgs.stdenv.isDarwin then "judahfuller" else "judahf";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/judahfuller" else "/home/judahf";
  };
}
