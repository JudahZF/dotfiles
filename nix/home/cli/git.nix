{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    lfs = { enable = true; };
    ignores = [ ".env" ];
    signing = {
      format = "ssh";
      key =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg+m/SsrTx6+3t00tabRdDLms4jYrxGwlh8gG7ZkIsO";
      signByDefault = true;
    };
    settings = {
      user = {
        email = "judah@judahfuller.com";
        name = "Judah Fuller";
      };
      gpg.ssh.program = if pkgs.stdenv.isDarwin then
        "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
      else
        "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
    };
  };

  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      diffToolMode = true;
    };
    options.color = "always";
  };
}
