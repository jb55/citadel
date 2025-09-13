extra:
{ config, lib, pkgs, ... }:

let
  jb55pkgs = import <jb55pkgs> { inherit pkgs; };

  asmap = (import (pkgs.fetchFromGitHub {
    owner  = "0xb10c";
    repo   = "nix";
    rev    = "507d0998263fee03bd4a0a00f2de5649629daac3";
    sha256 = "sha256-Pxm9iCFD1gfC/gJ2XSwPSjnFxbCo6gZNdTmohjOrQ0o=";
  }) { inherit pkgs; }).asmap-data;

  nostril = jb55pkgs.nostril;

  nix-bitcoin = import (pkgs.fetchFromGitHub {
    owner  = "fort-nix";
    repo   = "nix-bitcoin";
    rev    = "v0.0.89";
    sha256 = "sha256-SMJW+QZt3iRuoezjE12sopBsdLHDihXe/RerLfRpqoI=";
  }) { inherit pkgs; };

  plugins = ["summary"];

  mkPluginCfg = name:
    "plugin=${builtins.getAttr name (nix-bitcoin.clightning-plugins)}/${name}.py";

  bitcoinDataDir = "/titan/bitcoin";

  base-bitcoin-conf = extra.private.bitcoin;

  bcli = "${pkgs.bitcoind}/bin/bitcoin-cli --datadir=${bitcoinDataDir} --conf=${base-bitcoin-conf-file} --rpcuser=${extra.private.btc-user} --rpcpassword=${extra.private.btc-pass}";

  bitcoin-conf = ''
    ${base-bitcoin-conf}
    walletnotify=${walletemail} %s %w
    asmap=${asmap}
  '';

  base-bitcoin-conf-file = pkgs.writeText "bitcoin-base.conf" base-bitcoin-conf;
  bitcoin-conf-file = pkgs.writeText "bitcoin.conf" bitcoin-conf;

  dca = import ./dca.nix {
    inherit pkgs bcli;
    to = "jb55 ${extra.private.btc-supplier}";
    addr = extra.private.btc-supplier-addr;
  };

  walletemail = import ./walletemail.nix {
    inherit pkgs bcli nostril;
    inherit (extra) private;
  };

  spark-module = import ./modules/spark-wallet.nix nix-bitcoin.spark-wallet;
  spark-port = 9962;
in
{
  imports = [ spark-module ];

  services.spark-wallet.enable = false;
  services.spark-wallet.address = extra.machine.ztip;
  services.spark-wallet.port = spark-port;
  services.spark-wallet.publicUrl = "http://wallet.jb55.com";

  services.nginx.httpConfig = ''
    server {
      listen 80;
      listen 10.100.0.1:80;
      listen 192.168.87.26:80;

      server_name wallet.jb55.com;

      location /core/ {
        alias /var/www/lnlink-core/;
      }

      location /cln/ {
        alias /var/www/btcmerchant/;
      }

      location / {
        proxy_pass  http://127.0.0.1:9962;

        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
        proxy_buffering off;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      }
    }

  '';

  services.bitcoind = {
    mainnet = {
      enable = if extra.is-minimal then false else true;
      dataDir = bitcoinDataDir;
      configFile = bitcoin-conf-file;
      user = "jb55";
      group = "users";
    };
  };

  #services.clightning.networks = {
  #  mainnet = {
  #    dataDir = "/home/jb55/.lightning-bitcoin";

  #    config = ''
  #      bitcoin-rpcuser=rpcuser
  #      bitcoin-rpcpassword=rpcpass
  #      bitcoin-rpcconnect=127.0.0.1
  #      bitcoin-rpcport=8332
  #      fee-per-satoshi=900
  #      bind-addr=0.0.0.0:9735
  #      announce-addr=24.84.152.187:9735
  #      network=bitcoin
  #      alias=jb55.com
  #      rgb=ff0000
  #      proxy=127.0.0.1:9050
  #      experimental-offers
  #      ${lib.concatStringsSep "\n" (map mkPluginCfg plugins)}
  #    '';
  #  };
  #};
}
