_: {
  home = {
    enableNixpkgsReleaseCheck = false;
    sessionPath = [ "$HOME/.bun/bin" ];

    # Reflects the original install; do not bump with channel upgrades.
    stateVersion = "24.05";
  };
}
