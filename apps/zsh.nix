{pkgs, vars, ...}:

{
  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    inherit (vars) shellAliases;
    initContent = vars.brewHook;
  };
}
