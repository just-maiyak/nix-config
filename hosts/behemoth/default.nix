{
  inputs, libs, vars, specialArgs, ...
}:
let
  username = "yefimchuk";
in
{
  ${username} = libs.mkHomeManagerSystem {
    inherit inputs libs vars specialArgs;
    home-modules = [
      ../../hm/${username}.nix
      inputs.stylix.homeModule.stylix
    ];
  };
}
