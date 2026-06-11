{pkgs, vars, ...}:
{
  programs.bash = {
    enable = true;
    package = pkgs.bash;
    inherit (vars) shellAliases;
    initExtra = vars.brewHook;
  };
}
