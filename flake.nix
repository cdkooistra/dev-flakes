{
  description = "My collection of dev. flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    

    # each subdir is a flake, specify here
    python.url = "path:./python";
    rust.url = "path:./rust";
    zola.url = "path:./zola";
    # add more here
  };

  outputs = inputs@{ nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        # process subflakes
        subflakes = builtins.removeAttrs inputs [ "nixpkgs" "flake-utils" "self" ];
        
        extractShells = name: flake:
          let shells = flake.devShells.${system} or {};
          in shells // {
            # alias the subflake name pointing to default shell
            ${name} = shells.default or null;
          };
        
        # merge all shells from all subflakes
        allShells = builtins.foldl' 
          (acc: name: acc // (extractShells name subflakes.${name}))
          {}
          (builtins.attrNames subflakes);
          
      in {
        devShells = builtins.removeAttrs allShells 
          (builtins.filter (name: allShells.${name} == null) (builtins.attrNames allShells));
      });
}
