{
  self,
  inputs,
  lib,
  flake-parts-lib,
  specialArgs,
  moduleLocation,
  config,
  options,
  _class,
  _prefix,
}:
{
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    {
      system,
      lib,
      specialArgs,
      config,
      options,
      _class,
      _prefix,
      pkgs,
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
            Configuration for cspell, see <link xlink:href="https://cspell.org/docs/Configuration" />.
          '';
          type = lib.types.submodule { freeformType = jsonFormat.type; };
          default = { };
        };

        configFile = lib.mkOption {
          description = "Path to cspell configuration file.";
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
      };
      config =
        let
          inherit (config') check projectRoot settings;
        in
        {
          checks.cspell = check projectRoot;
          cspell.configFile = lib.mkDefault (jsonFormat.generate "cspell.json" settings);
        };
    }
  );
}
