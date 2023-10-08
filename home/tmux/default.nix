{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    # shortcut = "a";
    terminal = "screen-256color";
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      nord
    ];
  };
}
