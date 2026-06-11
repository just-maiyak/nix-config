{libs, ...}:

{
  home.stateVersion = "26.05";

  home.sessionVariables.EDITOR = "nvim";

  targets.darwin = {
    copyApps = {
      enable = false;
      # disable checks as they're bugged
      # https://github.com/nix-community/home-manager/issues/8336
      enableChecks = false;
    };
    linkApps.enable = true;
  };

  imports = [
    ../apps/bash.nix
    ../apps/direnv.nix
    ../apps/fish.nix
    ../apps/fzf.nix
    ../apps/git.nix
    ../apps/ghostty.nix
    ../apps/k9s.nix
    ../apps/kitty.nix
    ../apps/man.nix
    ../apps/nvf.nix
    ../apps/starship.nix
    ../apps/wezterm.nix
    ../apps/zed.nix
    ../apps/zoxide.nix
    ../apps/zsh.nix
  ];

  programs.ghostty.settings.font-size = libs.mkForce 15;
  programs.home-manager.enable = true;
}
