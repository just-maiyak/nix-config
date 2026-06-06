{pkgs, ...}:

{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableFishIntegration = true;
    settings = {
      window-padding-x = 12;
      window-padding-y = "0,6";
      background-blur = true;
      window-save-state = "always";
      background-opacity-cells = true;
    };
    installBatSyntax = true;
    installVimSyntax = true;
  };
}
