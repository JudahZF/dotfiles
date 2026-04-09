{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _1password-gui
    _1password-cli
  ];

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      .zen
      helium
    '';
    mode = "0755";
  };
}
