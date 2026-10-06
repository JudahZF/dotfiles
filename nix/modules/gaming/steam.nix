{
  lib,
  pkgs,
  pkgs-unstable ? null,
  system ? null,
  ...
}:
let
  latestPkgs = if pkgs-unstable != null then pkgs-unstable else pkgs;
in
(lib.optionalAttrs (system != null && lib.hasSuffix "-linux" system) {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  # Steam/Proton launchers expect host OpenGL/Vulkan libraries to be available
  # through /run/opengl-driver. 32-bit support is also required by Steam's
  # overlay/runtime even for many 64-bit games.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
    # niri keeps its intermediate spawn process alive until the app's systemd
    # scope exists. Steam's wrapper runs `bwrap --die-with-parent`, so when that
    # process exits, bwrap is killed before Steam logs anything. Launchers that
    # spawn through niri then fail while a terminal works (niri-wm/niri#2463).
    package = pkgs.steam.override {
      buildFHSEnv = args: pkgs.buildFHSEnv (args // { dieWithParent = false; });
      # Steam's client is X11, and bundled Qt builds (SteamVR's vrmonitor) ship
      # only the xcb plugin, so they abort under QT_QPA_PLATFORM=wayland. That
      # Qt is too old for the "wayland;xcb" fallback list.
      extraEnv.QT_QPA_PLATFORM = "xcb";
    };
    extraPackages = with pkgs; [ hidapi ];
    extraCompatPackages = [ latestPkgs.proton-ge-bin ];
    protontricks.enable = true;
  };

  # Steam uses bubblewrap for its pressure-vessel runtime. On this system another
  # module also installs a /run/wrappers/bin/bwrap setuid wrapper, but Nixpkgs'
  # bubblewrap is built without setuid support, causing:
  #   bwrap: setuid use of bubblewrap is not supported in this build
  # User namespaces work here, so force the wrapper to be non-setuid.
  security.wrappers.bwrap = {
    source = lib.getExe pkgs.bubblewrap;
    owner = "root";
    group = "root";
    permissions = "u+rx,g+rx,o+rx";
    setuid = lib.mkForce false;
  };

  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
  ];
})
// (lib.optionalAttrs (system != null && lib.hasSuffix "-darwin" system) {
  homebrew.casks = [ "steam" ];
})
