{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    difftastic = {
      options.color = "always";
      enableAsDifftool = true;
      enable = true;
    };
    extraConfig = if pkgs.stdenv.isDarwin then {
      gpg."ssh".program =
        "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    } else {
      gpg."ssh".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
    };
    lfs = { enable = true; };
    ignores = [ ".env" ];
    signing = {
      format = "ssh";
      key =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg+m/SsrTx6+3t00tabRdDLms4jYrxGwlh8gG7ZkIsO";
      signByDefault = true;
    };
    userEmail = "judah@judahfuller.com";
    userName = "Judah Fuller";
  };
}
