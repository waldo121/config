# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.configurationLimit = 20;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  programs.appimage.binfmt = true;
  
  # System upgrades
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;  
    channel =  "https://channels.nixos.org/nixos-25.11";
    flags = [
      "-I"
      "nixos-config=/home/raphael/src/config/configuration.nix"
    ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  # Fonts
  fonts.enableDefaultPackages = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Sway autologin
  hardware.graphics.enable = true;
  services.greetd.enable = true;
  services.greetd.settings = {
    default_session = {
      command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
      user = "raphael";
   };
  };
  services.geoclue2.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.raphael = {
    isNormalUser = true;
    description = "raphael";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "wireshark"];
  };

  # Enable automatic login for the user.
  # services.getty.autologinUser = "raphael";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ 
    polkit_gnome 
  ];
  # virtualisation
  virtualisation.containers.enable = true;
  virtualisation.oci-containers.backend = "podman";
  virtualisation = {
    podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
    };
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.light.enable = true;
  programs.wireshark = {
    enable = true;
  };
  # Sound
  services.pipewire = {
    enable = false;
  };
  services.pulseaudio = {
    enable = true;
    support32Bit = true;    ## If compatibility with 32-bit applications is desired.
    extraConfig = "load-module module-combine-sink";
  };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable polkit for sway
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };
  # keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.raphael.enableGnomeKeyring = true;
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "-d";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
