 {
  description = "Nix flake for log.hhefesto.com";

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, haskellNix, flake-compat }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      overlays = [ haskellNix.overlay
        (final: prev: {
          telomare-documentation = final.haskell-nix.project' {
              src = ./.;
              compiler-nix-name = "ghc884";
          };
          zlib = prev.zlib;
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };

      flake = pkgs.telomare-documentation.flake {};
      # flake = pkgs.telomare.flake {};
    in flake // {
      # Built by `nix build .`
      defaultPackage = flake.packages."log:exe:log";

      # This is used by `nix develop .` to open a shell for use with
      # `cabal`, `hlint` and `haskell-language-server`
      devShell = pkgs.telomare-documentation.shellFor {
        tools = {
          cabal = "latest";
          haskell-language-server = "latest";
          ghcid = "latest";
        };
      };
    });
}
