{
  description = "NixOS flake — Hyprland + lanzaboote + home-manager standalone";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, ... } @ inputs:
  let
    system   = "x86_64-linux";
    username = "youruser";   # ← change to your username
    hostname = "nixos";      # ← change to your hostname
    pkgs     = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username hostname; };
      modules = [
        lanzaboote.nixosModules.lanzaboote
        ./hosts/nixos
        ./modules/boot.nix
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

    # Standalone home-manager: run with
    #   home-manager switch --flake .#${username}@${hostname}
    homeConfigurations."${username}@${hostname}" =
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs username; };
        modules = [ ./home ];
      };
  };
}
