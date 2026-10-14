{
  description = "Маяк's nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Last first bad version 7989a1054b01153212dede6005abfd1576b8328c
    # Last good version cbe360bb8393d5239a97b343ae1ffbc18846673b
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    stylix,
    nvf,
    ...
  } @ inputs:
  let
    libs = nixpkgs.lib // nix-darwin.lib // import ./lib;
    vars = import ./vars;
    pkgs = nixpkgs;
    specialArgs = {};

    stallion = import ./hosts/stallion {
        inherit inputs libs vars specialArgs;
      };

    furrball = import ./hosts/furrball {
        inherit inputs libs vars specialArgs;
      };

    behemoth = import ./hosts/behemoth {
        inherit inputs libs vars specialArgs;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
  in
  {
    darwinConfigurations = { inherit stallion furrball; };
    homeConfigurations = { inherit (behemoth) yefimchuk; };
  };
}
