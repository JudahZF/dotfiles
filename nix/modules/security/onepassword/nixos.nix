{ pkgs, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "judahf" ];
  };

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      .zen
      helium
    '';
    mode = "0755";
  };
}
