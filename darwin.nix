{ config, pkgs, ... }:
{
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixFlakes;

  # services.emacs = {
  #   enable = true;
  #   package = pkgs.emacs29-macport;
  # };

  environment.systemPackages = with pkgs; [
    emacs29-macport
  ];
  programs.zsh.enable = true;
}
