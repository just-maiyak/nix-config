{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/08e0c91d76e05a61ffe15bcd17ef7fa3160c5bd8";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, lix-module, home-manager, stylix, tt-schemes }:
  {
    darwinConfigurations."stallion" = nix-darwin.lib.darwinSystem {
      modules =
        [ ./configuration.nix
	  lix-module.nixosModules.default
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useUserPackages = true;
	    home-manager.backupFileExtension = "bak";
            home-manager.users."just.maiyak" = import ./home.nix;
          }
	  stylix.darwinModules.stylix
        ];
      specialArgs = { inherit inputs; };
    };
  };
}
