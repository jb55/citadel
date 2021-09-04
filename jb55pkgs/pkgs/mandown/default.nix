{ stdenv
, makeWrapper
, lib
, pandoc
, fetchFromGitHub
, man
}:
stdenv.mkDerivation rec {
  name = "mandown-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    rev = "5a26782ad935e4316f1d99e185d385750c5bc5cb";
    owner = "jb55";
    repo = "mandown";
    sha256 = "0mb06gbbi3ah026sffh3jcjny7b6g4acx2bp4b4kdjp4kq0ihy66";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ pandoc man makeWrapper ];

  meta = with lib; {
    description = "Render markdown as a manpage";
    homepage = "https://github.com/jb55/mandown";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.gpl2;
  };

  installPhase = ''
    wrapProgram "$out/bin/mandown" \
      --prefix PATH : "${man}/bin:${pandoc}/bin"
  '';
}
