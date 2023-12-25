{ config, pkgs,... }:
let
  theEmacs = pkgs.emacs29-macport.overrideAttrs (old: rec {
    withNativeComp = true;
  });
in
pkgs.emacsWithPackagesFromUsePackage {
  config = ./init.el;
  defaultInitFile = false;
  # defaultInitFile = pkgs.substituteAll {
  #   name = "default.el";
  #   src = ./default.org;
  #   # inherit (config.xdg) configHome dataHome;
  # };
  package = theEmacs;
  alwaysEnsure = true;
  # alwaysTangle = true;
  extraEmacsPackages = epkgs: with epkgs; [
    treesit-grammars.with-all-grammars
    (pkgs.callPackage ./packages/copilot.nix {
      inherit (pkgs) fetchFromGitHub;
      inherit (epkgs) trivialBuild all-the-icons;
    })
    (pkgs.callPackage ./packages/bookmark+.nix {
      inherit (pkgs) fetchFromGitHub;
      inherit (epkgs) trivialBuild;
    })
    # (pkgs.callPackage ./config.nix {
    #   inherit (epkgs) trivialBuild all-the-icons;
    # })
  ];
}
