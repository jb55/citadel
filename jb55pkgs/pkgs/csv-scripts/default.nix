{ stdenv
, fetchFromGitHub
, csv-delim
, bc
}:
stdenv.mkDerivation rec {
  name = "csv-scripts-${version}";
  version = "0.2.6";

  buildInputs = [ csv-delim bc ];

  src = fetchFromGitHub {
    owner = "jb55";
    repo = "csv-scripts";
    rev = version;
    sha256 = "1w5jf0w376kmaqpy59lw32z1lawh5ak7b0lf79bbslg8ccwb8y7r";
  };

  patchPhase = ''
    for file in "bin/"*; do
      sed -i 's,csv-delim,${csv-delim}/bin/csv-delim,g' "$file"
    done;
    sed -i 's,bc,${bc}/bin/bc,' bin/csv-sum
  '';

  makeFlags = "PREFIX=$(out)";
}
