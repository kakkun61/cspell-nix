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
      perSystemModule = import ./flake-module.nix { inherit self; };
      flakeModule = {
        _class = "flake";
        options.perSystem = flake-parts.lib.mkPerSystemOption perSystemModule;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        flake-parts.flakeModules.flakeModules
        flake-parts.flakeModules.modules
        treefmt-nix.flakeModule
        flakeModule
      ];
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          pkgs,
          lib,
          config,
          system,
          ...
        }:
        {
          packages.optionsDoc = pkgs.callPackage ./options-doc.nix { inherit perSystemModule; };
          treefmt = {
            programs = {
              nixfmt.enable = true;
              yamlfmt.enable = true;
            };
          };
          cspell = {
            settings.words = [
              "cachix"
              "coreutils"
              "errexit"
              "kakkun"
              "nixfmt"
              "nixos"
              "nixpkgs"
              "nounset"
              "numtide"
              "pipefail"
              "pkgs"
              "treefmt"
              "xlink"
            ];
            packages.cspell-json.enable = true;
          };
        };
      flake = {
        inherit flakeModule;
        modules.flake.default = flakeModule;
      };
    };
}
