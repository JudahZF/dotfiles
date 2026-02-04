{ pkgs, ... }: {
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

  # Preview dependencies
  home.packages = with pkgs; [
    ffmpegthumbnailer # Video thumbnails
    poppler # PDF previews
    fd # File finding
    ripgrep # Content search
    jq # JSON preview
    unar # Archive preview
  ];
}
