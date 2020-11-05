{ callPackage, fetchFromGitHub }:
callPackage (fetchFromGitHub {
  owner = "jb55";
  repo = "curlc";
  rev = "c8251c0c712fcb373ab4d7b9c990d2f815f48ede";
  sha256 = "18mxxpxdnlcmingn8qi4ynnn7f19ismhxh5ns208pfgxj742rv5w";
}) {}
