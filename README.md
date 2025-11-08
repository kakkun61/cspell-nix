# cspell-nix

A Nix Flake module for [cspell](https://cspell.org/).

To introduce cspell to your flake project:

1. Add cspell-nix as a flake input
1. Add this module to `imports`
1. Write your configuration under `cspell.settings`
1. Run `nix flake check`

## Add cspell-nix as a flake input

```nix
{
  inputs.cspell-nix.url = "github:kakkun61/cspell-nix";
}
```

## Add this module to imports

```nix
{
  …
  outputs = inputs@{ flake-parts, cspell-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ cspell-nix.flakeModule ];
  };
}
```

## Write your configuration under `cspell.settings`

```nix
{
  …
  outputs = inputs@{ flake-parts, cspell-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      …
      perSystem = { ... }: {
        cspell.settings.words = [ "nixpkgs" "kakkun" ];
      };
  };
}
```

## Run `nix flake check`

```console
$ nix flake check
```

This project's _flake.nix_ is a live example of using this module.
