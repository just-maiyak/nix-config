{pkgs, vars, ...}:

{
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    inherit (vars) shellAliases;
    loginShellInit = vars.brewHook;
  };
}
