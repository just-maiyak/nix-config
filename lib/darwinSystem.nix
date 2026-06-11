{
  inputs,
  libs,
  vars,
  username,
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
  }
