doc/options.md: dev/make-options-doc flake.nix flake-module.nix
	-mkdir -p $(@D)
	./dev/make-options-doc > $@

cspell.json: flake.nix flake-module.nix
	nix build .#cspell-json --out-link $@
