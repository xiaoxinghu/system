{
  pkgs,
  trivialBuild,
  fetchFromGitHub,
}:
trivialBuild rec {
  pname = "bookmark+";
  version = "2023.06.30";
  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "bookmark-plus";
    rev = "d73c1b572a7cdadcf35600b335966928044abee2";
    hash = "sha256-2o5d18n/xSDNYu0gB6HBM/uGltb+yptbnxEnZKX7QZg=";
  };
  # packageRequires = with pkgs.emacsPackages.melpaPackages; [
  #   dash
  #   s
  #   editorconfig
  # ];
}
