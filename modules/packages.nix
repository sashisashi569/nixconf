{ config, lib, pkgs, ... }:
let
  cfg = config.nixconf.packages;
in {
  options.nixconf.packages = {
    enable = lib.mkEnableOption "base system packages (git, vim, pavucontrol, home-manager)";

    extra = lib.mkOption {
      type    = lib.types.listOf lib.types.package;
      default = [];
      example = lib.literalExpression "[ pkgs.firefox pkgs.thunderbird ]";
      description = "Additional packages to add to environment.systemPackages.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      vim
      pavucontrol
      home-manager
    ] ++ cfg.extra;
  };
}
