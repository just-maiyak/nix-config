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

  system = {
    # Primary User
    primaryUser = "just.maiyak";

    # Set Git commit hash for darwin-version.
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    # macOS options
    defaults = {
      dock = {
        autohide = true;
        minimize-to-application = true;
        mru-spaces = false;

        # Hot corners
        wvous-bl-corner = 13; # Bottom left: Lock Screen
        wvous-br-corner = 14; # Bottom right: Quick Note
        wvous-tl-corner = 11; # Top left: Launchpad
        wvous-tr-corner = 2;  # Top right: Mission Control
      };
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv"; # Prefer Columns
        ShowHardDrivesOnDesktop = true;
      };
      screencapture.location = "~/Pictures/Screenshots";
      screensaver.askForPasswordDelay = 10;
    };
  };

  environment = {
    # Packages
    systemPackages =
      with pkgs; [
        # System Tools
        awscli2
        bat
        colordiff
        curl
        dust
        eza
        fastfetch
        fd
        fzf
        fzf-git-sh
        git
        git-delete-merged-branches
        git-filter-repo
        git-lfs
        glow
        gnupg
        htop
        macmon
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
        zoxide

        # Shells
        bashInteractive
        fish
        zsh

        # Terminal emulators
        ghostty-bin
        kitty
        wezterm

        # Multimedia
        ffmpeg
        iina

        # Virtualisation
        colima
        dive
        docker
        docker-compose

        # Languages
        nixfmt
      ];

    shells = with pkgs; [ bashInteractive zsh fish ];

    # No telemetry in brew
    variables.HOMEBREW_NO_ANALYTICS = "1"; 
  };

  # Fonts
  fonts.packages =
    with pkgs; [
      jetbrains-mono
      raleway
    ];

  # Homebrew packages
  homebrew = {
    enable = true;
    greedyCasks = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };

    taps = [ "maiyak/local" ];
    brews = [ "container" "yap" ];
    casks = 
      [ "audacity"
        "balenaetcher"
	    "beeper"
        "bruno"
	    "daisydisk"
        "deezer"
        "discord"
        "figma"
        "keycastr"
        "microsoft-teams"
        "min"
        "notion"
	    "obsidian"
        "ollama-app"
        "openvpn-connect"
        "pdf-squeezer"
        "touchdesigner"
        "whatsapp"
        "zed"
        "zen"
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

  nix = {
    # Use lix instead of nix
    package = pkgs.lixPackageSets.latest.lix;
    # Necessary for using flakes on this system.
    settings.experimental-features = "nix-command flakes";
    # Disable nix channel
    channel.enable = false;
  };

  # Enable alternative shell support in nix-darwin.
  programs = {
    bash.enable = true;
    zsh.enable = true;
    fish.enable = true;
  };

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


  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${inputs.tt-schemes}/base24/dracula.yaml";

    fonts = {
      monospace.name = "JetBrains Mono";
      sizes.terminal = 18;
    };

    opacity.terminal = 0.8;
    targets = {
      nvf.transparentBackground = true;
    };
  };
}
