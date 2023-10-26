{ config, pkgs,... }:
{
  imports = [
    ./shell
    ./nvim
    ./tmux
    ./emacs
    ./hammerspoon
  ];
  home = {
    stateVersion = "23.05";
    packages = with pkgs; [
      htop
      jq
      fd
      tree
      eza
      fzf
      delta
      nodejs_20
      nodePackages.pnpm
      nodePackages.yarn
      nodePackages.prettier
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      nodePackages."@astrojs/language-server"
      rust-analyzer
    ];
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        indent_style = "space";
        indent_size = 2;
        trim_trailing_whitespace = true;
        insert_final_newline = true;
      };
      "{Makefile,**.mk}" = {
        indent_style = "tab";
      };
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };
    zoxide.enable = true;
    lazygit.enable = true;
    ripgrep.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      extraConfig = {
        credential.helper = "osxkeychain";
      };
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
    bat = {
      enable = true;
      config = {
        theme = "Nord";
        color = "always";
      };
    };
  };
}
