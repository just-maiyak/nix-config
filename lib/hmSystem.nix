{
  inputs,
  libs,
  vars,
  specialArgs ? { },
  home-modules,
}:
inputs.home-manager.lib.homeManagerConfiguration {
    extraSpecialArgs = specialArgs // { inherit inputs libs vars; };
    modules = home-modules;
  }
