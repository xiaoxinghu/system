{ config, pkgs,... }:
let
in {

  home.file = {
    ".emacs.d/init.el" = {
      source = ./init.el;
      # recursive = true;
      # onChange = ''
      # echo ---------- onChange ----------
      # # emacs --batch --quick --load org .emacs.d/config.org --funcall org-babel-tangle
      # rm .emacs.d/config.el
      # echo ---------- end ----------
      # '';
    };
  };

  programs.emacs = {
    enable = true;
    package = (pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      defaultInitFile = false;
      # defaultInitFile = pkgs.substituteAll {
      #   name = "default.el";
      #   src = ./default.org;
      #   # inherit (config.xdg) configHome dataHome;
      # };
      package = pkgs.emacs29-macport;
      alwaysEnsure = true;
      # alwaysTangle = true;
      extraEmacsPackages = epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
        (pkgs.callPackage ./package/copilot.nix {
          inherit (pkgs) fetchFromGitHub;
          inherit (epkgs) trivialBuild all-the-icons;
        })
        (pkgs.callPackage ./package/bookmark+.nix {
          inherit (pkgs) fetchFromGitHub;
          inherit (epkgs) trivialBuild;
        })
        # (pkgs.callPackage ./config.nix {
        #   inherit (epkgs) trivialBuild all-the-icons;
        # })
      ];
    });
  };
}
