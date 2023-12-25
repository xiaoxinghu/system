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

    # Final solution for copying
    # found here: https://github.com/tmux/tmux/issues/592
    # this: https://thoughtbot.com/blog/tmux-copy-paste-on-os-x-a-better-future is outdated
    # Setup 'v' to begin selection as in Vim
    extraConfig = ''
    bind-key -Tcopy-mode-vi 'v' send -X begin-selection
    bind-key -Tcopy-mode-vi 'y' send -X copy-pipe-and-cancel pbcopy

    set -g @continuum-save-interval '5'
    bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
    set -g @continuum-restore 'on'
    run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };
}
