{
  pkgs,
  trivialBuild,
  fetchFromGitHub,
  all-the-icons,
}:
trivialBuild rec {
  pname = "copilot";
  version = "0.10.0";
  src = fetchFromGitHub {
    owner = "zerolfx";
    repo = "copilot.el";
    rev = "3086d214f40a9689d00d647667b73795abc07bc9";
    hash = "sha256-FvR6cCUbcbUePIqL1IAx1qIpFLVnn/KNVIpGdRNMXiU=";
  };
  # elisp dependencies
  propagatedUserEnvPkgs = [
    all-the-icons
  ];
  packageRequires = with pkgs.emacsPackages.melpaPackages; [
    dash
    s
    editorconfig
  ];
  buildInputs = propagatedUserEnvPkgs;

  postInstall = ''
    LISPDIR=$out/share/emacs/site-lisp
    cp -r dist $LISPDIR/dist
  '';
}
