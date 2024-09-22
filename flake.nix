{
  description = "A reusable Rust development environment flake";

  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs/nixos-unstable"; # Adjust this to the desired version
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { system = system; };
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustup pkg-config direnv ];
          rustToolchains = [ "stable" "beta" "nightly" ];
          shellHook = ''
            for tc in $rustToolchains; do
              rustup install $tc
              rustup +$tc component add rust-analyzer
              rustup +$tc component add clippy
            done
          '';
        };
      });
}

