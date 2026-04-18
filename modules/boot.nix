# Boot stack: systemd-initrd + LUKS/cryptenroll + lanzaboote (UKI + Secure Boot)
#
# One-time setup (before enabling lanzaboote):
#   1. sbctl create-keys
#   2. sbctl enroll-keys --microsoft   # keep MS keys for UEFI firmware updates
#   3. Enroll FIDO2:  systemd-cryptenroll /dev/nvme0n1p2 --fido2-device=auto
#      Enroll TPM2:   systemd-cryptenroll /dev/nvme0n1p2 --tpm2-device=auto --tpm2-pcrs=0+2+7
{ lib, pkgs, ... }: {
  # systemd in initrd — required for systemd-cryptenroll unlocking
  boot.initrd.systemd.enable = true;

  # Lanzaboote: replaces systemd-boot, builds signed UKIs, enables Secure Boot
  boot.loader.systemd-boot.enable  = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable    = true;
    pkiBundle = "/etc/secureboot";   # populated by sbctl
  };

  # LUKS device — replace UUID with: blkid /dev/nvme0n1p2
  boot.initrd.luks.devices."cryptroot" = {
    device             = "/dev/disk/by-uuid/REPLACE-LUKS-UUID";
    # systemd-cryptenroll tokens: FIDO2 (YubiKey) and/or TPM2
    crypttabExtraOpts  = [ "fido2-device=auto" "tpm2-device=auto" ];
  };

  # TPM2 userspace
  security.tpm2 = {
    enable              = true;
    pkcs11.enable       = true;
    tctiEnvironment.enable = true;
  };

  environment.systemPackages = with pkgs; [
    sbctl       # Secure Boot key/signature management
    tpm2-tools
    tpm2-tss
  ];
}
