{ config, lib, ... }:
let
  cfg = config.nixconf.keychron;
in {
  options.nixconf.keychron = {
    enable = lib.mkEnableOption "Keychron keyboard udev fix (suppress joystick recognition)";
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      ATTRS{idVendor}=="3434", SUBSYSTEM=="input", KERNEL=="js*", ENV{ID_INPUT_JOYSTICK}="0"
    '';
  };
}
