{
  description = "My collection of dev. flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # each subdir is a flake, specify here
    python.url = "path:./python";
    # add more here
  };

  outputs = { self, nixpkgs, flake-utils, python, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        py312 = python.devShells.${system}.python312;
        py313 = python.devShells.${system}.python313;
      in {
        devShells = {
          # python
          python312 = py312;
          python313 = py313;
          python = py313;
        };
      });
}
