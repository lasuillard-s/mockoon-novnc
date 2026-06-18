{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          inherit (pkgs) pre-commit just shfmt shellcheck mockoon nginx;
        };

        devShells.default = pkgs.mkShell {
          packages = builtins.attrValues self.packages.${system};
          shellHook = ''
            pre-commit install
          '';
        };
      }
    );
}
