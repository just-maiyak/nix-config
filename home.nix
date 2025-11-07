{ config, pkgs, lib, ... }:
let 
  zoxideHandle = "cd";
  brewHook = ''eval "$(/opt/homebrew/bin/brew shellenv)"'';
  shellAliases = {
    # Handy
    aepy = "./.venv/bin/activate";
    cat = "bat";
    du = "dust";
    j = "cd";
    jk = ''cd "$STRUKTUR_PATH"'';
    ls = "exa --color";
    ll = "exa -al --color";
    la = "exa -al --color";

    # Docker
    d = "docker";
    dc = "docker container";
    di = "docker image";
    dn = "docker network";
    dv = "docker volume";

    # k8s
    k = "kubectl";
    kuc = "kubectl config use-context";
    kns = ''kubectl config set-context "$(kubectl config current-context)" --namespace'';
    kex = "kubectl exec -it";
    kl = "kubectl logs";
    kg = "kubectl get";
    kgp = "kubectl get pods";
    kd = "kubectl describe";
    kgall = "kubectl get ingress,service,deployment,pod,statefulset";
    kwatch = "kubectl get pods -w --all-namespaces";
    kru = "kubectl rollout restart deployment";

    # gcloud
    gcs = "gcloud storage";
  };
in
{
  home.stateVersion = "24.11";

  home.sessionVariables.EDITOR = "nvim";

  programs = {

    k9s = {
      enable = true;
      package = pkgs.k9s;
      settings.skin = "dracula";
    };

    direnv = {
      enable = true;
      package = pkgs.direnv;
      enableBashIntegration = true;
      nix-direnv.enable = true;

      config.global.hide_env_diff = true;
      config.global.load_dotenv = true;

      stdlib = ''
layout_uv() {
    if [[ -d ".venv" ]]; then
        VIRTUAL_ENV="$(pwd)/.venv"
    fi

    if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
        log_status "No virtual environment exists. Executing \`uv venv\` to create one."
        uv venv
        VIRTUAL_ENV="$(pwd)/.venv"
    fi

    PATH_add "$VIRTUAL_ENV/bin"
    export UV_ACTIVE=1  # or VENV_ACTIVE=1
    export VIRTUAL_ENV
}

layout_poetry() {
  if [[ ! -f pyproject.toml ]]; then
    log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
    exit 2
  fi

  LOCK="$PWD/poetry.lock"
  watch_file "$LOCK"

  local VENV=$(poetry env info --path)
  if [[ -z $VENV || ! -d $VENV/bin ]]; then
    log_status 'No poetry virtual environment found. Running `poetry install` to create one.'
    poetry install
    VENV=$(poetry env info --path)
  else
    HASH="$PWD/.poetry.lock.sha512"
    if ! sha512sum -c $HASH --quiet >&/dev/null ; then
        log_status 'poetry.lock has been updated. Running `poetry install`'
        poetry install
        sha512sum "$LOCK" > "$HASH"
    fi
  fi
  
  export VIRTUAL_ENV=$VENV
  export POETRY_ACTIVE=1
  PATH_add "$VENV/bin"
}
      '';
    };

    bash = {
      enable = true;
      package = pkgs.bash;
      inherit shellAliases;
      initExtra = brewHook;
    };
    fish = {
      enable = true;
      package = pkgs.fish;
      inherit shellAliases;
      loginShellInit = brewHook;
    };
    zsh = {
      enable = true;
      package = pkgs.zsh;
      inherit shellAliases;
      initContent = brewHook;
    };

    kitty = {
      enable = true;
      package = pkgs.kitty;

      shellIntegration.enableBashIntegration = true;
      settings = {
        term = "xterm-256color"; # ... because else ssh fails to interpret inputs on darwin

	    background_blur = 32;

        # Fonts
	    disable_ligatures = "never";

	    # Window
	    remember_window_size = true;
        initial_window_width = 640;
        initial_window_height = 400;
	    window_border_width = "1pt";
	    window_margin_width = 3;
	    window_padding_width = 8;
	    draw_minimal_borders = true;
	    macos_titlebar_color = "dark";
	    active_border_color = "#6dffff";
	    inactive_border_color = "#2e4b68";
	    hide_window_decorations = "titlebar-only";

	    # Tabs
    	tab_bar_style = "powerline";

    	# macOS specific
    	macos_quit_when_last_window_closed = true;
      };

      # Shortcuts
      keybindings = {
        "cmd+enter" = "new_window";

        "ctrl+shift+]" = "next_window";
        "ctrl+shift+)" = "next_window";
        "cmd+)" = "next_window";

        "ctrl+shift+[" = "previous_window";
        "ctrl+shift+(" = "previous_window";
        "cmd+(" = "previous_window";
      };
    };

    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      enableFishIntegration = true;
      settings = {
        window-padding-x = 12;
        window-padding-y = "0,6";
        background-blur = true;
        window-save-state = "always";
        background-opacity-cells = true;
      };
      installBatSyntax = true;
      installVimSyntax = true;
    };

    starship = {
      enable = true;
      package = pkgs.starship;
      enableFishIntegration = true;
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
      package = pkgs.fzf;
      enableBashIntegration = true;
    };

    zoxide = {
      enable = true;
      package = pkgs.zoxide;
      enableBashIntegration = true;
      options = [ "--cmd" zoxideHandle ];
    };

    git = {
      enable = true;
      package = pkgs.git;
      settings = {
        alias = {
          a = "add";
	      b = "branch --list --all";
	      ca = "commit --amend";
	      cf = "commit --fixup";
	      ci = "commit --interactive";
	      cm = "commit --message";
	      d = "difftool";
	      ds = "diff --summary";
	      i = "init";
	      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
	      lr = "log --no-merges --format='* %s  %h'";
	      ls = "log --nomerges --oneline";
          st = "status";
	      sw = "switch";
	      pf = "push --force";
        };
        user = {
          email = "marc.yefimchuk@radiofrance.com";
          name = "Marc Yefimchuk";
        };
	    init.defaultBranch = "main";
	    fetch.prune = true;
	    push.autoSetupRemote = true;
	    pull = {
	      twohead = "ort";
	      rebase = true;
	    };
	    credentials.helper = "cache --timeout=3600";
	    color = {
	      diff = "auto";
	      status = "auto";
	      branch = "auto";
	      interactive = "auto";
	      ui = true;
	      pager = true;
	    };
	    diff.tool = "nvimdiff";
	    difftool.prompt = false;
	    "difftool \"nvimdiff\"".cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
	    "difftool \"nbdime\"".cmd = ''git-nbdifftool diff "$LOCAL" "$REMOTE" "$BASE"'';
	    mergetool.prompt = false;
	    "mergetool \"nbdime\"".cmd = ''git-nbmergetool merge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'';
      };
    };

    nvf = {
      enable = true;
      settings = {
        vim.package = pkgs.neovim-unwrapped;

        vim.viAlias = false;
        vim.vimAlias = true;

        vim.options = {
          tabstop = 4;
          shiftwidth = 0;
          autoindent = true;
        };

        vim.treesitter = {
          enable = true;
          indent.enable = true;
          fold = true;
        };

        vim.lsp.enable = true;

        vim.languages = {
          enableFormat = true;
          enableTreesitter = true;

          nix = {
            enable = true;
            lsp.enable = true;
            format.enable = true;
            extraDiagnostics.enable = true;
          };

          python = {
            enable = true;
            lsp.enable = true;
            format = {
              enable = true;
              type = "ruff";
            };
          };

          gleam = {
            enable = true;
            lsp.enable = true;
          };
        };

        vim.lazy.plugins = {
          "aerial.nvim" = {
            package = pkgs.vimPlugins.aerial-nvim;
            setupModule = "aerial";
            setupOpts = {
              option_name = true;
            };
            after = ''
              -- custom lua code to run after plugin is loaded
              print('aerial loaded')
            '';

            # Explicitly mark plugin as lazy. You don't need this if you define one of
            # the trigger "events" below
            lazy = true;

            # load on command
            cmd = ["AerialOpen"];

            # load on event
            event = ["BufEnter"];

            # load on keymap
            keys = [
              {
                key = "<leader>a";
                action = ":AerialToggle<CR>";
                mode = "n";
              }
            ];
          };
        };
      };
    };

    wezterm = {
      enable = true;
      package = pkgs.wezterm;

      extraConfig = ''
      return {
        macos_window_background_blur = 20;
        window_decorations = "INTEGRATED_BUTTONS|RESIZE|MACOS_FORCE_ENABLE_SHADOW";
      }
      '';
    };

    zed-editor = {
      enable = true;
      userSettings.vim_mode = true;
    };
    
    home-manager.enable = true;
  };
}
