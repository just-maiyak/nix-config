{ config, pkgs, lib, ... }:
let zoxideHandle = "cd"; in
{
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs = {

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;

      config.global.hide_env_diff = true;
      config.global.load_dotenv = true;
    };

    bash = {
      enable = true;
      shellAliases = {
        # Handy
        aepy = "./.venv/bin/activate";
        cat = "bat";
        du = "dust";
        jk = ''${zoxideHandle} "$STRUKTUR_PATH"'';
        ls = "exa --color";
        ll = "exa -al --color";
        la = "exa -al --color";
        vim = "nvim";

        # Docker
        d = "docker";
        dc = "docker container";
        di = "docker image";
        dn = "docker network";
        dv = "docker volume";

        # k8s
        k = "kubectl";
        kxt = "kubectl config use-context";

        # ssh kitten
        ssh = ''if [ $TERM = "xterm-kitty" ]; then TERM="xterm-256color" kitty +kitten ssh; fi'';
      };
    };

    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      themeFile = "Dracula";
      font = {
        name = "JetBrainsMono Nerd Font";
	package = pkgs.nerd-fonts.jetbrains-mono;
        size = 18;
      };
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$python"
          "$kubernetes"
          "$aws$gcloud"
          "$os"
          "$character"
        ];

        command_timeout = 500;

        line_break = {
          disabled = false;
        };

        username = {
          show_always = true;
          style_user = "bold cyan";
          format = "[$user]($style) ";
        };

        directory = {
          style = "bold bright-blue";
          read_only = " ";
          fish_style_pwd_dir_length = 2;
        };

        character = {
          success_symbol = "[λ](bold 27)";
          error_symbol = "[λ](bold red)";
          vimcmd_symbol = "[❮](bold green)";
          vimcmd_replace_symbol = "[❮](bold yellow)";
        };

        kubernetes = {
          disabled = false;
          symbol = "⎈";
          format = "[$symbol $context ~ $namespace ](dimmed blue)";
        };

        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };

        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = "≡";
        };

        git_state = {
          format = "\([$state( $progress_current/$progress_total)]($style)\) ";
          style = "bright-black";
        };

        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };

        python = {
          format = "[$symbol$pyenv_prefix($version )($virtualenv )]($style)";
          pyenv_version_name = true;
          detect_extensions = ["py" "ipynb"];
          style = "green";
          symbol = " ";
        };

        aws = {
          symbol = "a :";
          style = "dimmed 208"; # dimmed orange
        };

        gcloud = {
          symbol = "g ";
          style = "dimmed cyan";
          format = "[$symbol:$account(\($region\))]($style) ";
        };

        conda = {
          symbol = " ";
        };

        dart = {
          symbol = " ";
        };

        docker_context = {
          symbol = " ";
        };

        elixir = {
          symbol = " ";
        };

        elm = {
          symbol = " ";
        };

        golang = {
          symbol = " ";
        };

        hg_branch = {
          symbol = " ";
        };

        java = {
          symbol = " ";
        };

        julia = {
          symbol = " ";
        };

        memory_usage = {
          symbol = " ";
        };

        nim = {
          symbol = " ";
        };

        nix_shell = {
          symbol = " ";
        };

        package = {
          symbol = " ";
        };

        perl = {
          symbol = " ";
        };

        php = {
          symbol = " ";
        };

        ruby = {
          symbol = " ";
        };

        rust = {
          symbol = " ";
        };

        scala = {
          symbol = " ";
        };

        shlvl = {
          symbol = " ";
        };

        swift = {
          symbol = "ﯣ ";
        };

      };
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      options = [ "--cmd" zoxideHandle ];
    };

    home-manager.enable = true;
  };
}
