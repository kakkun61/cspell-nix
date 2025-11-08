{
  description = "cspell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      treefmt-nix,
    }:
    let
      flakeModule = import ./flake-module.nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        treefmt-nix.flakeModule
        flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        {
          apps.makeCspellConfig = {
            meta.description = "Generate a cspell configuration file.";
            type = "app";
            program =
              let
                app = pkgs.writeShellApplication {
                  name = "make-cspell-config";
                  text = ''
                    cp -f ${config.cspell.configFile} "''${1:-cspell.json}"
                  '';
                };
              in
              "${app}/bin/make-cspell-config";
          };
          treefmt = {
            programs = {
              nixfmt.enable = true;
              yamlfmt.enable = true;
            };
          };
          cspell.settings.words = [
            "cachix"
            "coreutils"
            "kakkun"
            "nixfmt"
            "nixos"
            "nixpkgs"
            "numtide"
            "pkgs"
            "treefmt"
            "xlink"
          ];
        };
      flake = {
        inherit flakeModule;
      };
    };
}
