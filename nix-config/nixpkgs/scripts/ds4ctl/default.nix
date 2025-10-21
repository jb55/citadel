{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ds4ctl-${version}";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "jb55";
    repo = "ds4ctl";
    rev = version;
    sha256 = "sha256-//VRzo9d2DNgp+CzVohkHILXdCXfn1NuEvjR8gcFnRQ=";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ ];

  meta = with lib; {
    description = "ds4ctl";
    homepage = "https://github.com/jb55/ds4ctl";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
  };
}
