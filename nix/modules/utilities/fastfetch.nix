{ pkgs, options, ... }:
(if options ? environment.shellAliases then {
  environment.shellAliases = {
    # Keep the neofetch muscle-memory while using fastfetch underneath.
    neofetch = "fastfetch";
  };
} else { })
// (if options ? environment.systemPackages then {
  environment.systemPackages = [ pkgs.fastfetch ];
} else { })
// (if options ? programs.fastfetch then {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = { padding = { top = 2; }; };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "display"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "localip"
        "locale"
        "break"
        "colors"
      ];
    };
  };
} else { })
