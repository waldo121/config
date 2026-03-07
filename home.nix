{ pkgs, ... }:

{
 imports =  [
    ./code.nix
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
    spotify
    gromit-mpx
    nerd-fonts.droid-sans-mono
    discord
    gpu-screen-recorder
    ffmpeg
    xdg-desktop-portal-wlr
    libva-utils
  ];
  
  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.pulseaudio = true;
  fonts.fontconfig.enable = true;
  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
  };
  programs.bash = {
    enable = true;
  };
  
  programs.git = {
    enable = true;
    settings = {
      user = {
	email = "17034517+waldo121@users.noreply.github.com";
      	name = "waldo121";
      };
      core = {
        editor = "codium --wait";
      };
    };
  };
  programs.swaylock.enable = true;
  services.mako =  {
    enable = true;
    settings = {
      default-timeout = 5000;
      layer = "overlay"; 
    };
  };
  services.gpg-agent = {
    enable = true;
    pinentry = {
      package = pkgs.pinentry-curses;
    };
  };
  services.ssh-agent.enable = true;
  services.batsignal.enable = true;
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
          position = "0 0";
        };
        DP-3 = {
          bg = "~/.config/sway/wallpaper.jpg fill";
        };
        HDMI-A-1 = {
          bg = "~/.config/sway/wallpaper.jpg fill";
          position = "1920 0";
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
        exec --no-startup-id dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
        exec --no-startup-id xdg-desktop-portal-wlr -r
    ";
  };
  home.file.".config/sway/wallpaper.jpg" = {
    source = resources/bg.jpg;
  };
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
