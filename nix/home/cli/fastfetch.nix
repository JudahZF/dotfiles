{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        padding = {
          top = 2;
        };
      };
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
}
