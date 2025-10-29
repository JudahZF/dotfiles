{ ... }: {
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      keybinds.quick_activate = ["1" "2" "3" "4" "5" "6" "7" "8"];
    };
  };
}
