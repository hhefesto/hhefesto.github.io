---
title: Hakyll + Stack + Nix
---

## Prelude

This is my first post. Hello, world!

In this post we are going to walk through my blog platform setup with Hakyll, Stack and Nix.

Some links you might want to explore beforehand:

- [Hakyll Github Pages Tutorial by Hakyll's author](https://jaspervdj.be/hakyll/tutorials/github-pages-tutorial.html)
- [Hakyll's Home Page](https://jaspervdj.be/hakyll/)
- [Hakyll Presentation and demo by Hakyll's author](https://www.youtube.com/watch?v=t8gim17hryw)
- [Nix/NixOS Homepage](https://nixos.org/)
- [Github Pages Homepage](https://pages.github.com/)

## Intruduction

So [this](/) should be something similar to our end result: a place where to write your blog posts.

This post is basically just following [this](https://jaspervdj.be/hakyll/tutorials/github-pages-tutorial.html) and turning on `stack`'s `nix` functionality.

This is desireable because non-haskell dependancies are solved in the case of adding any.

## Steps

0. I am using NixOS 19.09 with stack 1.9.3 taken from the 19.03 channel

1. Follow [this](https://jaspervdj.be/hakyll/tutorials/github-pages-tutorial.html) tutorial until you've hit

   ```
   stack new myblog hakyll-template
   ```

2. Use `resolver: lts-12.26` on stack.yaml

3. Then append this to stack.yaml

   ```nix
   nix:
     enable: true
     pure: true
     shell-file: shell.nix
   ```

4. Create `shell.nix` with this code, and change the `name` to correspond to whatever name you want
   ```nix
   { pkgs ? import <nixpkgs> {}, ghc ? pkgs.ghc }:

   pkgs.haskell.lib.buildStackProject {
     name = "blog.hhefesto.com";
     inherit ghc;
     buildInputs = with pkgs; [ zlib
                                haskellPackages.hakyll
                                gmp
                                # Any external dependancy you need may go here
                                # search https://nixos.org/nixos/packages.html?channel=nixos-19.09
                                # for the dependancy you're looking for and just add it
                              ];
     LANG = "en_US.UTF-8";
     TMPDIR = "/tmp";
   }
   ```

5. Continue jaspervdj's [tutorial](https://jaspervdj.be/hakyll/tutorials/github-pages-tutorial.html)