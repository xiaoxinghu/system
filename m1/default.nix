{ config, pkgs, ... }:
let
  myEmacs = (pkgs.callPackage ./emacs/app.nix {});
in {

  services.nix-daemon.enable = true;
  nix.package = pkgs.nixFlakes;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono
      fira-code
      meslo-lgs-nf
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];
  };

  homebrew = {
    enable = true;
    casks = [
      "iterm2"
      "hammerspoon"
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    binutils
    gnupg
    gnutls
    gnumake
    imagemagick
    pandoc
    lua
    ffmpeg
    myEmacs
  ];

  programs.zsh.enable = true;

  users.users.xiaoxing = {
    name = "xiaoxing";
    home = "/Users/xiaoxing";
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.xiaoxing = import ./home.nix;
  };

  # launchd.user.agents.emacs.path = [ config.environment.systemPath ];
  # launchd.user.agents.emacs.serviceConfig = {
  #   KeepAlive = true;
  #   ProgramArguments = [
  #     "/bin/sh"
  #     "-c"
  #     "/bin/wait4path ${myEmacs}/bin/emacs && exec ${myEmacs}/bin/emacs --fg-daemon"
  #   ];
  #   StandardErrorPath = "/tmp/emacs.err.log";
  #   StandardOutPath = "/tmp/emacs.out.log";
  # };
}
