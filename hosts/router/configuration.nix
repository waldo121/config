# Prerequisites (do these BEFORE installing NixOS):
#   1. Flash coreboot firmware — see https://dulib.re/wiki/doku.php/opnsenseonvelocloudedge510
#   2. Disable watchdog (prevents reboot loops with non-Velocloud OS):
#        i2cset -y 1 0x24 0x00 0x00
#        i2cset -y 1 0x24 0x01 0x00
#   3. Interface naming: Intel I210 NICs use the `igb` driver.
#      Port mapping: igb0=GE1 (WAN), igb1=GE2, igb2=GE3, igb3=GE4 (LAN).

{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader — keep few generations on 8GB eMMC.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # WAN — receives public IP via Bell DHCP (DMZ mode).
  networking.useDHCP = false;
  networking.interfaces.igb0.useDHCP = true;

  # LAN — bridge remaining ports into a single subnet.
  networking.bridges.br0.interfaces = [ "igb1" "igb2" "igb3" ];
  networking.interfaces.br0.ipv4.addresses = [{
    address = "192.168.1.1";
    prefixLength = 24;
  }];

  networking.hostName = "router";

  # NAT — masquerade LAN traffic to WAN.
  networking.nat.enable = true;
  networking.nat.externalInterface = "igb0";
  networking.nat.internalInterfaces = [ "br0" ];

  # Firewall.
  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "br0" ];
  networking.firewall.allowedUDPPorts = [ 51820 ]; # WireGuard
  networking.firewall.allowPing = false;
  networking.firewall.logReversePathDrops = true;

  # DHCP server — dnsmasq (DHCP only; Unbound handles DNS).
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      interface = "br0";
      bind-interfaces = true;
      dhcp-range = "192.168.1.100,192.168.1.254,255.255.255.0,12h";
      dhcp-option = [
        "3,192.168.1.1"      # default gateway
        "6,192.168.1.1"      # DNS server (Unbound)
      ];
      dhcp-authoritative = true;
      port = 0;               # disable DNS (handled by Unbound)
    };
  };

  # DNS — local caching, forward upstream.
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "192.168.1.1" "127.0.0.1" ];
        access-control = [ "192.168.1.0/24 allow" "127.0.0.0/8 allow" ];
        do-ip4 = true;
        do-ip6 = false;
        do-udp = true;
        do-tcp = true;
        hide-identity = true;
        hide-version = true;
      };
      forward-zone = [{
        name = ".";
        forward-addr = [ "1.1.1.1" "1.0.0.1" ];
      }];
    };
  };

  # WireGuard VPN — accelerated via AES-NI (available on Atom C2358).
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/etc/wireguard/private.key";
    peers = [
      {
        # Replace with peer's public key (safe to commit):
        publicKey = "";
        allowedIPs = [ "10.100.0.2/32" "192.168.1.0/24" ];
      }
    ];
  };

  # Ensure /etc/wireguard exists for the private key.
  systemd.tmpfiles.rules = [
    "d /etc/wireguard 0750 root root -"
  ];

  # SSH — LAN and WireGuard only (blocked on WAN by default firewall).
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      Port = 22;
    };
  };

  # Users.
  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBiMhG1rbz8WKWKuz1TmYcLoMP7SdnLOjHmUGFnmF1J7 17034517+waldo121@users.noreply.github.com"
    ];
    raph = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "changeme";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBiMhG1rbz8WKWKuz1TmYcLoMP7SdnLOjHmUGFnmF1J7 17034517+waldo121@users.noreply.github.com"
      ];
    };
  };

  # Unfree (required for Intel CPU microcode).
  nixpkgs.config.allowUnfree = true;

  # Nix settings — tuned for 8GB eMMC.
  nix.settings.experimental-features = [ "nix-command" ];
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";

  # Automatic upgrades — weekly, with windowed reboot for kernel changes.
  system.autoUpgrade = {
    enable = true;
    dates = "Sun 03:00";
    randomizedDelaySec = "30m";
    persistent = true;
    allowReboot = true;
    rebootWindow.lower = "04:00";
    rebootWindow.upper = "05:00";
    runGarbageCollection = true;
  };

  # Minimal packages.
  environment.systemPackages = with pkgs; [
    vim
    wireguard-tools
  ];

  programs.ssh.startAgent = false;

  system.stateVersion = "25.11";
}
