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
          # Tools used in CI/CD pipelines
          inherit (pkgs)
            shfmt
            shellcheck
            ;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            pre-commit
            just
            shfmt
            shellcheck
            mockoon
            nginx
          ];
          shellHook = ''
            pre-commit install
          '';
        };
      }
    );
}
