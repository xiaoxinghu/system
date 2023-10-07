{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    # TODO: move plugins over from ./config/lua/x/plugins.lua
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      (nvim-treesitter.withPlugins (p: [
        p.c
        p.javascript
        p.jsdoc
        p.json
        p.typescript
        p.tsx
        p.html
        p.lua
      ]))
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      telescope-live-grep-args-nvim
      telescope-zoxide
      popup-nvim
      nvim-surround
      comment-nvim
      nightfox-nvim
      lualine-nvim
    ];
    # extraLuaConfig = /* lua */ ''
    #   local map = vim.api.nvim_set_keymap
    #   local options = { noremap = true, silent = true }
    #   map("n", "gp", "<cmd>Telescope find_files<cr>", options)
    #   vim.cmd([[colorscheme nightfox]])
    # '';
    extraPackages = with pkgs; [
      ripgrep
      fzf
    ];
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
