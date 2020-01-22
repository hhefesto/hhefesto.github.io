{ pkgs ? import <nixpkgs> {}, ghc ? pkgs.ghc }:

pkgs.haskell.lib.buildStackProject {
  name = "blog.hhefesto.com";
  inherit ghc;
  buildInputs = with pkgs; [ zlib
                             haskellPackages.hakyll
                             gmp
                           ];
  LANG = "en_US.UTF-8";
  TMPDIR = "/tmp";
}
