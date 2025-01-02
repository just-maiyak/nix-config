{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
          pkgs.bash
          pkgs.neovim
          pkgs.git
          pkgs.fzf
          pkgs.bat
          pkgs.eza
          pkgs.ripgrep
          pkgs.tokei
          pkgs.neofetch
          pkgs.gnupg
        ];

      # Homebrew packages
      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

	taps = [];
	brews = [];
	casks = 
          [ "microsoft-teams"
            "kitty"
            "min"
            "audacity"
            "zed"
          ];
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.bash.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Use TouchID for sudo login
      security.pam.enableSudoTouchIdAuth = true;

      # x86_64 support
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      # macOS options
      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        screencapture.location = "~/Pictures/Screenshots";
        screensaver.askForPasswordDelay = 10;
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."MacBook-Pro-RF-de-Marc" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
