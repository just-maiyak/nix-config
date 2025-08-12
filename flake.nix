{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, lix-module, home-manager, stylix, tt-schemes, nvf }:
  {
    darwinConfigurations."stallion" = nix-darwin.lib.darwinSystem {
      modules =
        [ ./configuration.nix
	  lix-module.nixosModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useUserPackages = true;
	    home-manager.backupFileExtension = "bak";
            home-manager.users."just.maiyak".imports = [
	      nvf.homeManagerModules.default
	      ./home.nix
	    ];
          }
	  stylix.darwinModules.stylix
        ];
      specialArgs = { inherit inputs; };
    };
  };
}
