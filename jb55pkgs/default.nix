{ pkgs ? import <nixpkgs> {} }:
let callPackage = pkgs.callPackage;
    callHsPackage = pkgs.haskellPackages.callPackage;
    fetch = args: callPackage (pkgs.fetchFromGitHub ({
      owner = "jb55";
    } // args)) {};

    fetch-jb55 = args: callPackage (pkgs.fetchgit ({
      url = "git://jb55.com/${args.repo}";
      inherit (args) sha256 rev;
    })) {};

    fetch-srht = args: callPackage (pkgs.fetchgit ({
      url = "https://git.sr.ht/~jb55/${args.repo}";
      inherit (args) sha256 rev;
    })) {};
in rec {
  curlc       = callPackage ./pkgs/curlc {};
  csv-delim   = callPackage ./pkgs/csv-delim { };
  csv-scripts = callPackage ./pkgs/csv-scripts { inherit csv-delim; };
  dbopen      = callPackage ./pkgs/dbopen { };
  extname     = callPackage ./pkgs/extname { };
  mandown     = callPackage ./pkgs/mandown { };
  sharefile   = callPackage ./pkgs/sharefile { };
  samp        = callPackage ./pkgs/samp { };

  define = callPackage ./pkgs/define { };
  rsslink = callPackage ./pkgs/rsslink { };
  x11-rename = callPackage ./pkgs/x11-rename { };
  hoogle-zen = callPackage ./pkgs/hoogle-zen { };

  ratio = fetch-jb55 {
    repo = "ratio";
    rev  = "4ae6e67712946aba70df992cdeafcc03301c6c76";
    sha256 = "10qx30s0c6gcinfgdlb3c8rxkv4j25m29jsl923k44bbh3jpdnak";
  };

  git-email-contacts = fetch-jb55 {
    repo = "git-email-contacts";
    rev  = "7301d727cf09157497cbe72b9174a63b98b9e287";
    sha256 = "1y36k3cl94k10s7q6rfx4lni81d30w2kv8n14idjhbbr9ck4jv06";
  };

  cmdtree = fetch-jb55 {
    repo = "cmdtree";
    rev  = "9ff1b9d375385210ea2221b4b0e55408453dbd0b"; # use my config
    sha256 = "0wnp2wis28iplln9h7yips835bhmcchmp373pvw0say35hn3rd36";
  };

  imap-notify = fetch-jb55 {
    repo = "imap-notify";
    rev  = "11d8f9b544531a27cbe0fc49ab5c1d4b26d3fba4";
    sha256 = "1nnc50plrg9m1dbw8a1hla0d1f86s0bmpy8majq8vicdhf6qxbja";
  };

  nixpkgs-ml-tools = fetch-jb55 {
    repo = "nixpkgs-ml-tools";
    rev  = "3d62d22c3c33d885d62418344acba029fe41f541"; # use my config
    sha256 = "03ql84sf3rc4ixnmn88hxjgs1cgilzf41aw31iwzfg3sk1pqxdkv";
  };

  zoom-link-opener = fetch {
    repo = "zoom-link-opener";
    rev  = "0.1.1";
    sha256 = "013q814i7wcbl2ba5jpqkz00kpa1jaly53np30i4x01cfdfzywi3";
  };

  zebra = fetch {
    repo = "zebra";
    rev  = "0.1";
    sha256 = "1l7rfjwnjc28zszbrzjqsgyp47hkl355is8zshfgv3wacb7n6424";
  };

  viscal = fetch-jb55 {
    repo = "viscal";
    rev  = "4b87413babb4296d94ac8535f1160f7a0d507c4e";
    sha256 = "0lamxx6xh5b8f38sqyn2ghqplvvaaxwkmvd6gb3vwqyw2qr3vwga";
  };

  datefmt = fetch {
    repo = "datefmt";
    rev  = "fd48a2fa528d0c2a7ae6e53c350fedd3a6ef4e75";
    sha256 = "008kzm899w66r4jai5nnzyvn404iy1381yjb67df4wln8wzy0pqk";
  };

  btcs = fetch {
    repo = "btcs";
    rev  = "bbc7b0d96b5b1dc3114ea56b365ee4586cd86d3b";
    sha256 = "05mfs6d4r1b9mnzgn74wgjvj04rrmc93hgqqzf53xbrlb0a5s4wg";
  };

  snap = fetch {
    repo = "sharefile-snap";
    rev  = "1.3";
    sha256 = "0j8j2588z09v7zz1f9d11zw2n0wq70sxy9lvwrw4l5yz75n3cral";
  };

  bcalc = fetch-jb55 {
    repo   = "bcalc";
    rev    = "b96c9f5379841c5049dc1b0aca05750f5f0dcdb8";
    sha256 = "1lq7jqlyk4crd6f2z1ms0vqy6mq58q819nwn68adjdv309l4dqvf";
  };
}
