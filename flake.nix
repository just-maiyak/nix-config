{
  description = "Маяк's nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    tt-schemes.url = "github:tinted-theming/schemes";
    tt-schemes.flake = false;

  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    stylix,
    nvf,
    tt-schemes,
    ...
  } @ inputs:
  let
    libs = nixpkgs.lib // nix-darwin.lib // import ./lib;
    vars = import ./vars;
    specialArgs = {};

    stallion = import ./hosts/stallion {
        inherit inputs libs vars specialArgs;
      };

    furrball = import ./hosts/furrball {
        inherit inputs libs vars specialArgs;
      };

    behemoth = import ./hosts/behemoth {
        inherit inputs libs vars specialArgs;
      };
  in
  {
    darwinConfigurations = { inherit stallion furrball; };
    homeConfigurations = { inherit behemoth; };
  };
}
