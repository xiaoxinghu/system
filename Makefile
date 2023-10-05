# one-time setup
setup:
	nix run nix-darwin -- switch --flake .

# apply changes
rebuild:
	darwin-rebuild switch --flake .
