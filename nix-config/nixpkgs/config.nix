{ pkgs }:
let #monstercatPkgs = import <monstercatpkgs> { inherit pkgs; };
    #haskellOverrides = import ./haskell-overrides { inherit monstercatPkgs; };
    jb55pkgs = import <jb55pkgs> { inherit pkgs; };
    callPackage = pkgs.callPackage;
    doJailbreak = pkgs.haskell.lib.doJailbreak;
    dontCheck = pkgs.haskell.lib.dontCheck;
    regularFiles = builtins.filterSource (f: type: type == "symlink"
                                                || type == "directory"
                                                || type == "regular");
in {
  allowUnfree = true;
  allowUnfreeRedistributable = true;
  allowBroken = false;
  checkMeta = true;
  zathura.useMupdf = true;
  android_sdk.accept_license = true;

  packageOverrides = super: rec {
    qemu = super.qemu.override {
      smbdSupport = true;
    };

    mpv = pkgs.wrapMpv pkgs.mpv-unwrapped {
      scripts = [ pkgs.mpvScripts.mpris ];
    };

    # /run/current-system/sw/bin/ls $HOME/.emacs.d/elpa | sed 's/-[[:digit:]].*//g;s/\+$/-plus/g' | sort -u
    #emacs = super.emacsHead;
    nur = import (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/cff4dfbe6d6f4ab14560234fcf2d73332ee3ecc1.tar.gz";
      sha256 = "01yxz6w820vryirrwkmsnxkmvp35dncjp1n8fdfsq4n0r28nw31a";
    }) {
      inherit pkgs;
    };

    msmtp = pkgs.lib.overrideDerivation super.msmtp (attrs: {
      patches = [
        (super.fetchurl {
          url = "https://jb55.com/s/msmtpq-custom-conn-test.patch";
          sha256 = "4d342ea9e757fe5f3fd939479c4b619dcc9630ba9d0bdacf5ccfec9b5b67b861";
        })
      ];
    });

    neomutt = pkgs.lib.overrideDerivation super.neomutt (attrs: {
      postConfigure = ''
        sed -i '/HAVE_CURS_SET 1/d' config.h
      '';
    });

    #weechat = super.weechat.override {configure = {availablePlugins, ...}: {
    #    scripts = with super.weechatScripts; [ wee-slack weechat-matrix ];
    #  };
    #};

    #dunst = pkgs.lib.overrideDerivation super.dunst (attrs: {
    #  src = pkgs.fetchFromGitHub {
    #    owner = "jb55";
    #    repo  = "dunst";
    #    rev   = "138edff170e4e4a2bf6891bd634c4ec215d4b7ef";
    #    sha256 = "1pf3v4mrcd0cfhvm9fk9nwvgj5dy6qlbs0mhlcyx26cbqxd62brp";
    #  };
    #});

    #lastpass-cli = super.lastpass-cli.override { guiSupport = true; };

    wine = super.wineWowPackages.staging;

    #phonectl = super.python3Packages.callPackage (import (super.fetchFromGitHub {
    #  owner  = "jb55";
    #  repo   = "phonectl";
    #  sha256 = "0wqpwg32qa1rzpw7881r6q2zklxlq1y4qgyyy742pihfh99rkcmj";
    #  rev    = "de0f37a20d16a32a73f9267860302357b2df0c20";
    #})) {};

    #htop = pkgs.lib.overrideDerivation super.htop (attrs: {
    #  patches =
    #    [ (super.fetchurl
    #      { url = "https://jb55.com/s/htop-vim.patch";
    #        sha256 = "3d72aa07d28d7988e91e8e4bc68d66804a4faeb40b93c7a695c97f7d04a55195";
    #      })
    #      (super.fetchurl
    #      { url = "https://jb55.com/s/0001-Improving-Command-display-sort.patch";
    #        sha256 = "2207dccce7f9de0c3c6f56d846d7e547c96f63c8a4659ef46ef90c3bd9a013d1";
    #      })
    #    ];
    #});

    ds4ctl = super.callPackage ./scripts/ds4ctl { };

    haskellEnvHoogle = haskellEnvFun {
      name = "haskellEnvHoogle";
      #compiler = "ghc821";
      withHoogle = true;
    };

    haskellEnv = haskellEnvFun {
      name = "haskellEnv";
      #compiler = "ghc821";
      withHoogle = false;
    };

    haskell-tools = super.buildEnv {
      name = "haskell-tools";
      paths = haskellTools super.haskellPackages;
    };

    jb55-tools-env = pkgs.buildEnv {
      name = "jb55-tools";
      paths = with jb55pkgs; [
        csv-delim
        csv-scripts
        dbopen
        extname
        mandown
        snap
        sharefile
        samp
      ];
    };

    jvm-tools-env = pkgs.buildEnv {
      name = "jvm-tools";
      paths = with pkgs; [
        gradle
        maven
        oraclejdk
      ];
    };

    gaming-env = pkgs.buildEnv {
      name = "gaming";
      paths = with pkgs; [
        steam
      ];
    };

    file-tools = pkgs.buildEnv {
      name = "file-tools";
      paths = with pkgs; [
        ripgrep
        ranger
      ];
    };

    network-tools = pkgs.buildEnv {
      name = "network-tools";
      paths = with pkgs; with xorg; [
        nmap
        dnsutils
        whois
        nethogs
      ];
    };

    system-tools = pkgs.buildEnv {
      name = "system-tools";
      paths = with pkgs; with xorg; [
        xbacklight
        acpi
        psmisc
      ];
    };

    desktop-tools = pkgs.buildEnv {
      name = "desktop-tools";
      paths = with pkgs; with xorg; [
        twmn
        libnotify
      ];
    };

    syntax-tools = pkgs.buildEnv {
      name = "syntax-tools";
      paths = with pkgs; [
        shellcheck
      ];
    };

    mail-tools = pkgs.buildEnv {
      name = "mail-tools";
      paths = with pkgs; [
        notmuch
        msmtp
        muchsync
        isync
      ];
    };

    photo-env = pkgs.buildEnv {
      name = "photo-tools";
      paths = with pkgs; [
        gimp
        darktable
        rawtherapee
        ufraw
        dcraw
      ];
    };

    git-tools = pkgs.buildEnv {
      name = "git-tools";
      paths = with pkgs; [
        diffstat
        diffutils
        gist
        git-series
        gitAndTools.git-extras
        gitAndTools.git-absorb
        gitAndTools.delta
        gitAndTools.gitFull
        github-release
        patch
        patchutils
      ];
    };

    haskellEnvFun = { withHoogle ? false, compiler ? null, name }:
      let hp = if compiler != null
                 then super.haskell.packages.${compiler}
                 else super.haskellPackages;

          ghcWith = if withHoogle
                      then hp.ghcWithHoogle
                      else hp.ghcWithPackages;

      in super.buildEnv {
        name = name;
        paths = [(ghcWith myHaskellPackages)];
      };

    haskellTools = hp: with hp; [
      alex
      cabal-install
      cabal2nix
      #stack2nix
      hpack
      ghc-core
      happy
      (dontCheck hasktags)
      hindent
      hlint
      structured-haskell-mode
      haskell-ci
    ];

    myHaskellPackages = hp: with hp; [
      Boolean
      Decimal
      HTTP
      HUnit
      MissingH
      QuickCheck
      SafeSemaphore
      aeson
      aeson-qq
      async
      attoparsec
      base32string
      base58-bytestring
      bifunctors
      unliftio
      blaze-builder
      blaze-builder-conduit
      blaze-html
      blaze-markup
      cased
      cassava
      cereal
      colour
      comonad
      comonad-transformers
      directory
      dlist
      dlist-instances
      doctest
      either
      elm-export
      elm-export-persistent
      exceptions
      filepath
      fingertree
      foldl
      formatting
      free
      generics-sop
      hamlet
      hashable
      hashids
      here
      heroku
      hedgehog
      hspec
      hspec-expectations
      html
      http-client
      http-date
      http-types
      inline-c
      io-memoize
      io-storage
      keys
      language-c
      language-javascript
      lens
      lens-action
      lens-aeson
      lens-datetime
      lens-family
      lens-family-core
      lifted-async
      lifted-base
      linear
      list-extras
      logict
      mbox
      mime-mail
      mime-types
      mmorph
      monad-control
      monad-coroutine
      monad-loops
      monad-par
      monad-par-extras
      monad-stm
      monadloc
      neat-interpolation
      network
      newtype
      numbers
      options
      optparse-applicative
      optparse-generic
      pandoc
      parsec
      megaparsec
      parsers
      pcg-random
      persistent
      persistent-postgresql
      persistent-template
      posix-paths
      postgresql-simple
      pretty-show
      probability
      profunctors
      pwstore-fast
      quickcheck-instances
      random
      reducers
      reflection
      regex-applicative
      regex-base
      regex-compat
      regex-posix
      relational-record
      resourcet
      retry
      rex
      s3-signer
      safe
      scotty
      sqlite-simple
      lucid
      semigroupoids
      semigroups
      shake
      shakespeare
      shqq
      simple-reflect
      split
      spoon
      stache
      stm
      stm-chans
      store
      stache
      streaming
      smtp-mail
      streaming-bytestring
      streaming-wai
      strict
      stringsearch
      strptime
      syb
      system-fileio
      system-filepath
      tagged
      taggy
      taggy-lens
      tar
      tardis
      tasty
      tasty-hspec
      tasty-hunit
      tasty-quickcheck
      tasty-smallcheck
      temporary
      test-framework
      test-framework-hunit
      text
      text-regex-replace
      thyme
      time
      time-units
      transformers
      transformers-base
      turtle
      unagi-chan
      uniplate
      unix-compat
      unordered-containers
      uuid
      vector
      void
      wai
      wai-middleware-static
      wai-extra
      warp
      wreq
      xhtml
      xml-lens
      yaml
      zippers
      zlib
    ];
  };
}
