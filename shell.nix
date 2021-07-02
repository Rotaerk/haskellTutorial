{ pkgs ? import <nixpkgs> {} }:
with pkgs;
with haskellPackages;
mkShell {
  packages =
    [ python39Packages.grip ]
    ++
    (with haskellPackages; [
      ghc
      cabal-install
    ]);
}
