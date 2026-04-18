{ username, ... }: {
  imports = [
    ./modules/hyprland.nix
    ./modules/kitty.nix
    ./modules/fcitx5.nix
  ];

  home.username    = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # Wayland / Electron / Mozilla env vars
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE    = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND         = "wayland,x11,*";
    SDL_VIDEODRIVER     = "wayland";
    CLUTTER_BACKEND     = "wayland";
  };

  programs.git = {
    enable    = true;
    userName  = "Your Name";      # ← change
    userEmail = "you@example.com"; # ← change
    extraConfig.init.defaultBranch = "main";
  };

  home.packages = [];  # add user-specific packages here
}
