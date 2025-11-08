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

        flake.app = {
          enable = lib.mkEnableOption "makeCspellConfig application";

          program = lib.mkOption {
            description = "The makeCspellConfig program.";
            type = lib.types.package;
            default = pkgs.writeShellApplication {
              name = "make-cspell-config";
              text =
                let
                  inherit (config') configFile;
                in
                ''
                  cp -f ${configFile} "''${1:-cspell.json}"
                '';
            };
          };
        };
      };
      config =
        let
          inherit (config')
            check
            projectRoot
            settings
            flake
            ;
        in
        {
          checks.cspell = check projectRoot;
          apps = lib.mkIf flake.app.enable {
            makeCspellConfig = {
              meta.description = "Generate a cspell configuration file.";
              type = "app";
              program = "${flake.app.program}/bin/${flake.app.program.name}";
            };
          };
          cspell.configFile = lib.mkDefault (jsonFormat.generate "cspell.json" settings);
        };
    }
  );
}
