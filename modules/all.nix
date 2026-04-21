{ config, lib, ... }:
let
  cfg = config.nixconf;
in {
  options.nixconf.enable = lib.mkEnableOption "all nixconf modules at once";

  config = lib.mkIf cfg.enable {
    nixconf.boot.enable      = lib.mkDefault true;
    nixconf.desktop.enable   = lib.mkDefault true;
    nixconf.fcitx5.enable    = lib.mkDefault true;
    nixconf.network.enable   = lib.mkDefault true;
    nixconf.audio.enable     = lib.mkDefault true;
    nixconf.bluetooth.enable = lib.mkDefault true;
    nixconf.security.enable  = lib.mkDefault true;
    nixconf.yubikey.enable   = lib.mkDefault true;
    nixconf.homed.enable     = lib.mkDefault true;
    nixconf.packages.enable  = lib.mkDefault true;
    nixconf.fonts.enable     = lib.mkDefault true;
  };
}
