# `pkgs.callPackage ./options-doc.nix { inherit perSystemModule; }` returns a
# derivation that produces a module options documentation.
{
  perSystemModule,
  pkgs,
  lib,
}:
let
  eval = lib.evalModules {
    modules = [
      { _module.args = { inherit pkgs; }; }
      (
        arg@{
          lib,
          config,
          pkgs,
          ...
        }:
        {
          inherit (perSystemModule arg) options;
        }
      )
    ];
    prefix = [
      "perSystem"
      "<system>"
    ];
    class = "perSystem";
  };
  doc = pkgs.nixosOptionsDoc { inherit (eval) options; };
in
doc.optionsCommonMark
