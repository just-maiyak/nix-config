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

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, stylix, tt-schemes, nvf, ... }:
  let
    vars = import ./vars;
    libs = nixpkgs.lib // nix-darwin.lib;
    args = {};
  in
  {
    darwinConfigurations.stallion = 
      import ./hosts/stallion { specialArgs = args; inherit inputs vars libs; };

    homeConfigurations.yefimchuk = import ./hosts/behemoth { specialArgs = args; inherit inputs vars libs; };
  };
}
