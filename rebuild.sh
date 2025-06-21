sudo bash ~/dotfiles/**/_internal_rebuild.sh

if [ $? -ne 0 ]; then
    echo "Failed to rebuild"
    exit 1
fi

## Other commands

sudo yabai --load-sa
yabai --restart-service

fastfetch

exit 0
