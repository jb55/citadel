extra:
{ config, lib, pkgs, ... }:
let
  chromecastIPs = [ "192.168.87.190" ];
  iptables = "iptables -A nixos-fw";
  openChromecast = ip: ''
    ${iptables} -p udp -s ${ip} -j nixos-fw-accept
    ${iptables} -p tcp -s ${ip} -j nixos-fw-accept
  '';
  ipr = "${pkgs.iproute}/bin/ip";
  writeBash = extra.util.writeBash;
  openTCP = dev: port: ''
    ip46tables -A nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept
  '';

  ports = {
    synergy = 24800;
    wireguard = 51820;
    nncp = 5442;
    webdev = 8080;
  };

  firewallRules = [
    "nixos-fw -s 192.168.87.1/24 -p tcp --dport ${toString ports.webdev} -j nixos-fw-accept"
    "nixos-fw -s 10.100.0.1/24 -p tcp --dport ${toString ports.synergy} -j nixos-fw-accept"
    "nixos-fw -s 172.24.0.1/24 -p tcp --dport 9050 -j nixos-fw-accept"
  ];

  addRule = rule: "iptables -A ${rule}";
  rmRule = rule: "iptables -D ${rule} || true";
  extraCommands = lib.concatStringsSep "\n" (map addRule firewallRules);
  extraStopCommands = lib.concatStringsSep "\n" (map rmRule firewallRules);
in
{
  networking.extraHosts = ''
    10.0.9.1         secure.datavalet.io.
    172.24.242.111   securitycam.home.
    24.244.54.234    wifisignon.shaw.ca.
  '';

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wgtb = {
     # Determines the IP address and subnet of the server's end of the tunnel interface.
     ips = [ "10.101.0.2/32" ];

     privateKeyFile = "/home/jb55/.wg/agent/private";

     peers = [
       { publicKey = "6TVcGaxkc/vUNyND3GTLY3dXvrWNzCjw94llB6/kdyI="; # winvm
         allowedIPs = [ "10.101.0.13/32" ];
         endpoint = "65.7.8.70:51821";
       }
     ];
    };

    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.0.2/28" ];

      listenPort = 51820;

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/jb55/.wg/private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        { # monad
          publicKey = "TbGgpOqD6teLon0ksZKS8zvvjHtkOGKNWPpHZxhVFWA=";
          #allowedIPs = [ "0.0.0.0/0" "::/0" ];
          allowedIPs = [ "10.100.0.1/32" ];
          #endpoint = "127.0.0.1:3333";
          #endpoint = "24.84.152.187:51820";
          endpoint = "65.7.8.70:51820";

          persistentKeepalive = 25;
        }
        { # charon
          publicKey = "BklL4dTL8WK3xnmM899Hr50/UlXaLYhJQWllj2p4ZEg=";
          allowedIPs = [ "10.100.0.7/32" ];
          endpoint = "45.79.91.128:51820";
          persistentKeepalive = 25;
        }
        { # ??
          publicKey = "vIh3IQgP92OhHaC9XBiJVDLlrs3GVcR6hlXaapjTiA0=";

          allowedIPs = [ "10.100.0.3/32" ];

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
        {
          publicKey = "Dp8Df75X8Kh9gd33e+CWyyhOvT4mT0X9ToPwBUEBU1k="; # macos
          allowedIPs = [ "10.100.0.4/32" ];
          endpoint = "192.168.86.24:51820";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.wireless.userControlled.enable = false;

  networking.firewall.enable = true;

  networking.firewall.extraCommands = extraCommands;
  networking.firewall.extraStopCommands = extraStopCommands;
  networking.firewall.allowedTCPPorts = with ports; [ nncp ];
  networking.firewall.allowedUDPPorts = with ports; [ wireguard ];
}
