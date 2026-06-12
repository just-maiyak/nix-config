{
  inputs, libs, vars, pkgs, specialArgs, ...
}:
let
  username = "yefimchuk";
in
{
  ${username} = libs.mkHomeManagerSystem {
    inherit inputs libs pkgs specialArgs username;
    vars = vars // { brewHook = ""; };
    home-modules = [
      ../../hm/${username}.nix
      inputs.stylix.homeModules.stylix
      inputs.nvf.homeManagerModules.default
    ];
  };
}
