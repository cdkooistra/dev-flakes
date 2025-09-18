# dev-flakes

This repo consists of several templates for dev. flakes I use.
Specifically, these flakes serve as a basis for all my development, which I can always input and then adjust for specific deployments.

## Setup

I use a top-level aggregator which allows me to init a dev flake like this:

```bash
nix develop github:cdkooistra/dev-flakes#<desired flake here>
```

Or use it as an input in a flake:

```nix
{
  inputs.python-dev.url = "github:cdkooistra/dev-flakes#<desired flake here>";

  outputs = { self, nixpkgs, python-dev }:
    let
      inherit (python-dev.outputs) devShells;
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.default = pkgs.mkShell {
        buildInputs = devShells.default.buildInputs ++ [ pkgs.docker pkgs.git ];
        shellHook = ''
          ${devShells.default.shellHook}
          echo "added docker and git for deployment"
        '';
      };
    };
}
```

Or when you most likely will not make any changes, use the following flake:

```nix
{
  inputs = {
    dev-flakes.url = "github:cdkooistra/dev-flakes";
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  outputs = { dev-flakes, flake-utils, ... }:
    let shell = "<desired flake here>";
    in flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = dev-flakes.devShells.${system}.${shell};
    });
}
```
