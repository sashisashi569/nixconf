{ config, lib, ... }:
let
  cfg = config.nixconf.audio;
in {
  options.nixconf.audio = {
    enable = lib.mkEnableOption "PipeWire audio (ALSA, PulseAudio and JACK compatibility)";

    support32Bit = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Enable 32-bit ALSA support (required for Steam and Wine).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable      = true;

    services.pipewire = {
      enable             = true;
      alsa.enable        = true;
      alsa.support32Bit  = cfg.support32Bit;
      pulse.enable       = true;
      jack.enable        = true;
      wireplumber.enable = true;
    };
  };
}
