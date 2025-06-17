{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      claude-code
      cmake
      ghidra
      gitkraken
	git-lfs
		go
      lazygit
      nodejs
      phpactor
    	pnpm
      postman
      python3
      ruff
      zed-editor
    ];

	fonts.packages = [
    		pkgs.nerd-fonts.jetbrains-mono
    	];
}
