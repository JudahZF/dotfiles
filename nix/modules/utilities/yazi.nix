{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
      };
    };
  };

  home.packages = with pkgs; [
    ffmpegthumbnailer
    poppler
    fd
    ripgrep
    jq
    unar
  ];
}
