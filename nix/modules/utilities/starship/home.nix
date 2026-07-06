_: {
  programs.starship = {
    enable = true;
    # Initialized explicitly from zsh/macos/zshrc so the prompt is present even
    # if Home Manager integration ordering changes.
    enableZshIntegration = false;

    settings.nix_shell = {
      disabled = false;
      format = "via ❄️ [$state( $name)]($style) ";
      impure_msg = "impure";
      pure_msg = "pure";
      unknown_msg = "shell";
    };
  };
}
