{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  name = "csv-delim-${version}";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jb55";
    repo = "csv-delim";
    rev = "fe87ed0a81576fd31610a29437d66518625b04b7";
    sha256 = "1pmdbp3lprcy9xf55h8mgy5pwh7ryf9fc2gnjiqjs5mn8acmri5q";
  };

  makeFlags = "PREFIX=$(out)";
}
