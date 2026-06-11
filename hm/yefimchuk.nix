_:

{
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

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
}
