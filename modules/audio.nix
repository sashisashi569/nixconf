{ ... }: {
  # PipeWire — replaces PulseAudio and JACK
  hardware.pulseaudio.enable = false;
  security.rtkit.enable      = true;   # real-time scheduling for audio threads

  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;   # 32-bit Steam / Wine apps
    pulse.enable      = true;   # PulseAudio compatibility
    jack.enable       = true;   # JACK compatibility
    wireplumber.enable = true;  # session/policy manager
  };
}
