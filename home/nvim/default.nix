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
      telescope-nvim
    ];
    extraPackages = [pkgs.ripgrep];
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
