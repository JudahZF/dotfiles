{ options, ... }:
if options ? programs.bat then {
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
      style = "numbers,changes,header";
    };
  };
} else { }
