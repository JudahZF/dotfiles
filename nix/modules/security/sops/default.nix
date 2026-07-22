{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  sops.age.keyFile =
    if pkgs.stdenv.isDarwin then
      "/Users/judahfuller/.config/sops/age/keys.txt"
    else
      "/home/judahf/.config/sops/age/keys.txt";
}
