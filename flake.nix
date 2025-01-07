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

      # Packages
      environment.systemPackages =
        [ # System Tools
          pkgs.vim
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
          pkgs.skhd
          pkgs.openssl
          pkgs.zoxide
          pkgs.fd
        ];

      # Homebrew packages
      homebrew = {
        enable = true;

        onActivation = {
          autoUpdate = true;
          cleanup = "uninstall";
          upgrade = true;
        };

	taps = [];
	brews =
          [ "git"
          ];
	casks = 
          [ "microsoft-teams"
            "kitty"
            "min"
            "audacity"
            "zed"
            "openvpn-connect"
            "deezer"
          ];
        masApps =
          { Dashlane = 517914548;
            Powerpoint = 462062816;
            Excel = 462058435;
            Word = 462054704;
            Outlook = 985367838;
            Slack = 803453959;
            Messenger = 1480068668;
          };
      };
      environment.variables.HOMEBREW_NO_ANALYTICS = "1"; # No telemetry

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
    darwinConfigurations."stallion" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
