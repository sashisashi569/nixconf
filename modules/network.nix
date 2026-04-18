{ config, lib, ... }:
let
  cfg = config.nixconf.network;
in {
  options.nixconf.network = {
    enable = lib.mkEnableOption "network (NetworkManager + systemd-resolved stub resolver)";

    randomMac = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Randomise MAC address for Wi-Fi and Ethernet connections.";
    };

    tailscale.enable = lib.mkEnableOption "Tailscale VPN";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable          = true;
      dns             = "systemd-resolved";
      wifi.macAddress     = lib.mkIf cfg.randomMac "random";
      ethernet.macAddress = lib.mkIf cfg.randomMac "random";
      wifi.powersave  = true;
    };

    services.resolved = {
      enable      = true;
      dnssec      = "allow-downgrade";
      domains     = [ "~." ];
      fallbackDns = [
        "1.1.1.1#cloudflare-dns.com"
        "8.8.8.8#dns.google"
      ];
      extraConfig = ''
        DNSStubListener=yes
        MulticastDNS=yes
      '';
    };

    services.tailscale = lib.mkIf cfg.tailscale.enable {
      enable             = true;
      useRoutingFeatures = "both";
    };

    networking.firewall = {
      enable            = true;
      trustedInterfaces = lib.mkIf cfg.tailscale.enable [ "tailscale0" ];
      allowedUDPPorts   = lib.mkIf cfg.tailscale.enable [ config.services.tailscale.port ];
      checkReversePath  = lib.mkIf cfg.tailscale.enable "loose";
    };
  };
}
