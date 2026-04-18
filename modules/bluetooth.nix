{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.bluetooth;
in {
  options.nixconf.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth (bluez + blueman)";

    powerOnBoot = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Power on the Bluetooth adapter automatically at boot.";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable      = true;
      powerOnBoot = cfg.powerOnBoot;
      settings.General = {
        Enable       = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      blueman
      bluetuith
    ];
  };
}
