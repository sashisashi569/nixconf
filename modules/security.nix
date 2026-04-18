{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.security;
in {
  options.nixconf.security = {
    enable = lib.mkEnableOption "security tooling (YubiKey, GPG agent, GNOME Keyring, seahorse)";

    pam.u2f.enable = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = ''
        Enable PAM U2F so the YubiKey can be used as a second factor
        for sudo and login.  After enabling, register the key with:
          mkdir -p ~/.config/Yubico
          pamu2fcfg >> ~/.config/Yubico/u2f_keys
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.pcscd.enable  = true;
    services.udev.packages = [ pkgs.yubikey-personalization ];

    security.pam.u2f = lib.mkIf cfg.pam.u2f.enable {
      enable           = true;
      settings.cue     = true;
    };

    programs.gnupg.agent = {
      enable           = true;
      enableSSHSupport  = true;
      pinentryPackage  = pkgs.pinentry-gnome3;
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services = {
      login.enableGnomeKeyring  = true;
      greetd.enableGnomeKeyring = true;
    };

    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-manager
      yubico-piv-tool
      yubioath-flutter
      pam_u2f
      seahorse
      gnome-keyring
    ];
  };
}
