{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        fd
	    lua5_1
	    luarocks-nix
        neovim
        ripgrep
    ];
}
