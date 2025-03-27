bash ~/dotfiles/**/_internal_update.sh

if [ $? -ne 0 ]; then
    echo "Failed to update"
    exit 1
fi

bash ~/dotfiles/**/_internal_rebuild.sh

if [ $? -ne 0 ]; then
    echo "Failed to rebuild"
    exit 1
fi

softwareupdate -i -a

fastfetch

exit 0
