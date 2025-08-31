{
  description = "Python 3.13 dev. environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python313Full
            uv
          ];

          shellHook = ''
            VENV=.venv
            if [ ! -d "$VENV" ]; then
              uv venv $VENV
            fi
            source $VENV/bin/activate
            echo "Python 3.13 with uv ready ($VENV)"
          '';
        };
      }
    );
}
