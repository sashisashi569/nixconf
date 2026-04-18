# YubiKey (smart card / FIDO2 / U2F / GPG) + GNOME Keyring
#
# After first login, register U2F credential:
#   mkdir -p ~/.config/Yubico
#   pamu2fcfg >> ~/.config/Yubico/u2f_keys
{ pkgs, ... }: {
  # Smart-card daemon (YubiKey PIV, OpenPGP card)
  services.pcscd.enable       = true;
  services.udev.packages      = [ pkgs.yubikey-personalization ];

  # PAM FIDO2/U2F — adds YubiKey as a second factor for sudo / login
  security.pam.u2f = {
    enable = true;
    settings.cue = true;   # print "Touch YubiKey" prompt
  };

  # GPG agent with SSH and smart-card support
  programs.gnupg.agent = {
    enable           = true;
    enableSSHSupport  = true;
    pinentryPackage  = pkgs.pinentry-gnome3;
  };

  # GNOME Keyring — unlocked on login via PAM
  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    login.enableGnomeKeyring  = true;
    greetd.enableGnomeKeyring = true;
  };

  environment.systemPackages = with pkgs; [
    yubikey-personalization   # ykpers — personalise OTP slots
    yubikey-manager           # ykman — general management CLI
    yubico-piv-tool           # PIV operations
    yubioath-flutter          # TOTP/HOTP GUI (Yubico Authenticator)
    pam_u2f                   # PAM module (also used as library)
    seahorse                  # GNOME Keyring GUI
    gnome-keyring
  ];
}
