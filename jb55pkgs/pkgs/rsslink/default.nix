{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchurl ? pkgs.fetchurl, 
  bash ? pkgs.bash, pup ? pkgs.pup, writeScript ? pkgs.writeScript }:
stdenv.mkDerivation rec {
  pname = "rsslink";
  version = "0.1";

  src = writeScript "rsslink" ''
    #!${bash}/bin/bash
    ${pup}/bin/pup 'link[type="application/rss+xml"] attr{href}' | head -n1
  '';

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/rsslink
  '';
}
