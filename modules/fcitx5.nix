{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.fcitx5;
in {
  options.nixconf.fcitx5 = {
    enable = lib.mkEnableOption "fcitx5 input method with Mozc (Japanese)";
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type   = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          fcitx5-qt
          fcitx5-configtool
        ];
      };
    };
  };
}
