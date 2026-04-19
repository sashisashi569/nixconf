{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.boot;
in {
  options.nixconf.boot = {
    enable = lib.mkEnableOption "lanzaboote (Secure Boot + UKI), systemd-initrd, systemd-cryptenroll";

    pkiBundle = lib.mkOption {
      type    = lib.types.str;
      default = "/var/lib/sbctl";
      example = "/var/lib/sbctl";
      description = "Directory that sbctl uses to store Secure Boot keys (pkiBundle).";
    };

    luks.device = lib.mkOption {
      type    = lib.types.str;
      default = "";
      example = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
      description = ''
        LUKS block device to register in the initrd crypttab.
        Leave empty to omit the crypttab entry (e.g. if the host
        configuration defines it separately).
      '';
    };

    fido2.enable = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Add fido2-device=auto to the crypttab entry (YubiKey unlock).";
    };

    tpm2.enable = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Add tpm2-device=auto to the crypttab entry and enable TPM2 userspace.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.systemd.enable = true;

    boot.loader.systemd-boot.enable      = lib.mkForce false;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.lanzaboote = {
      enable    = true;
      pkiBundle = cfg.pkiBundle;
    };

    boot.initrd.luks.devices = lib.mkIf (cfg.luks.device != "") {
      cryptroot = {
        device            = cfg.luks.device;
        crypttabExtraOpts =
          lib.optional cfg.fido2.enable "fido2-device=auto" ++
          lib.optional cfg.tpm2.enable  "tpm2-device=auto";
      };
    };

    security.tpm2 = lib.mkIf cfg.tpm2.enable {
      enable                 = true;
      pkcs11.enable          = true;
      tctiEnvironment.enable = true;
    };

    environment.systemPackages = [ pkgs.sbctl ]
      ++ lib.optionals cfg.tpm2.enable [ pkgs.tpm2-tools pkgs.tpm2-tss ];
  };
}
