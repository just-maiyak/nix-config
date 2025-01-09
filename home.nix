{ config, pkgs, ... }:
{
  home.stateVersion = "24.11";

  programs = {

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    bash = {
      enable = true;
      shellAliases = {
        ls = "ls --color";
        ll = "ls -al --color";
      };
    };

    home-manager.enable = true;
  };
}
