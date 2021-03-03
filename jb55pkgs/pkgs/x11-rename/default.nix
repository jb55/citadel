{ pkgs        ? import <nixpkgs> {},
  stdenv      ? pkgs.stdenv,
  fetchurl    ? pkgs.fetchurl, 
  bash        ? pkgs.bash,
  xdotool     ? pkgs.xdotool,
  zenity      ? pkgs.gnome3.zenity,
  writeScript ? pkgs.writeScript 
}:
let
  x11-rename-zen = writeScript "x11-rename-zen" ''
    #!${bash}/bin/bash
    name="$(${zenity}/bin/zenity --entry --text=name:)"
    ${xdotool}/bin/xdotool selectwindow set_window --name $name
  '';
in
stdenv.mkDerivation rec {
  pname = "x11-rename";
  version = "0.1";

  src = writeScript pname ''
    #!${bash}/bin/bash
    ${xdotool}/bin/xdotool selectwindow set_window --name "$1"
  '';

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/${pname}
    cp ${x11-rename-zen} $out/bin/x11-rename-zen
  '';
}
