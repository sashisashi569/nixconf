{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable          = true;
    xwayland.enable = true;

    settings = {
      monitor = ",preferred,auto,auto";

      general = {
        gaps_in   = 5;
        gaps_out  = 10;
        border_size = 2;
        "col.active_border"   = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding   = 10;
        blur = {
          enabled = true;
          size    = 3;
          passes  = 1;
        };
        drop_shadow        = true;
        shadow_range       = 4;
        shadow_render_power = 3;
        "col.shadow"       = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;
        bezier   = "ease, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows,    1, 7, ease"
          "windowsOut, 1, 7, default, popin 80%"
          "border,     1, 10, default"
          "fade,       1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity  = 0;
        touchpad.natural_scroll = false;
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q,      killactive"
        "$mod, M,      exit"
        "$mod, E,      exec, dolphin"
        "$mod, V,      togglefloating"
        "$mod, R,      exec, wofi --show drun"
        "$mod, P,      pseudo"
        "$mod, J,      togglesplit"
        # focus
        "$mod, left,  movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up,    movefocus, u"
        "$mod, down,  movefocus, d"
        # workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        # screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      exec-once = [
        "waybar"
        "mako"
        "fcitx5 -d --replace"
        "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets,pkcs11,ssh"
      ];

      windowrulev2 = [
        "float, class:^(blueman-manager)$"
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(org.gnome.Seahorse)$"
      ];
    };
  };
}
