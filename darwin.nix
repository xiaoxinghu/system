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

  environment.systemPackages = with pkgs; [
    emacs29-macport
  ];

  programs.zsh.enable = true;
}
