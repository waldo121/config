{ pkgs,... }:
let 
    luaConfig = ./resources/nvim/init.lua;
    vimConfig = ./resources/nvim/init.vim;
in
{
    programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = builtins.readFile "${vimConfig}";
    extraLuaConfig = builtins.readFile "${luaConfig}";
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
      telescope-ui-select-nvim
      editorconfig-nvim
      none-ls-nvim
      luasnip
      cmp_luasnip
      inc-rename-nvim
    ];
    extraPackages = [
      pkgs.ripgrep
      pkgs.gcc
      pkgs.git
      pkgs.cargo
      pkgs.nodejs_22
      pkgs.python3
      pkgs.stylua
      pkgs.alejandra
      pkgs.tree-sitter
      pkgs.lua
      pkgs.deno
      pkgs.unzip
    ];
  };

}
