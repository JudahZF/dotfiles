bash ~/dotfiles/**/_internal_update.sh

if [ $? -ne 0 ]; then
    echo "Failed to update"
    exit 1
fi

echo "Updated. Please rebuild."
exit 0
