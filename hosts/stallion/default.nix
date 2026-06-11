{
  inputs, libs, vars, specialArgs, ...
}:
let
    username = "just.maiyak";

    mkDarwinSystem =
      {
        inputs,
        specialArgs ? { },
        darwin-modules,
        home-modules ? [ ]
      }:
      inputs.nix-darwin.lib.darwinSystem {
        inherit inputs specialArgs;
        modules =
          darwin-modules
          ++ [
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                backupFileExtension = "bak";
                extraSpecialArgs = specialArgs // {inherit libs vars;};
                users.${username}.imports = home-modules;
              };
            }
          ];
        };
in
mkDarwinSystem {
  inherit inputs specialArgs;
  darwin-modules =
    [ ./configuration.nix
      inputs.stylix.darwinModules.stylix
    ];

  home-modules =
    [ ../../hm/stallion.nix
      inputs.nvf.homeManagerModules.default
    ];
}
