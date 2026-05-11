{ ... }:
{
  programs.starship = {
    enable = true;
    # Initialized explicitly from zsh/macos/zshrc so the prompt is present even
    # if Home Manager integration ordering changes.
    enableZshIntegration = false;
  };
}
