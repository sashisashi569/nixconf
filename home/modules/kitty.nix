{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "monospace";
      size = 12;
    };
    settings = {
      scrollback_lines         = 10000;
      enable_audio_bell        = false;
      update_check_interval    = 0;
      background_opacity       = "0.95";
      confirm_os_window_close  = 0;
      # Use system colour scheme; override here if desired
      # include /path/to/theme.conf
    };
    shellIntegration.enableBashIntegration = true;
  };
}
