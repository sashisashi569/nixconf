{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.fonts;
in {
  options.nixconf.fonts = {
    enable = lib.mkEnableOption "CJK fonts (Noto Sans/Serif CJK) with fontconfig tweaks";
  };

  config = lib.mkIf cfg.enable {
    system.activationScripts.flatpak-font-access = ''
      if command -v flatpak &>/dev/null; then
        flatpak override --system \
          --filesystem=/run/current-system/sw/share/fonts:ro \
          --filesystem=/run/current-system/sw/share/icons:ro
      fi
    '';

    fonts = {
      fontDir.enable = true;

      packages = with pkgs; [
        dejavu_fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];

      fontconfig = {
        allowBitmaps = false;
        antialias    = true;

        hinting = {
          enable = true;
          style  = "slight";
        };

        subpixel = {
          rgba      = "rgb";
          lcdfilter = "default";
        };

        defaultFonts = {
          serif     = [ "Noto Serif CJK JP" "Noto Serif" ];
          sansSerif = [ "Noto Sans CJK JP"  "Noto Sans"  ];
          monospace = [ "DejaVu Sans Mono" "Noto Sans Mono CJK JP" ];
        };
      };
    };
  };
}
