{ lib, pkgs, system ? null, ... }:
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
    protontricks.enable = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [ mangohud protonup-qt ];
}) // (lib.optionalAttrs (system != null && lib.hasSuffix "-darwin" system) {
  nix-zerobrew.casks = [ "steam" ];
})
