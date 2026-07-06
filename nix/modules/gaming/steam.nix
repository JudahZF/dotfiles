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
  # Steam/Proton launchers expect host OpenGL/Vulkan libraries to be available
  # through /run/opengl-driver. 32-bit support is also required by Steam's
  # overlay/runtime even for many 64-bit games.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
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
    permissions = "0755";
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
