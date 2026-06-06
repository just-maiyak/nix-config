{pkgs, ...}:

{
    programs.nvf = {
      enable = true;
      settings.vim = {
        package = pkgs.neovim-unwrapped;

        viAlias = false;
        vimAlias = true;

        globals.mapleader = ",";

        options = {
          tabstop = 4;
          shiftwidth = 0;
          autoindent = true;
        };

        treesitter = {
          enable = true;
          indent.enable = true;
          fold = true;
        };

        lsp.enable = true;

        languages = {
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
              type = ["ruff"];
            };
          };

          gleam = {
            enable = true;
            lsp.enable = true;
          };
        };

        lazy.plugins = {
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

          "diffview.nvim" = {
            package = pkgs.vimPlugins.diffview-nvim;

            cmd = ["DiffviewOpen"];
          };
        };
      };
    };
}
