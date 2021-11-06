extra:
{ config, lib, pkgs, ... }:
let jb55pkgs = import <jb55pkgs> { inherit pkgs; };
    kindle-send = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "jb55";
      repo = "kindle-send";
      rev = "0.2.1";
      sha256 = "0xd86s2smjvlc7rlb6rkgx2hj3c3sbcz3gs8rf93x69jqdvwb6rr";
    }) {};
    myPackages = with jb55pkgs; [
       rsslink
       bcalc
       btcs
       csv-delim
       csv-scripts
       datefmt
       extname
       mandown
       ratio
       samp
       sharefile
       zebra
       define
       #nixpkgs-ml-tools
    ];
    myHaskellPackages = with pkgs.haskellPackages; [
      #skeletons
    ];

    minimal-pkgs = with pkgs; [
      git-tools
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
      cp437
      dateutils
      direnv
      du-dust
      file
      fzf
      git-tools
      gnumake
      gnupg
      groff
      hashcash
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
      mailutils
      manpages
      mdcat
      minisign
      neovim
      nethack
      network-tools
      nix-direnv 
      nodejs
      opentimestamps-client
      par
      parallel
      patchelf
      pv
      python3
      ripgrep
      rsync
      scdoc
      screen
      shellcheck
      universal-ctags
      unixtools.xxd
      unzip
      weechat
      wget
      xonsh
      zip
      zstd
    ];
in {
  environment.systemPackages = if extra.is-minimal then minimal-pkgs else mypkgs;

    nix.extraOptions = ''
	keep-outputs = true
	keep-derivations = true
    '';

    environment.pathsToLink = [
        "/share/nix-direnv"
    ];

}
