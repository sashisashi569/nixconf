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
    # Expose individual modules so consuming flakes can pick what they need:
    #
    #   inputs.nixconf.nixosModules.default   — everything
    #   inputs.nixconf.nixosModules.boot      — lanzaboote + UKI + cryptenroll
    #   inputs.nixconf.nixosModules.desktop   — Hyprland + kitty + dolphin
    #   …
    #
    # Example consuming flake:
    #   nixosConfigurations.mymachine = nixpkgs.lib.nixosSystem {
    #     modules = [ inputs.nixconf.nixosModules.default ./hosts/mymachine ];
    #   };
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

      # Convenience alias: imports every module above.
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
        ];
      };
    };
  };
}
