{ config, pkgs, ... }:
{
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
    # pkgs.emacs29-macport
    # (emacsWithPackagesFromUsePackage {
    #   config = ./home/emacs/emacs.d/init.el;
    #   defaultInitFile = true;
    #   # defaultInitFile = pkgs.substituteAll {
    #   #   name = "default.el";
    #   #   src = ./default.org;
    #   #   # inherit (config.xdg) configHome dataHome;
    #   # };
    #   package = pkgs.emacs29-macport;
    #   alwaysEnsure = true;
    #   alwaysTangle = true;
    #   # extraEmacsPackages = epkgs: [
    #   #   (pkgs.callPackage ./home/emacs/config.nix {
    #   #     inherit (epkgs) trivialBuild all-the-icons;
    #   #   })
    #   # ];
    # })
  ];

  programs.zsh.enable = true;
}
