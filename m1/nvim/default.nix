{ config, pkgs, lib, ... }:
{
  # imports = [./plugins];

  lib.vimUtils = rec {
    # For plugins configured with lua
    wrapLuaConfig = luaConfig: ''
      lua<<EOF
      ${luaConfig}
      EOF
    '';
    readVimConfigRaw = file:
      if (lib.strings.hasSuffix ".lua" (builtins.toString file))
      then wrapLuaConfig (builtins.readFile file)
      else builtins.readFile file;
    readVimConfig = file: ''
      if !exists('g:vscode')
        ${readVimConfigRaw file}
      endif
    '';
    pluginWithCfg = {
      plugin,
      file,
    }: {
      inherit plugin;
      config = readVimConfig file;
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    # TODO: move plugins over from ./config/lua/x/plugins.lua
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      telescope-live-grep-args-nvim
      telescope-zoxide
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
      popup-nvim
      nvim-surround
      comment-nvim
      nightfox-nvim
      lualine-nvim
      bufferline-nvim
      # auto completion
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lua
      luasnip
      cmp_luasnip

      editorconfig-nvim
    ];
    extraPackages = with pkgs; [
      ripgrep
      fzf
    ];
    extraLuaConfig = ''
      ${builtins.readFile ./config/init.lua}
    '';
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
