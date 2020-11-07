{ pkgs ? import <nixpkgs> {} }:
let callPackage = pkgs.callPackage;
    callHsPackage = pkgs.haskellPackages.callPackage;
    fetch = rest: args: callPackage (pkgs.fetchFromGitHub ({
      owner = "jb55";
    } // rest)) args;
in rec {
  curlc       = callPackage ./pkgs/curlc {};
  csv-delim   = callPackage ./pkgs/csv-delim { };
  csv-scripts = callPackage ./pkgs/csv-scripts { inherit csv-delim; };
  dbopen      = callPackage ./pkgs/dbopen { };
  extname     = callPackage ./pkgs/extname { };
  mandown     = callPackage ./pkgs/mandown { };
  sharefile   = callPackage ./pkgs/sharefile { };
  samp        = callPackage ./pkgs/samp { };
  ratio       = callPackage ./pkgs/ratio { };

  cmdtree = fetch {
    repo = "cmdtree";
    rev  = "854d8d624fa55f1d86acddcfc81b30214a5fc727"; # use my config
    sha256 = "06a9zgnysv1bdfng2mzk02ifxs7q5i8gh04z950v48xnm26da1pa";
  } {};

  zoom-link-opener = fetch {
    repo = "zoom-link-opener";
    rev  = "0.1.1";
    sha256 = "013q814i7wcbl2ba5jpqkz00kpa1jaly53np30i4x01cfdfzywi3";
  } {};

  zebra = fetch {
    repo = "zebra";
    rev  = "0.1";
    sha256 = "1l7rfjwnjc28zszbrzjqsgyp47hkl355is8zshfgv3wacb7n6424";
  } {};

  viscal = fetch {
    repo = "viscal";
    rev  = "0.0.1";
    sha256 = "0kisxf6m1xvll8xj54rl3lr07aq3l0gizix5axp9hkawss0b55sa";
  } {};

  datefmt = fetch {
    repo = "datefmt";
    rev  = "0.1.1";
    sha256 = "1xjfr1lbkiy277firlb8zkg1pmj7pmiijhxx1z4bg41970dr446x";
  } {};

  btcs = fetch {
    repo = "btcs";
    rev  = "0.1";
    sha256 = "1ls4wr7ii6icr43z3n49pm1z11sdxv06g799ww8pvxv1ax7aysl6";
  } {};

  snap = fetch {
    repo = "sharefile-snap";
    rev  = "1.3";
    sha256 = "0j8j2588z09v7zz1f9d11zw2n0wq70sxy9lvwrw4l5yz75n3cral";
  } {};

  bcalc = fetch {
    repo   = "bcalc";
    rev    = "5a51083ec33883d3fec3c74cb0891b317f4d1f35";
    sha256 = "1mdkpd8rc5y4a4j0mwv7mkfd58a43mpxkxhrjlkkmcf2nngvqi0j";
  } {};
}