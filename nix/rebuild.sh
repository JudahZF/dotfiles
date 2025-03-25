darwin-rebuild switch --impure --flake ~/dotfiles/nix#pro

# Wait for Homebrew services to be available
sleep 2

# Only run yabai if it exists
if command -v yabai >/dev/null 2>&1; then
    sudo yabai --load-sa
fi

sleep 1

# Only run sketchybar if it exists
if command -v sketchybar >/dev/null 2>&1; then
    sketchybar --reload
fi
