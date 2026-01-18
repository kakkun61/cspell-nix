# `import ./flake-module.nix { inherit self; }` returns a flake-parts' per-system module.
{
  self,
}:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  config' = config.cspell;
  jsonFormat = pkgs.formats.json { };
in
{
  options.cspell = {
    package = lib.mkPackageOption pkgs "cspell" { };

    settings = lib.mkOption {
      description = ''
        Configuration for cspell, see <https://cspell.org/docs/Configuration>.
      '';
      type = lib.types.submodule { freeformType = jsonFormat.type; };
      default = { };
    };

    configFile = lib.mkOption {
      description = "The path to the cspell configuration file.";
      type = lib.types.path;
    };

    projectRoot = lib.mkOption {
      description = "The project root directory.";
      type = lib.types.path;
      default = self;
      defaultText = lib.literalExpression "self";
    };

    check = lib.mkOption {
      description = "The flake check script.";
      type = lib.types.functionTo lib.types.package;
      default =
        self:
        let
          inherit (config') package configFile;
        in
        pkgs.runCommandLocal "cspell-check"
          {
            nativeBuildInputs = [ package ];
          }
          ''
            cspell --version
            cd ${self}
            cspell --config ${configFile} .
            touch $out
          '';
    };

    packages.cspell-json.enable = lib.mkEnableOption "`packages.<system>.cspell-json`";
  };

  config =
    let
      inherit (config')
        check
        projectRoot
        settings
        packages
        configFile
        ;
    in
    {
      checks.cspell = check projectRoot;
      packages = lib.mkIf packages.cspell-json.enable {
        cspell-json = configFile;
      };
      cspell.configFile = lib.mkDefault (jsonFormat.generate "cspell.json" settings);
    };
}
