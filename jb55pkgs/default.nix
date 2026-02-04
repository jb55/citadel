{ pkgs ? import <nixpkgs> {} }:
let callPackage = pkgs.callPackage;
    callHsPackage = pkgs.haskellPackages.callPackage;
    fetch = args: callPackage (pkgs.fetchFromGitHub ({
      owner = "jb55";
    } // args)) {};

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
  samp        = callPackage ./pkgs/samp { };

  define = callPackage ./pkgs/define { };
  rsslink = callPackage ./pkgs/rsslink { };
  x11-rename = callPackage ./pkgs/x11-rename { };
  hoogle-zen = callPackage ./pkgs/hoogle-zen { };

  sharefile = fetch  { 
    repo = "sharefile";
    rev  = "9a6b16f13d94833cd1801d5d7a926d5422054d74";
    sha256 = "sha256-zIZ+lyjvBI72AQMCjWw/pRE1gWR1BZeg5Y/2kqo61kY=";
  };

  ratio = fetch {
    repo = "ratio";
    rev  = "4ae6e67712946aba70df992cdeafcc03301c6c76";
    sha256 = "10qx30s0c6gcinfgdlb3c8rxkv4j25m29jsl923k44bbh3jpdnak";
  };

  nostril = fetch {
    repo = "nostril";
    rev = "251031f5a5d098d02c5e74556942d3dd706b5ce4";
    sha256 = "sha256-qLqRxdLDos3akNKbKQ0yIbIIovssK1Q40EzJ8hb6hag=";
  };

  git-email-contacts = fetch {
    repo = "git-email-contacts";
    rev  = "7301d727cf09157497cbe72b9174a63b98b9e287";
    sha256 = "1y36k3cl94k10s7q6rfx4lni81d30w2kv8n14idjhbbr9ck4jv06";
  };

  cmdtree = fetch {
    repo = "cmdtree";
    rev  = "9ff1b9d375385210ea2221b4b0e55408453dbd0b"; # use my config
    sha256 = "0wnp2wis28iplln9h7yips835bhmcchmp373pvw0say35hn3rd36";
  };

  imap-notify = fetch {
    repo = "imap-notify";
    rev  = "11d8f9b544531a27cbe0fc49ab5c1d4b26d3fba4";
    sha256 = "1nnc50plrg9m1dbw8a1hla0d1f86s0bmpy8majq8vicdhf6qxbja";
  };

  nixpkgs-ml-tools = fetch {
    repo = "nixpkgs-ml-tools";
    rev  = "3d62d22c3c33d885d62418344acba029fe41f541"; # use my config
    sha256 = "03ql84sf3rc4ixnmn88hxjgs1cgilzf41aw31iwzfg3sk1pqxdkv";
  };

  zoom-link-opener = fetch {
    repo = "zoom-link-opener";
    rev  = "0.1.2";
    sha256 = "sha256-sytjRdK+CVxnJU4EdVzZyK0c7TJJo+64kJfJTTrKwKM=";
  };

  zebra = fetch {
    repo = "zebra";
    rev  = "0.1";
    sha256 = "1l7rfjwnjc28zszbrzjqsgyp47hkl355is8zshfgv3wacb7n6424";
  };

  viscal = fetch {
    repo = "viscal";
    rev  = "b93b651522ca684e46603316df88b2c7241afecd";
    sha256 = "sha256-iOR3vztBqq+/7+tGDcRuU4HfsBuCLjPKKAflzAAsqOM=";
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
    rev  = "7eacc49f1df577a9faaa33a22664d93347ff362d";
    sha256 = "0x5531qyimpah48ijx2bad0mq1gjbpjacymwl3gm08lm0zl0xr09";
  };

  bcalc = fetch {
    repo   = "bcalc";
    rev    = "607c4d562178f4aecee008012e9e83871d2a4f5c";
    sha256 = "sha256-WD85Ypx0ZbSBj5+1OZcwPRz4V6dbPeK5foB/gn+romc=";
  };
}
