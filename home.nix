{ pkgs, config, ... }:
let
    z = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/4426104c8c900fbe048c33a0e6f68a006235ac50.tar.gz";
    }) {};

    myPkg = z.php74base;
in
{
 imports =  [
    ./neovim.nix
    ./codium.nix
 ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "raphael";
  home.homeDirectory = "/home/raphael";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    podman-compose
    podman-tui
    dbeaver-bin
    podman
    pass-wayland
    swaylock
    gnupg
    grim
    slurp
    wl-clipboard
    mako
    libnotify
    xdg-utils # allows opening links in browser
    playerctl
    gh
    gimp
    dotnetCorePackages.dotnet_9.sdk
    dotnetCorePackages.dotnet_9.runtime
    dotnetCorePackages.dotnet_9.aspnetcore
    myPkg
    nodejs_18
    iconv
    (nerdfonts.override { fonts = [ "DroidSansMono" ]; })
    # Game developped for windows, unsupported on linux, but works well enough for me
     (appimageTools.wrapType2 { 
      name = "Ankama-Launcher";
      src = fetchurl {
        url = "https://launcher.cdn.ankama.com/installers/production/Dofus_3.0-x86_64.AppImage";
        sha256 = "sha256-yqdqxD5YfrODX4p0Rh8LqUn5/nrHciyvJfb7WC9BTW4=";
      };
       extraPkgs = pkgs: with pkgs; [
        wine64
        wineWowPackages.waylandFull
       ];
       APPIMAGE=true;
    })
    discord
  ];
  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.pulseaudio = true;
  fonts.fontconfig.enable = true;
  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
    sessionVariables = {
     DOTNET_ROOT = "${pkgs.dotnetCorePackages.dotnet_9.runtime}/share/dotnet";
     PATH="$PATH:/home/raphael/.dotnet/tools";
    };
  };
  programs.bash = {
    enable = true;
    sessionVariables = {
      DOTNET_ROOT = "${pkgs.dotnetCorePackages.dotnet_9.runtime}/share/dotnet";
      PATH="$PATH:/home/raphael/.dotnet/tools";
    };
  };
  
  programs.git = {
    enable = true;
    userName = "waldo121";
    userEmail = "17034517+waldo121@users.noreply.github.com";
  };
  programs.swaylock.enable = true;
  services.mako =  {
    enable = true;
    defaultTimeout = 5000;
    layer = "overlay";
  };
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
  services.ssh-agent.enable = true;
  services.batsignal.enable = true;
  services.mpd-mpris.enable = true;
  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    checkConfig = false; # TODO: Remove when sway checks will be fixed, seems related https://github.com/nix-community/home-manager/issues/5311 
    config = {
      output = {
        eDP-1 = {
          bg = "~/.config/sway/wallpaper.jpg fill";
        };
        DP-3 = {
          bg = "~/.config/sway/wallpaper.jpg fill";
        };
      };
      modifier = "Mod4";
    };
    # TODO: figure a way to show notifications on volume change
    extraConfigEarly = "
        # Brightness
        bindsym XF86MonBrightnessDown exec light -U 10
        bindsym XF86MonBrightnessUp exec light -A 10

        # Volume
        bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +5%'
        bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -5%'
        bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
        bindsym --locked XF86AudioPlay exec playerctl play-pause
        bindsym XF86AudioNext exec playerctl next
        bindsym XF86AudioPrev exec playerctl previous
    ";
  };
  home.file.".config/sway/wallpaper.jpg" = {
    source = resources/bg.jpg;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
