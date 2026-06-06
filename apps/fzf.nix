{pkgs, ...}:

{
  programs.fzf = {
    enable = true;
    package = pkgs.fzf;
    enableBashIntegration = true;
  };
}
