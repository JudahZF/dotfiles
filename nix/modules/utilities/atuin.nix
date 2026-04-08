{ options, ... }:
if options ? programs.atuin then {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = false;
      search_mode = "fuzzy";
      style = "compact";
    };
  };
} else { }
