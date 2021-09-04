{ stdenv
, perlPackages
, makeWrapper
, perl
, rsync
, lib
, coreutils
, openssh
, fetchFromGitHub
}:
let
  inputs = [ perl perlPackages.URI rsync openssh coreutils ];
  buildPaths = sep: fmt: "${lib.concatStringsSep sep (map fmt inputs)}";
in stdenv.mkDerivation rec {
  name = "sharefile-${version}";
  version = "1.2";
  buildInputs = [ makeWrapper ] ++ inputs;

  src = fetchFromGitHub {
    rev = version;
    owner = "jb55";
    repo = "sharefile";
    sha256 = "0cvw2hakxsjmpn5frfxp38jpc94knq0lfrzqhpv1xah6l83cb4vy";
  };

  installPhase = ''
    mkdir -p $out/bin

    cp sharefile $out/bin
    cp share_last_ss $out/bin
    cp hashname $out/bin
    cp hashshare $out/bin

    for prog in $(echo "$out/bin/"*)
    do
      wrapProgram "$prog" \
        --prefix PERL5LIB : "$PERL5LIB" \
        --prefix PATH : "${buildPaths ":" (f: "${f}/bin")}"
    done
  '';
}
