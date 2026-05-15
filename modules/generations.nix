{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.generations;
in {
  options.nixconf.generations = {
    enable = lib.mkEnableOption "automatic deletion of old system generations";

    keep = lib.mkOption {
      type        = lib.types.ints.positive;
      default     = 3;
      example     = 5;
      description = "Number of most-recent system generations to keep.";
    };

    dates = lib.mkOption {
      type        = lib.types.str;
      default     = "weekly";
      example     = "Mon *-*-* 03:00:00";
      description = "Systemd calendar expression controlling how often the cleanup runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nixos-delete-old-generations = {
      description = "Delete NixOS system generations older than the ${toString cfg.keep} most recent";
      serviceConfig = {
        Type            = "oneshot";
        ExecStart       = "${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --delete-generations +${toString cfg.keep}";
        SyslogIdentifier = "nixos-delete-old-generations";
      };
    };

    systemd.timers.nixos-delete-old-generations = {
      description = "Timer for nixos-delete-old-generations";
      wantedBy    = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.dates;
        Persistent = true;
      };
    };
  };
}
