# cspell-nix flake module options

This file is auto-generated and do not edit directly.

## perSystem\.\<system>\.cspell\.package



The cspell package to use\.



*Type:*
package



*Default:*
` pkgs.cspell `



## perSystem\.\<system>\.cspell\.packages\.cspell-json\.enable



Whether to enable ` packages.<system>.cspell-json `\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## perSystem\.\<system>\.cspell\.check

The flake check script\.



*Type:*
function that evaluates to a(n) package



*Default:*
` <function> `



## perSystem\.\<system>\.cspell\.configFile



The path to the cspell configuration file\.



*Type:*
absolute path



## perSystem\.\<system>\.cspell\.projectRoot



The project root directory\.



*Type:*
absolute path



*Default:*
` self `



## perSystem\.\<system>\.cspell\.settings



Configuration for cspell, see [https://cspell\.org/docs/Configuration](https://cspell\.org/docs/Configuration)\.



*Type:*
open submodule of (JSON value)



*Default:*
` { } `


