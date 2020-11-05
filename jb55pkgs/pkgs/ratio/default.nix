{ callPackage, fetchgit }:
callPackage (fetchgit {
  url = git://git.jb55.com/ratio;
  rev = "c6e99cf4336785ee4f3ef6b97a9562aa6944a2c8";
  sha256 = "12r80ad9r4l4vsmc6dczcjn93wp7awfs4y1r0yagvmwdqnk96lpv";
}) {}
