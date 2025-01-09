{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {

      # Users
      users.knownUsers = [ "just.maiyak" ];
      users.users."just.maiyak" = {
        uid = 501;
        name = "just.maiyak";
        home = "/Users/just.maiyak";
        shell = pkgs.bashInteractive;
      };

      # Packages
      environment.systemPackages =
        with pkgs; [
          # System Tools
          vim
          bashInteractive
          neovim
          git
          fzf
          bat
          eza
          ripgrep
          tokei
          neofetch
          gnupg
          skhd
          openssl
          fd
          tre-command
          tldr
          zoxide
          nix-direnv

          colima
          dive
          docker
          docker-compose

          # Languages
          nixfmt-rfc-style

          # Fonts
          nerd-fonts.monoid
          nerd-fonts.jetbrains-mono
          nerd-fonts.anonymice
          nerd-fonts.commit-mono
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
            "bruno"
            "whatsapp"
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

      # Disable nix channel
      nix.channel.enable = false;

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
      modules =
        [ configuration
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."just.maiyak" = import ./home.nix;
          }
        ];
    };
  };
}
