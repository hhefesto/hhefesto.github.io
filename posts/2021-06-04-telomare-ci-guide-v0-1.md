---
title: Telomare's CI Guide V0.1
---

## Telomare's testing plus automatic haddock generation pipeline


### Introduction

This small guide's objective is to document Telomare's CI process for future refactoring and to help enable anyone who would want to do something similar. Our end product of this guide is Telomare's test suits ran every time a new commit is pushed to Github and haddock documentation updated in stand-in-language.github.io/docs/haddock/ if those commits correspond to Stand-In-Language/stand-in-language repository on master branch.

### Requirements

1. `nix flakes` functionality enabled:
  - note: No need of flakes functionality if you just want to use the pipeline (i.e. push and have it work correctly).
  - links:
      0. https://nixos.org/download.html
      1. https://www.tweag.io/blog/2020-05-25-flakes/
      2. https://github.com/colemickens/nixos-flake-example
2. `cachix` with IOG's cache:
   - note:
     - add your user to `nix.trustedUsers` list of strings so that `cachix use iohk` works correctly
   - links:
     0. https://cachix.org/
     1. https://input-output-hk.github.io/haskell.nix/tutorials/getting-started/

### Steps:

1. `flake.nix` :

```nix 
{
  description = "Nix flake for Telomare";

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
          # This overlay adds our project to pkgs
          jumper = final.stdenv.mkDerivation {
            name = "telomareJumper";
            src = ./cbits;
            buildInputs = [ final.boehmgc ];
          };
          gc = final.boehmgc;
          llvm-config = final.llvm_9;
          alex = final.haskellPackages.alex;

          telomare = final.haskell-nix.cabalProject {
            # If these null parameters are absent, you get a RestrictedPathError error
            # from trying to do readIfExists on cabal.project file
            cabalProjectFreeze = null;
            cabalProject = null;
            cabalProjectLocal = null;

            src = final.haskell-nix.cleanSourceHaskell {
              src = ./.;
              name = "telomare";
            };
            compiler-nix-name = "ghc884";
            pkg-def-extras = with final.haskell.lib; [
               (hackage: {
                 llvm-hs = hackage.llvm-hs."9.0.1".revisions.default;
                 llvm-hs-pure = hackage.llvm-hs-pure."9.0.0".revisions.default;
               })
             ];
            modules = [
              { reinstallableLibGhc = true; }
            ];
          };
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };
      flake = pkgs.telomare.flake {};
      flake1 = flake // { packages = flake.packages //
        {
          # This script is ran by Github Actions to do Haddock CI.
          # TODO: refactor to not use nix-shell.
          haddockScript = pkgs.writeShellScriptBin "updateHaddockScript" ''
            nix-shell --run "cabal haddock --haddock-hyperlink-source"
            echo haddockScript OK
          '';
        };
      };
    in flake1 // {
      # Built by `nix build .`
      defaultPackage = flake.packages."telomare:exe:telomare-exe";
      checks = {
        build = self.defaultPackage.x86_64-linux;
        telomareTest0 = flake.packages."telomare:test:telomare-test";
        telomareTest1 = flake.packages."telomare:test:telomare-parser-test";
        telomareTest2 = flake.packages."telomare:test:telomare-serializer-test";
      };

      # This is used by `nix develop .` to open a shell for use with
      # `cabal`, `hlint` and `haskell-language-server`
      devShell = pkgs.telomare.shellFor {
        tools = {
          cabal = "latest";
          hlint = "latest";
          haskell-language-server = "latest";
          ghcid = "latest";
        };
      };
    });
}

```
