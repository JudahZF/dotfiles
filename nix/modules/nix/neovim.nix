{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        fd
	    lua
	    luarocks-nix
        neovim
        rg
    ];
}
