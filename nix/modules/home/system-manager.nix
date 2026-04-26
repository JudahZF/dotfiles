{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ home-manager ];
  home-manager.backupFileExtension = "bck";
}
