# cspell-nix change log

## v2.0.1

*2026-01-23*

Changes:

- Change the license from GPL-3.0-only to Apache-2.0.

## v2.0.0

*2026-01-19*

Changes:

- Add `flakeModules.default` and `modules.flake.default` to expose flake module too.
- The `cspell.flake.app` option, which generates `apps.<system>.makeCspellConfig`, has been deprecated and replaced with the `cspell.packages.cspell-json` option, which generates `packages.<system>.cspell-json`.
- Remove Free BSD from supported systems.

## v1.0.0

*2026-01-17*

Initial release.
