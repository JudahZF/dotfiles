{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-home-manager
  ];
  home-manager.backupFileExtension = "bck";
}
