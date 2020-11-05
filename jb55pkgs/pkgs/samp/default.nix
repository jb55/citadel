{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  name = "samp-${version}";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "jb55";
    repo = "samp";
    rev = version;
    sha256 = "1xdbjmz611f5x9slcavb27axivww8l6r0p06vf9i9i9sikwsc5p5";
  };

  makeFlags = "PREFIX=$(out)";
}
