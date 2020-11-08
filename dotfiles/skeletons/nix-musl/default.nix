{ nixpkgs ? import <nixpkgs> {} }:
let pkgs = nixpkgs.pkgsMusl;
in
pkgs.stdenv.mkDerivation {
  name = "project";
  nativeBuildInputs = [ ];
}
