{
  description = "Reusable NixOS modules — import as flake input and enable via nixosModules";

  inputs = {
    nixpkgs.url    = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote     = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, ... }:
  let
    # boot.nix relies on options provided by the lanzaboote NixOS module,
    # so bundle them together as a single composable unit.
    bootModule = { imports = [ lanzaboote.nixosModules.lanzaboote ./modules/boot.nix ]; };
  in {
    # -----------------------------------------------------------------------
    # Each module declares options under the `nixconf.*` namespace.
    # Nothing is enabled by default — the consuming host configuration
    # opts in by setting the corresponding enable flag.
    #
    # Typical consuming flake:
    #
    #   inputs.nixconf.url = "github:sashisashi569/nixconf";
    #
    #   nixosConfigurations.mymachine = nixpkgs.lib.nixosSystem {
    #     modules = [
    #       inputs.nixconf.nixosModules.default  # register all options
    #       ./hosts/mymachine                    # host-specific config
    #     ];
    #   };
    #
    # Then in ./hosts/mymachine/configuration.nix:
    #
    #   nixconf.boot.enable          = true;
    #   nixconf.boot.luks.device     = "/dev/disk/by-uuid/xxxx-…";
    #   nixconf.desktop.enable       = true;
    #   nixconf.fcitx5.enable        = true;
    #   nixconf.network.enable       = true;
    #   nixconf.network.tailscale.enable = true;
    #   nixconf.audio.enable         = true;
    #   nixconf.bluetooth.enable     = true;
    #   nixconf.security.enable      = true;
    #   nixconf.homed.enable         = true;
    #   nixconf.packages.enable      = true;
    #   nixconf.packages.extra       = [ pkgs.firefox ];
    #   nixconf.fonts.enable         = true;
    #
    # Or enable everything at once:
    #
    #   nixconf.enable = true;  # sets all nixconf.*.enable = true (mkDefault)
    #   nixconf.boot.luks.device = "/dev/disk/by-uuid/xxxx-…";  # still override freely
    # -----------------------------------------------------------------------
    nixosModules = {
      boot      = bootModule;
      desktop   = ./modules/desktop.nix;
      fcitx5    = ./modules/fcitx5.nix;
      network   = ./modules/network.nix;
      audio     = ./modules/audio.nix;
      bluetooth = ./modules/bluetooth.nix;
      security  = ./modules/security.nix;
      homed     = ./modules/homed.nix;
      packages  = ./modules/packages.nix;
      fonts     = ./modules/fonts.nix;

      # Imports every module and registers nixconf.enable (enable-all shortcut).
      default = {
        imports = [
          bootModule
          ./modules/desktop.nix
          ./modules/fcitx5.nix
          ./modules/network.nix
          ./modules/audio.nix
          ./modules/bluetooth.nix
          ./modules/security.nix
          ./modules/homed.nix
          ./modules/packages.nix
          ./modules/fonts.nix
          ./modules/all.nix
        ];
      };
    };
  };
}
