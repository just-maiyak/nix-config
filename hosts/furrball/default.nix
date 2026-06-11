{
  inputs, libs, vars, specialArgs, ...
}:
let
  username = "just.maiyak";
in
libs.mkDarwinSystem {
  inherit username inputs libs vars specialArgs;
  darwin-modules =
    [ ./configuration.nix
      inputs.stylix.darwinModules.stylix
    ];

  home-modules =
    [ ../../hm/furrball.nix
      inputs.nvf.homeManagerModules.default
    ];
}
