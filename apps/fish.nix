{pkgs, shellAliases, brewHook, ...}:

{
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    inherit shellAliases;
    loginShellInit = brewHook;
  };
}
