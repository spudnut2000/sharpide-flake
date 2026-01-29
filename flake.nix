
{
  description = "A flake for SharpIDE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true; 
        };
      in
      {
        packages.default = pkgs.callPackage ./default.nix { };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/sharpide";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ self.packages.${system}.default ];
        };
      }
    );
}
