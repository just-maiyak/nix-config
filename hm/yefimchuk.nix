{username, pkgs, ...}:

{
  home = {
    stateVersion = "26.05";
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
        EDITOR = "nvim";
      };

    packages = with pkgs; [
      # CLI tools
      bat
      csvlens
      glow
      
      # GUI applications
      slack
    ];
  };

  programs.home-manager.enable = true;

  targets = {
      genericLinux = {
        enable = true;
        gpu = {
          enable = true;
          nvidia = {
            enable = true;
            version = "595.71.05";
            sha256 = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
          };
        };
      };
    };
  xdg.mime.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };

  imports = [
    ../apps/direnv.nix
    ../apps/fish.nix
    ../apps/fzf.nix
    ../apps/git.nix
    ../apps/k9s.nix
    ../apps/kitty.nix
    ../apps/man.nix
    ../apps/nh.nix
    ../apps/nvf.nix
    ../apps/starship.nix
    ../apps/wezterm.nix
    ../apps/zoxide.nix
    ../apps/zed.nix
    ../apps/zsh.nix
  ];
}
