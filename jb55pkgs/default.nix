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

  ratio = fetch-srht {
    repo = "ratio";
    rev  = "4eb820fb362c554baa73e244dae29aa62ec2d9d5";
    sha256 = "17mmmqvn0xfh1vk85bip87cqc3mb9vqgs07p19zrprm4yasyims2";
  };

  cmdtree = fetch-jb55 {
    repo = "cmdtree";
    rev  = "9ff1b9d375385210ea2221b4b0e55408453dbd0b"; # use my config
    sha256 = "0wnp2wis28iplln9h7yips835bhmcchmp373pvw0say35hn3rd36";
  };

  imap-notify = fetch-jb55 {
    repo = "imap-notify";
    rev  = "0.1.1"; # use my config
    sha256 = "0q3cxwgx7w91k77sb9iilfbvnn4fka9d47k02jrwhf3g6jk1jij1";
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
    rev  = "67a176de6db75fddecd0239dd6afe2659b1b1b46";
    sha256 = "08as7m9fnsidryx9bm6bwp1hq43g59icv97x58zfrgpk68y8v785";
  };

  btcs = fetch {
    repo = "btcs";
    rev  = "0.1";
    sha256 = "1ls4wr7ii6icr43z3n49pm1z11sdxv06g799ww8pvxv1ax7aysl6";
  };

  snap = fetch {
    repo = "sharefile-snap";
    rev  = "1.3";
    sha256 = "0j8j2588z09v7zz1f9d11zw2n0wq70sxy9lvwrw4l5yz75n3cral";
  };

  bcalc = fetch {
    repo   = "bcalc";
    rev    = "5a51083ec33883d3fec3c74cb0891b317f4d1f35";
    sha256 = "1mdkpd8rc5y4a4j0mwv7mkfd58a43mpxkxhrjlkkmcf2nngvqi0j";
  };
}
