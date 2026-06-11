{
  inputs, libs, vars, specialArgs, ...
}:
let
  mkHomeManagerSystem =
    {
      inputs,
      specialArgs ? { },
      home-modules,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = specialArgs // { inherit inputs libs vars; };
        modules = home-modules;
      };
in
mkHomeManagerSystem {
  inherit inputs specialArgs;
  home-modules = [
    ../../hm/yefimchuk.nix
    inputs.stylix.homeModule.stylix
  ];
}
