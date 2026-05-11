{ ... }:
{
  programs.fzf = {
    enable = true;
    # Home Manager's generated fzf zsh integration currently emits
    # "can't change option: zle" on shell startup with fzf 0.62/zsh 5.9.
    # Keep fzf installed/configured, but don't source `fzf --zsh` from .zshrc.
    enableZshIntegration = false;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
      "--preview='bat --style=numbers --color=always --line-range :500 {}'"
    ];
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };
}
