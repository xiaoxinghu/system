CONFIG_FILES = ./m1/emacs/init.org ./m1/nvim/init.org

all: build

update:
	nix flake update --recreate-lock-file

# one-time setup
init:
	nix run nix-darwin -- switch --flake .

# apply changes
build: build_config_files
	darwin-rebuild switch --flake .

build_config_files: $(CONFIG_FILES)
	./tangle.sh $^
