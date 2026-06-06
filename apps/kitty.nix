{pkgs, ...}:

{
  programs.kitty = {
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
}
