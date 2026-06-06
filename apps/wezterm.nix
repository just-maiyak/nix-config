{pkgs, ...}:

{
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
  
    extraConfig = ''
    return {
      macos_window_background_blur = 20;
      window_decorations = "INTEGRATED_BUTTONS|RESIZE|MACOS_FORCE_ENABLE_SHADOW";
    }
    '';
  };
}
