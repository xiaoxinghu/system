{ config, pkgs, ... }:
let
  myEmacs = (pkgs.callPackage ./emacs/app.nix {});
  emacsApp = "${myEmacs}/Applications/Emacs.app/Contents/MacOS/Emacs";
in {

  services.nix-daemon.enable = true;
  nix.package = pkgs.nixFlakes;
  nixpkgs.config.allowUnfree = true;

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
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    binutils
    gnupg
    gnutls
    coreutils
    gnumake
    imagemagick
    pandoc
    lua
    ffmpeg
    myEmacs
    (aspellWithDicts (d: [ d.en ]))
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

  # launchd.user.agents.emacs = {
  #   path = [ config.environment.systemPath ];
  #   serviceConfig = {
  #     KeepAlive = true;
  #     ProgramArguments = [
  #       "/bin/sh"
  #       "-c"
  #       "/bin/wait4path ${emacsApp} && exec ${emacsApp} --daemon"
  #     ];
  #     StandardErrorPath = "/tmp/emacs.err.log";
  #     StandardOutPath = "/tmp/emacs.out.log";
  #   };
  # };

}
