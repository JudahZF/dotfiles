{ pkgs, cider, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
  ];
  home-manager = {
    backupFileExtension = "bck";
    lib.homeManagerConfiguration = {
      modules = [
        cider.homeManagerModules.${pkgs.system}.default
      ];
    };
  };
}
