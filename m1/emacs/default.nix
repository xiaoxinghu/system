{ config, pkgs,... }:
let
  home           = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
  xdg_dataHome   = "${home}/.local/share";
  xdg_stateHome  = "${home}/.local/state";
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

    # Raycast script so that "Run Emacs" is available and uses Emacs daemon
    # "${xdg_dataHome}/bin/emacsclient" = {
    #   executable = true;
    #   text = ''
    #   #!/bin/zsh
    #   #
    #   # Required parameters:
    #   # @raycast.schemaVersion 1
    #   # @raycast.title Run Emacs
    #   # @raycast.mode silent
    #   #
    #   # Optional parameters:
    #   # @raycast.packageName Emacs
    #   # @raycast.icon ${xdg_dataHome}/img/icons/Emacs.icns
    #   # @raycast.iconDark ${xdg_dataHome}/img/icons/Emacs.icns

    #   if [[ $1 = "-t" ]]; then
    #     # Terminal mode
    #     ${pkgs.emacs}/bin/emacsclient -t $@
    #   else
    #     # GUI mode
    #     ${pkgs.emacs}/bin/emacsclient -c -n $@
    #   fi
    # '';
    # };

  };

  # programs.emacs = {
  #   enable = true;
  #   package = (pkgs.emacsWithPackagesFromUsePackage {
  #     config = ./init.el;
  #     defaultInitFile = false;
  #     # defaultInitFile = pkgs.substituteAll {
  #     #   name = "default.el";
  #     #   src = ./default.org;
  #     #   # inherit (config.xdg) configHome dataHome;
  #     # };
  #     package = pkgs.emacs29-macport;
  #     alwaysEnsure = true;
  #     # alwaysTangle = true;
  #     extraEmacsPackages = epkgs: with epkgs; [
  #       treesit-grammars.with-all-grammars
  #       (pkgs.callPackage ./package/copilot.nix {
  #         inherit (pkgs) fetchFromGitHub;
  #         inherit (epkgs) trivialBuild all-the-icons;
  #       })
  #       (pkgs.callPackage ./package/bookmark+.nix {
  #         inherit (pkgs) fetchFromGitHub;
  #         inherit (epkgs) trivialBuild;
  #       })
  #       # (pkgs.callPackage ./config.nix {
  #       #   inherit (epkgs) trivialBuild all-the-icons;
  #       # })
  #     ];
  #   });
  # };

}
