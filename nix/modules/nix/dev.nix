{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        ansible
        cmake
        gitkraken
        go
        lazygit
	    nodejs
        pnpm
        postman
        python3
    ];

    fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
    ];
}
