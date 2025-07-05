{ pkgs, lib, inputs, ...}:
{
  # Users
  users.knownUsers = [ "just.maiyak" ];
  users.users."just.maiyak" = {
    uid = 501;
    name = "just.maiyak";
    home = "/Users/just.maiyak";
    shell = pkgs.fish;
  };

  # Primary User
  system.primaryUser = "just.maiyak";

  # Packages
  environment.systemPackages =
    with pkgs; [
      # System Tools
      awscli2
      bashInteractive
      bat
      colordiff
      dust
      eza
      fd
      fish
      fzf
      git
      git-delete-merged-branches
      git-filter-repo
      glow
      gnupg
      htop
      iina
      kitty
      macmon
      mactop
      neofetch
      nh
      nix-direnv
      openssl
      ouch
      ripgrep
      skhd
      starship
      tldr
      tokei
      tre-command
      vim
      wezterm
      zoxide
      zsh

      # Virtualisation
      colima
      dive
      docker
      docker-compose

      # Languages
      nixfmt-rfc-style
    ];

  environment.shells = with pkgs; [ bashInteractive zsh fish ];

  # Fonts
  fonts.packages =
    with pkgs; [
      monoid
      jetbrains-mono
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
    brews = [];
    casks = 
      [ "audacity"
        "balenaetcher"
	    "beeper"
        "bruno"
	    "daisydisk"
        "deezer"
        "discord"
        "figma"
        "microsoft-teams"
        "min"
	    "obsidian"
        "ollama"
        "openvpn-connect"
        "whatsapp"
        "zed"
	    "zotero"
      ];
    masApps =
      { BitWarden = 1352778147;
        Dashlane = 517914548;
        Excel = 462058435;
        Messenger = 1480068668;
        Outlook = 985367838;
        Powerpoint = 462062816;
        Slack = 803453959;
        Word = 462054704;
      };
  };
  environment.variables.HOMEBREW_NO_ANALYTICS = "1"; # No telemetry

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Disable nix channel
  nix.channel.enable = false;

  # Enable alternative shell support in nix-darwin.
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Automatic cleanup
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 10d";
  nix.optimise.automatic = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Use TouchID for sudo login
  security.pam.services.sudo_local.touchIdAuth = true;

  # x86_64 support via Rosetta
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # macOS options
  system.defaults = {
    dock = {
      autohide = true;
      minimize-to-application = true;
      mru-spaces = false;

      # Hot corners
      wvous-bl-corner = 13; # Bottom left: Lock Screen
      wvous-br-corner = 14; # Bottom right: Quick Note
      wvous-tl-corner = 11; # Top left: Launchpad
      wvous-tr-corner = 2; # Top right: Mission Control
    };
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv"; # Prefer Columns
    finder.ShowHardDrivesOnDesktop = true;
    screencapture.location = "~/Pictures/Screenshots";
    screensaver.askForPasswordDelay = 10;
  };

  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${inputs.tt-schemes}/base24/dracula.yaml";

    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
	name = "JetBrains Mono";
      };
      sizes.terminal = 18;
    };

    opacity.terminal = 0.8;
  };
}
