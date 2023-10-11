{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, emacs-overlay, ... }:
  let
    user = "xiaoxing";
  in
  {

    # nixpkgs.overlays = [
    #   (import (builtins.fetchTarball {
    #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    #   }))
    # ];

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    # darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
    #   modules = [ configuration ];
    # };

    darwinConfigurations = let user = "xiaoxing"; in {
      "Xiaoxings-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          { nixpkgs.overlays = [ emacs-overlay.overlay ]; }
          home-manager.darwinModules.home-manager
          ./m1
        ];
      };
    };

    # Expose the package set, including overlays, for convenience.
    # darwinPackages = self.darwinConfigurations."simple".pkgs;
  };
}
