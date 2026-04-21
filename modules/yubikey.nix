{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.yubikey;
in {
  options.nixconf.yubikey = {
    enable = lib.mkEnableOption "YubiKey Authenticator system daemon support (pcscd + udev rules)";
  };

  config = lib.mkIf cfg.enable {
    # PC/SC smart card daemon — required for YubiKey Authenticator (CCID interface)
    services.pcscd.enable = true;

    # udev rules for YubiKey device recognition and user-space access permissions
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];
  };
}
