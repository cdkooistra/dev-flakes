{
  description = "Python dev. flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        py312 = pkgs.mkShell {
          buildInputs = with pkgs; [ python312 uv ];
          shellHook = ''
            VENV=.venv
            if [ ! -d "$VENV" ]; then uv venv $VENV; fi
            source $VENV/bin/activate
            echo "Python 3.12 with uv ready ($VENV)"
          '';
        };

        py313 = pkgs.mkShell {
          buildInputs = with pkgs; [ python313 uv ];
          shellHook = ''
            VENV=.venv
            if [ ! -d "$VENV" ]; then uv venv $VENV; fi
            source $VENV/bin/activate
            echo "Python 3.13 with uv ready ($VENV)"
          '';
        };
      in {
        devShells = {
          python312 = py312;
          python313 = py313;
          default = py313;
        };
      });
}
