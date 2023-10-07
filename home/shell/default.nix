{ config, pkgs,... }:

let
  aliases = rec {
    # --- ls ---
    ls = "eza";
    l = "eza -lbF --git"; # list, size, type, git
    ll="eza -lbGF --git"; # long list
    # long list, modified date sort
    llm = "eza -lbGd --git --sort=modified";
    # all list
    la = "eza -lbhHigmSa --time-style=long-iso --git --color-scale";
    # all + extended list
    lx = "eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale";
    # specialty views
    lS = "eza -1"; # one column, just names
    lt = "eza --tree --level=2"; # tree
    # --- vim ---
    v = "nvim";
    vv = "nvim $(fzf)";
  };
in {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    localVariables = {
      TERM = "xterm-256color";
      EDITOR = "nvim";
    };
    shellAliases = aliases;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = builtins.toString ./.;
        file = "p10k.zsh";
      }
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "";
        bash_indicator = "[BASH](bright-white) ";
        zsh_indicator = "[ZSH](bright-white) ";
      };
    };
  };
}
