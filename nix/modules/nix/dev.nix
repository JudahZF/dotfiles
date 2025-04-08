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
		zed-editor
	];

	fonts.packages = [
    		pkgs.nerd-fonts.jetbrains-mono
    	];
}
