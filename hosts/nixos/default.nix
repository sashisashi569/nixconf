{ pkgs, username, hostname, ... }: {
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store   = true;
    };
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };
  };

  networking.hostName = hostname;

  time.timeZone    = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT    = "ja_JP.UTF-8";
    LC_MONETARY       = "ja_JP.UTF-8";
    LC_NAME           = "ja_JP.UTF-8";
    LC_NUMERIC        = "ja_JP.UTF-8";
    LC_PAPER          = "ja_JP.UTF-8";
    LC_TELEPHONE      = "ja_JP.UTF-8";
    LC_TIME           = "ja_JP.UTF-8";
  };

  console = {
    font   = "Lat2-Terminus16";
    keyMap = "us";
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups  = [
      "wheel" "networkmanager" "video" "audio"
      "storage" "input" "lp" "scanner"
    ];
    shell = pkgs.bash;
  };

  security.sudo = {
    enable            = true;
    wheelNeedsPassword = true;
  };
}
