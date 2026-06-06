{pkgs, shellAliases, brewHook, ...}:
{
  programs.bash = {
    enable = true;
    package = pkgs.bash;
    inherit shellAliases;
    initExtra = brewHook;
  };
}
