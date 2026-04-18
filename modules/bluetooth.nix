{ pkgs, ... }: {
  hardware.bluetooth = {
    enable       = true;
    powerOnBoot  = true;
    settings.General = {
      Enable     = "Source,Sink,Media,Socket";
      Experimental = true;   # enables battery reporting, etc.
    };
  };

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    blueman
    bluetuith   # TUI Bluetooth manager
  ];
}
