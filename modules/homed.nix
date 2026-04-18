{ config, lib, ... }:
let
  cfg = config.nixconf.homed;
in {
  options.nixconf.homed = {
    enable = lib.mkEnableOption "systemd-homed (portable encrypted home directories)";
  };

  config = lib.mkIf cfg.enable {
    services.homed.enable = true;
  };
}
