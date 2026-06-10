{
  description = "JF Flake";
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    dotfiles = {
      url = "path:..";
      flake = false;
    };

    elephant.url = "github:abenz1267/elephant";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-browser = {
      url = "github:Ev357/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };

    custom-packages = {
      url = "git+https://codeberg.org/JudahZF/nix-packages.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-zerobrew = {
      url = "github:JudahZF/nix-zerobrew/v0.3.1-1";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nix-xcodes = {
      url = "git+https://codeberg.org/JudahZF/nix-xcodes.git";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    homebrew-bevanjkay-tap = {
      url = "github:bevanjkay/homebrew-tap";
      flake = false;
    };

    homebrew-gcenx-wine = {
      url = "github:Gcenx/homebrew-wine";
      flake = false;
    };

    homebrew-filosottile-musl-cross = {
      url = "github:FiloSottile/homebrew-musl-cross";
      flake = false;
    };

    homebrew-withgraphite-tap = {
      url = "github:withgraphite/homebrew-tap";
      flake = false;
    };

    homebrew-steipete-tap = {
      url = "github:steipete/homebrew-tap";
      flake = false;
    };

    homebrew-koekeishiya-formulae = {
      url = "github:koekeishiya/homebrew-formulae";
      flake = false;
    };

    homebrew-jackielii-tap = {
      url = "github:jackielii/homebrew-tap";
      flake = false;
    };

    homebrew-felixkratz-formulae = {
      url = "github:FelixKratz/homebrew-formulae";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-xilinx = {
      url = "github:MIT-OpenCompute/xilinx-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:JudahZF/nvf/telescope_gitFiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    t3code.url = "github:Sawrz/t3code-nix";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules/default.nix);
}
