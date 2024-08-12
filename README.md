# log

## How to build:
1. Install `nix`
2. checkout `git`'s `develop` branch
3. do changes
4. `nix develop`
5. `cabal build log`
6. `cabal run log -- clean`
7. `cabal run log -- build`
8. `cabal run log -- watch` # which lets you watch at http://localhost:8001/`C-c` on terminal to stop watch
9. commit `develop` branch
10. checkout master
11. `./rsync.sh`
12. push master

