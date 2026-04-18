# GENERATED FILE — replace with output of:
#   nixos-generate-config --show-hardware-config
#
# Minimal placeholder so the flake evaluates.
# Update REPLACE-* values before first nixos-rebuild.
{ config, lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules          = [ "dm-snapshot" ];
  boot.kernelModules                 = [ "kvm-intel" ];
  boot.extraModulePackages           = [];

  # Root on LUKS — see modules/boot.nix for the cryptdevice entry
  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "ext4";
  };

  # ESP — replace with actual UUID (blkid /dev/nvme0n1p1)
  fileSystems."/boot" = {
    device  = "/dev/disk/by-uuid/REPLACE-ESP-UUID";
    fsType  = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [];

  nixpkgs.hostPlatform              = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
