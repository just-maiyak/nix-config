{pkgs, ...}:

let
  zoxideHandle = "cd";
in
{
    programs.zoxide = {
      enable = true;
      package = pkgs.zoxide;
      enableBashIntegration = true;
      options = [ "--cmd" zoxideHandle ];
    };
}
