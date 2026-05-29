{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ xwayland-satellite ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam.gamescopeSession = {
    enable = true;

    # Steam's Big Picture overlay is rendered in its own Xwayland client in
    # game-mode sessions. Without this, gamescope can put the overlay on the
    # wrong surface/display or fail to composite it above the game correctly.
    env.STEAM_MULTIPLE_XWAYLANDS = "1";
  };
}
