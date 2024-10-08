{ pkgs, ... }:

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
    playerctl
    go
    gopls
    gh
    gimp
    (nerdfonts.override { fonts = [ "DroidSansMono" ]; })
    # Game developped for windows, unsupported on linux, but works well enough for me
    (appimageTools.wrapType2 { 
      name = "Ankama-Launcher";
      src = fetchurl {
        url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
        sha256 = "sha256-ssCjFrQYI/pxnsjcy1xLSpuGGy0NGMOcNP9RiNDhE/w=";
      };
      extraPkgs = pkgs: with pkgs; [
        wine64
        wineWowPackages.waylandFull
        samba
      ];
    })
    discord
  ];
  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.pulseaudio = true;
  fonts.fontconfig.enable = true;
  programs.firefox.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      github.vscode-pull-request-github
      golang.go
    ];
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set expandtab
      set tabstop=4
      set softtabstop=4
      set shiftwidth=4
      set relativenumber
      set encoding=utf8
      set guifont=DroidSansMono\ Nerd\ Font\ 11
    '';
    extraLuaConfig = ''
      vim.cmd.colorscheme "OceanicNext"
      vim.g.mapleader = " "
      local builtin = require('telescope.builtin')
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "typescript", "javascript", "lua", "vim", "markdown", "python", "bash", "nix" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        parser_install_dir = "~/.config/nvim/treesitter/parsers",
      }
      require("lualine").setup()
      require("nvim-web-devicons").setup()
      require("mason").setup()
      require("mason-lspconfig").setup {
        automatic_installation = true,
      }
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.lua_ls.setup{}
      lspconfig.nil_ls.setup{}
      lspconfig.marksman.setup{}
      lspconfig.biome.setup{}
      lspconfig.ruff_lsp.setup{}
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
      vim.keymap.set('n', '~', ':Neotree toggle current reveal_force_cwd<cr>')
      vim.keymap.set('n', '|', ':Neotree reveal<cr>')
      vim.keymap.set('n', 'gd', ':Neotree float reveal_file=<cfile> reveal_force_cwd<cr>')
      vim.keymap.set('n', '<leader>b', ':Neotree toggle show buffers right<cr>')
      vim.keymap.set('n', '<leader>s', ':Neotree float git status<cr>')
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc  = 'Lsp Hover' })
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = 'Lsp Definition' })
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = 'Lsp References' })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = 'Lsp Action'})
    '';
    plugins = with pkgs.vimPlugins; [
      vim-colorschemes
      telescope-nvim
      nvim-treesitter
      neo-tree-nvim
      lualine-nvim
      mason-nvim
      mason-lspconfig-nvim
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-web-devicons
      nvim-cmp
    ];
    extraPackages = [
      pkgs.ripgrep
      pkgs.gcc
      pkgs.git
      pkgs.cargo
      pkgs.nodejs_22
      pkgs.python3
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
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
  services.ssh-agent.enable = true;
  services.batsignal.enable = true;
  services.mpd-mpris.enable = true;
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
