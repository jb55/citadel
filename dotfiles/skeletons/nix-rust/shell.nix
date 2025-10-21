{ pkgs ? import <nixpkgs> {} }:
with pkgs;
mkShell {
  nativeBuildInputs = [ rustup pkg-config ];
}
