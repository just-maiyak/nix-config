{
  inputs,
  libs,
  vars,
  pkgs,
  specialArgs ? { },
  username,
  home-modules,
}:
inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = specialArgs // { inherit inputs libs vars username; };
    modules = home-modules;
  }
