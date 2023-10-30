{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    # shortcut = "a";
    terminal = "screen-256color";
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      nord
    ];

    extraConfig = ''
    set -g @continuum-save-interval '5'
    bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
    set -g @continuum-restore 'on'
    run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };
}
