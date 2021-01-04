{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchurl ? pkgs.fetchurl, 
  bash ? pkgs.bash, less ? pkgs.less, sdcv ? pkgs.sdcv, gnutar ? pkgs.gnutar, 
  writeScript ? pkgs.writeScript }:
let
  dictd = stdenv.mkDerivation rec {
    pname = "define-dict";
    version = "0.1";

    src = fetchurl {
      url = "https://jb55.com/files/dict.tar";
      sha256 = "fcaf90833b777a1fd9e62282deb245ad62f6ce536f78c6ef503c2d78c3084ab3";
    };

    installPhase = ''
      mkdir -p $out/share
      ${gnutar}/bin/tar xvf $src -C $out/share
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "define";
  version = "0.1";

  src = writeScript "define" ''
    #!${bash}/bin/bash
    export LESS="$LESS --quit-if-one-screen"
    ${sdcv}/bin/sdcv -n --data-dir=${dictd}/share "$@" | ${less}/bin/less
  '';

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/define
  '';
}
