{ pkgs, lib, inputs, ...}:
{
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
      bashInteractive
      bat
      colordiff
      dust
      eza
      fd
      fzf
      git
      gnupg
      neofetch
      neovim
      nix-direnv
      openssl
      ripgrep
      skhd
      starship
      tldr
      tokei
      tre-command
      vim
      zoxide

      # Virtualisation
      colima
      dive
      docker
      docker-compose

      # Languages
      nixfmt-rfc-style
    ];

  # Fonts
  fonts.packages =
    with pkgs; [
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
    brews = [];
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
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

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
    finder.FXPreferredViewStyle = "clmv";
    screencapture.location = "~/Pictures/Screenshots";
    screensaver.askForPasswordDelay = 10;
  };

}
