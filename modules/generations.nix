{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.generations;
in {
  options.nixconf.generations = {
    enable = lib.mkEnableOption "automatic deletion of old system generations on rebuild";

    keep = lib.mkOption {
      type        = lib.types.ints.positive;
      default     = 3;
      example     = 5;
      description = "Number of most-recent system generations to keep.";
    };
  };

  config = lib.mkIf cfg.enable {
    system.activationScripts.deleteOldGenerations = {
      text = ''
        ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system \
          --delete-generations +${toString cfg.keep}
      '';
      deps = [];
    };
  };
}
