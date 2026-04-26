{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ xwayland-satellite ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam.gamescopeSession.enable = true;
}
