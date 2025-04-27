{
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        	cmake
        	gitkraken
        	go
        	lazygit
		nodejs
        	pnpm
        	postman
        	python3
		zed-editor
	];

	fonts.packages = [
    		pkgs.nerd-fonts.jetbrains-mono
    	];
}
