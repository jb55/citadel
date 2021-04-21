extra:
{ config, lib, pkgs, ... }:

let
  nix-bitcoin = import (pkgs.fetchFromGitHub {
    owner  = "fort-nix";
    repo   = "nix-bitcoin";
    rev    = "v0.0.44";
    sha256 = "08qn597r3xnqg9s7bnkssf4xcxvm0lf6xmisr86nkp2gammazc42";
  }) { inherit pkgs; };

  plugins = ["summary" "rebalance"];

  mkPluginCfg = name:
    "plugin=${builtins.getAttr name (nix-bitcoin.clightning-plugins)}/${name}.py";

  bitcoinDataDir = "/zbig/bitcoin";

  base-bitcoin-conf = extra.private.bitcoin;

  bcli = "${pkgs.bitcoind}/bin/bitcoin-cli --datadir=${bitcoinDataDir} --conf=${base-bitcoin-conf-file} --rpcuser=${extra.private.btc-user} --rpcpassword=${extra.private.btc-pass}";

  bitcoin-conf = ''
    ${base-bitcoin-conf}
    walletnotify=${walletemail} %s %w
  '';

  base-bitcoin-conf-file = pkgs.writeText "bitcoin-base.conf" base-bitcoin-conf;
  bitcoin-conf-file = pkgs.writeText "bitcoin.conf" bitcoin-conf;

  dca = import ./dca.nix {
    inherit pkgs bcli;
    to = "jb55 ${extra.private.btc-supplier}";
    addr = extra.private.btc-supplier-addr;
  };
  walletemail = import ./walletemail.nix { inherit pkgs bcli; };
in
{
  services.bitcoind = {
    mainnet = {
      enable = if extra.is-minimal then false else true;
      dataDir = bitcoinDataDir;
      configFile = bitcoin-conf-file;
      user = "jb55";
      group = "users";
    };
  };

  services.clightning.networks = {
    mainnet = {
      dataDir = "/home/jb55/.lightning-bitcoin";

      config = ''
        bitcoin-rpcuser=rpcuser
        bitcoin-rpcpassword=rpcpass
        bitcoin-rpcconnect=127.0.0.1
        bitcoin-rpcport=8332
        fee-per-satoshi=900
        bind-addr=0.0.0.0:9735
        announce-addr=24.84.152.187:9735
        network=bitcoin
        alias=jb55.com
        rgb=ff0000
        proxy=127.0.0.1:9050
        experimental-offers
        ${lib.concatStringsSep "\n" (map mkPluginCfg plugins)}
      '';
    };
  };
}
