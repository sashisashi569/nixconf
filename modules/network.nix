{ config, ... }: {
  # NetworkManager with randomised MAC addresses
  networking.networkmanager = {
    enable           = true;
    dns              = "systemd-resolved";  # delegate DNS to resolved
    wifi.macAddress  = "random";
    ethernet.macAddress = "random";
    wifi.powersave   = true;
  };

  # systemd-resolved in stub-resolver mode
  # /etc/resolv.conf → /run/systemd/resolve/stub-resolv.conf (127.0.0.53)
  services.resolved = {
    enable       = true;
    dnssec       = "allow-downgrade";
    domains      = [ "~." ];
    fallbackDns  = [
      "1.1.1.1#cloudflare-dns.com"
      "8.8.8.8#dns.google"
    ];
    extraConfig = ''
      DNSStubListener=yes
      MulticastDNS=yes
    '';
  };

  # Tailscale
  services.tailscale = {
    enable             = true;
    useRoutingFeatures = "both";  # enable exit-node / subnet-router capability
  };

  networking.firewall = {
    enable             = true;
    trustedInterfaces  = [ "tailscale0" ];
    allowedUDPPorts    = [ config.services.tailscale.port ];
    checkReversePath   = "loose";  # required for Tailscale
  };
}
