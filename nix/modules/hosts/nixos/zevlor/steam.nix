_: {
  # The Steam Frame dongle joins the headset's AP on 6 GHz. The kernel default
  # regdomain (WORLD) forbids 6 GHz, and the GB hint from the onboard Wi-Fi's
  # AP is dropped each time it roams, so association races the reset and fails.
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=GB
  '';

  # SteamVR's vrlink driver streams to the Frame over UDP 10400, on the LAN and
  # on the dongle. Remote Play's ports alone let the Frame pair but not stream.
  networking.firewall.allowedUDPPorts = [ 10400 ];

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
