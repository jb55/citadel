{ stdenv
, python
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  name = "dbopen-${version}";
  version = "1.3";
  buildInputs = [ python ];

  src = fetchFromGitHub {
    rev = version;
    owner = "jb55";
    repo = "dbopen";
    sha256 = "0w613z08pzkw2216f2zniqrp1zcc8r9wis6f1bhd1xbzlh0q5mkj";
  };

  configurePhase = "mkdir -p $out/bin";
  makeFlags = "PREFIX=$(out)";
}
