extra:
{ config, lib, pkgs, ... }:
let jb55pkgs = import <jb55pkgs> { inherit pkgs; };
    kindle-send = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "jb55";
      repo = "kindle-send";
      rev = "0.2.1";
      sha256 = "0xd86s2smjvlc7rlb6rkgx2hj3c3sbcz3gs8rf93x69jqdvwb6rr";
    }) {};
    nixify = pkgs.nur.repos.kampka.nixify;
    myPackages = with jb55pkgs; [
       bcalc
       csv-delim
       csv-scripts
       dbopen
       extname
       kindle-send
       mandown
       samp
       sharefile
       snap
       btcs
       cmdtree
       zoom-link-opener
       zebra
       viscal
       datefmt
    ];
    myHaskellPackages = with pkgs.haskellPackages; [
      #skeletons
    ];

    minimal-pkgs = with pkgs; [
      git-tools
      neovim
      fzf
      ripgrep
    ];

    mypkgs = with pkgs; myHaskellPackages ++ myPackages ++ [
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      awscli
      bat
      bc
      binutils
      dateutils
      direnv
      du-dust
      file
      fzf
      git-tools
      gnupg
      gnumake
      groff
      haskellPackages.una
      htop
      imagemagick
      jq
      lesspipe
      libbitcoin-explorer
      libqalculate
      linuxPackages.bpftrace
      linuxPackages.perf
      lsof
      manpages
      mdcat
      minisign
      neovim
      network-tools
      nixify
      nodejs
      opentimestamps-client
      par
      parallel
      patchelf
      pv
      python
      ranger
      ripgrep
      rsync
      screen
      shellcheck
      unixtools.xxd
      unzip
      universal-ctags
      weechat
      wget
      zip
      zstd
    ];
in {
  environment.systemPackages = if extra.is-minimal then minimal-pkgs else mypkgs;
}
