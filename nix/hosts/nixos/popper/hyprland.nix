{ ... }: {
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "HDMI-A-3, 1920x1080@100, 0x0, 1"
        "HDMI-A-2, 1920x1080@100, 1920x0, 1"
      ];
    };
  };
}
