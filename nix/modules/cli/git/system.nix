{ pkgs, ... }: {
  environment = {
    shellAliases = { lg = "lazygit"; };
    systemPackages = with pkgs; [
      git
      git-cliff
      git-lfs
      lazygit
    ];
  };
}
