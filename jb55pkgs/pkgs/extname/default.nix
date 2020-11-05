{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "extname-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    rev = version;
    owner = "jb55";
    repo = "extname";
    sha256 = "10l0p6q1qlx8ihmpycf6p26kx2rcb1l7rp92smv05gmxb7fznw1q";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Utility to get file extensions from its arguments";
    homepage = "https://github.com/jb55/extname";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
  };
}
