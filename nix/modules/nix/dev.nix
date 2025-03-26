{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        ansible
        cmake
        gitkraken
        go
	lua
	luarocks-nix
	nodejs
        pnpm
        postman
        python3
        zed
    ];

    fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
    ];
}
