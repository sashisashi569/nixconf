{ pkgs, ... }: {
  # Hyprland Wayland compositor
  programs.hyprland = {
    enable         = true;
    xwayland.enable = true;
  };

  # XDG portals (screen share, file picker, etc.)
  xdg.portal = {
    enable       = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Dolphin file manager runtime services
  services.gvfs.enable   = true;   # virtual filesystem (MTP, SMB, …)
  services.udisks2.enable = true;  # automount

  # Display manager (greetd + tuigreet — lightweight, works with Hyprland)
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      user    = "greeter";
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Polkit agent (run as systemd user service, started from Hyprland exec-once)
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-auth-agent = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig = {
      Type          = "simple";
      ExecStart     = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart       = "on-failure";
      RestartSec    = 1;
      TimeoutStopSec = 10;
    };
  };

  # Qt Wayland integration
  environment.variables = {
    QT_QPA_PLATFORM                 = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    NIXOS_OZONE_WL                  = "1";      # Electron/Chromium
    MOZ_ENABLE_WAYLAND              = "1";
  };

  environment.systemPackages = with pkgs; [
    kitty
    kdePackages.dolphin
    kdePackages.kio-extras         # Dolphin extra protocols (MTP, fish, …)
    kdePackages.dolphin-plugins

    # Wayland utilities
    wl-clipboard
    wlr-randr
    grim                           # screenshot
    slurp                          # region select
    mako                           # notifications
    libnotify
    wofi                           # app launcher
    waybar                         # status bar
    polkit_gnome

    # Qt theme for non-KDE apps
    kdePackages.qt6ct
    libsForQt5.qt5ct
    kdePackages.breeze
  ];
}
