spark-wallet:
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.spark-wallet;

  startScript = ''
    exec ${spark-wallet}/bin/spark-wallet \
      --ln-path "/home/jb55/.lightning/bitcoin"  \
      --host ${cfg.address} --port ${toString cfg.port} \
      --public-url "http://wallet.jb55.com" \
      --pairing-qr --print-key ${cfg.extraArgs}
  '';
in {
  options.services.spark-wallet = {
    enable = mkEnableOption "spark-wallet";
    address = mkOption {
      type = types.str;
      default = "localhost";
      description = "http(s) server address.";
    };
    port = mkOption {
      type = types.port;
      default = 9737;
      description = "http(s) server port.";
    };
    publicUrl = mkOption {
      type = types.str;
      default = "localhost";
      description = "public url";
    };
    extraArgs = mkOption {
      type = types.separatedString " ";
      default = "";
      description = "Extra command line arguments passed to spark-wallet.";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.spark-wallet = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "clightning-mainnet.service" ];
      after = [ "clightning-mainnet.service" ];
      script = startScript;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };
}
