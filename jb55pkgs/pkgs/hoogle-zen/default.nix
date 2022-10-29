{ pkgs        ? import <nixpkgs> {},
  stdenv      ? pkgs.stdenv,
  bash        ? pkgs.bash,
  zenity      ? pkgs.gnome.zenity,
  writeScript ? pkgs.writeScript
}:
stdenv.mkDerivation rec {
  pname = "hoogle-zen";
  version = "0.1";

  src = writeScript pname ''
    #!${bash}/bin/bash
    q="$(${zenity}/bin/zenity --entry --text=query:)"
    /home/jb55/bin/open "http://localhost:8088/?hoogle=$q"
  '';

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/${pname}
  '';
}

