{ inputs, ... }: {
  imports = [inputs.walker.homeManagerModules.default];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      placeholders."default" = { input = "Search"; list = "Example"; };
      keybinds.quick_activate = ["1" "2" "3" "4" "5" "6" "7" "8"];
    };
  };
}
