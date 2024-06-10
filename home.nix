{ config, pkgs, ... }:

{
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
    gnupg
    grim
    slurp
    wl-clipboard
    mako
    libnotify
    xdg-utils # allows opening links in browser
    nuclear
    playerctl
    # Game developped for windows, unsupported linux
    (appimageTools.wrapType2 { 
      name = "Ankama-Launcher";
      src = fetchurl {
        url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
        sha256 = "sha256-IeV4uo4HwX4InBjM352Jdrrh66dHIFaNkOq8VvXsi9E=";
      };
      extraPkgs = pkgs: with pkgs; [
        wineWowPackages.stable
        samba
      ];
    })
    discord
  ];
  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.pulseaudio = true;
  programs.firefox.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      github.vscode-pull-request-github
    ];
  };
  programs.zsh = {
    enable = true;
  };
  programs.git = {
    enable = true;
    userName = "waldo121";
    userEmail = "17034517+waldo121@users.noreply.github.com";
  };
  services.mako =  {
    enable = true;
    defaultTimeout = 5000;
    layer = "overlay";
  };
  services.gpg-agent.enable = true;
  services.ssh-agent.enable = true;
  services.batsignal.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    config = rec {
      output = {
        eDP-1 = {
          bg = "~/.config/sway/wallpaper.jpg fill";
        };
      };
      modifier = "Mod4";
    };
    extraConfigEarly = "# Brightness
bindsym XF86MonBrightnessDown exec light -U 10
bindsym XF86MonBrightnessUp exec light -A 10

# Volume
bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +5%'
bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -5%'
bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
bindsym --locked XF86AudioPlay exec playerctl play-pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous";
  };
  home.file.".config/sway/wallpaper.jpg" = {
    source = resources/bg.jpg;
  };

  home.sessionVariables = {
    EDITOR = "codium";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
