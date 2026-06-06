{pkgs, shellAliases, brewHook, ...}:

{
  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    inherit shellAliases;
    initContent = brewHook;
  };
}
