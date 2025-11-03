{ ... }: {
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      keybinds.quick_activate = [ "F1" "F2" "F3" "F4" ];
      debug = true;
    };
  };
}
