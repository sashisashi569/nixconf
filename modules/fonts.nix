{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.fonts;
in {
  options.nixconf.fonts = {
    enable = lib.mkEnableOption "CJK fonts (Noto Sans/Serif CJK) with fontconfig tweaks";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
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
          monospace = [ "Noto Sans Mono CJK JP" "Noto Sans Mono" ];
        };
      };
    };
  };
}
