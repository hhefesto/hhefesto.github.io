{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-compat, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [];
      perSystem = { self', system, ... }:
      let pkgs = import nixpkgs { inherit system; };
          t = pkgs.lib.trivial;
          hl = pkgs.haskell.lib;
          compiler = pkgs.haskell.packages.ghc98;
          project = runTests: executable-name: devTools: # [1]
            let addBuildTools = (t.flip hl.addBuildTools) devTools;
                doRunTests =
                  if runTests then hl.doCheck else hl.dontCheck;
            in compiler.developPackage {
              root = pkgs.lib.sourceFilesBySuffices ./.
                       [ ".cabal"
                         ".hs"
                         "LICENSE"
                       ];
              name = executable-name;
              returnShellEnv = !(devTools == [ ]); # [2]
              modifier = (t.flip t.pipe) [
                addBuildTools
                doRunTests
                # hl.dontHaddock
              ];
            };
      in {
        packages.hhefesto-blog = project false "hhefesto-blog" [ ]; # [3]
        packages.default = self.packages.${system}.hhefesto-blog;
        apps.default = {
          type = "app";
          program = self.packages.${system}.hhefesto-blog + "/bin/hhefesto-blog";
        };
        devShells.default = project true "hhefesto-blog-with-tools" (with compiler; [ # [4]
          cabal-install
          haskell-language-server
          hlint
          ghcid
          stylish-haskell
        ]);
        checks = {
          build-and-tests = project true "hhefesto-blog-with-tests" [ ];
        };
      };
    };
}
