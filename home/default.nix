{ config, pkgs,... }:
{
  imports = [
    ./shell
    ./nvim
    ./tmux
  ];
  home = {
    stateVersion = "23.05";
    packages = with pkgs; [
      htop
      binutils
      jq
      fd
      tree
      ffmpeg
      gnumake
      eza
      fzf
      nodejs_20
      nodePackages.pnpm
      nodePackages.yarn
      nodePackages.typescript
      nodePackages.typescript-language-server
      delta
    ];
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
