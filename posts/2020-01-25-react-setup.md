---
title: Vanilla React on NixOS setup
---

## Introduction

This post should provide a starting point to follow [React's introduction tutorial](https://reactjs.org/tutorial/tutorial.html) from [my current NixOS enviroment](https://releases.nixos.org/nixos/19.03/nixos-19.03.173684.c8db7a8a16e/nixexprs.tar.xz).

## Steps

0. Create a shell.nix file with
   ```
   #######################################################
   ## Using this instead will use your current nix-channel
   # with import <nixpkgs> {};
   with import (fetchTarball https://releases.nixos.org/nixos/19.09/nixos-19.09.1936.e6391b4389e/nixexprs.tar.xz) { };
   #######################################################

   stdenv.mkDerivation {
     name = "react-bootstrap-shell";
     buildInputs = with pkgs; [
       nodePackages.create-react-app
       nodejs
       yarn
     ];
   }
   ```
1. Run `nix-shell --pure shell.nix`
2. Continue [React's introduction tutorial](https://reactjs.org/tutorial/tutorial.html) where you `npx create-react-app my-app`
