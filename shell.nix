{ pkgs ? import <nixpkgs> {} }:
with pkgs;
mkShell {
  packages =
    with haskellPackages; [
      ghc
      cabal-install
    ];
}
