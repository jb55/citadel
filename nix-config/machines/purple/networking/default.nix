{ config, lib, pkgs, ... }:
let
  openTCP = dev: port: ''
    ip46tables -A nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept
  '';
  ports = {
    test_http = 3000;
  };
in
{
  services.openssh.gatewayPorts = "yes";

  networking.enableIPv6 = false;
  networking.firewall.allowedTCPPorts = with ports; [ 22 443 80 test_http ];

  networking.domain = "damus.io";
  networking.search = [ "damus.io" ];
  networking.extraHosts = ''
    127.0.0.1 damus.io
    ::1 damus.io
  '';
}
