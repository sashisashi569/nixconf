{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.desktop;
in {
  options.nixconf.desktop = {
    enable = lib.mkEnableOption "Hyprland desktop (kitty, dolphin, gvfs, udisks2, greetd)";

    xwayland.enable = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Enable XWayland for X11 application compatibility under Hyprland.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable          = true;
      xwayland.enable = cfg.xwayland.enable;
    };

    xdg.portal = {
      enable       = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    services.gvfs.enable   = true;
    services.udisks2.enable = true;

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user    = "greeter";
      };
    };
    security.pam.services.greetd.enableGnomeKeyring = true;

    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-auth-agent = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy    = [ "graphical-session.target" ];
      after       = [ "graphical-session.target" ];
      serviceConfig = {
        Type           = "simple";
        ExecStart      = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart        = "on-failure";
        RestartSec     = 1;
        TimeoutStopSec = 10;
      };
    };

    environment.variables = {
      QT_QPA_PLATFORM                     = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      NIXOS_OZONE_WL                      = "1";
      MOZ_ENABLE_WAYLAND                  = "1";
    };

    environment.systemPackages = with pkgs; [
      kitty
      kdePackages.dolphin
      kdePackages.kio-extras
      kdePackages.dolphin-plugins
      wl-clipboard
      wlr-randr
      grim
      slurp
      mako
      libnotify
      wofi
      waybar
      polkit_gnome
      kdePackages.qt6ct
      libsForQt5.qt5ct
      kdePackages.breeze
    ];
  };
}
