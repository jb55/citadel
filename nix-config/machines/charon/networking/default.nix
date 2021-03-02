{ config, lib, pkgs, ... }:
let
  openTCP = dev: port: ''
    ip46tables -A nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept
  '';
  ports = {
    git = 9418;
    gemini = 1965;
  };
in
{
  services.openssh.gatewayPorts = "yes";

  networking.firewall.allowedTCPPorts = with ports; [ 22 443 80 70 12566 12788 5222 5269 3415 git gemini ];

  networking.domain = "jb55.com";
  networking.search = [ "jb55.com" ];
  networking.extraHosts = ''
    127.0.0.1 jb55.com
    ::1 jb55.com
  '';
}
