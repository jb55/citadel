{ config, lib, pkgs, ... }:
let
  openTCP = dev: port: ''
    ip46tables -A nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept
  '';
  ports = {
    git = 9418;
    gemini = 1965;
    wireguard = 51820;
  };
in
{
  services.openssh.gatewayPorts = "yes";

  networking.firewall.allowedTCPPorts = with ports; [ 22 443 80 70 12566 12788 5222 5269 3415 git gemini ];
  networking.firewall.allowedUDPPorts = with ports; [ wireguard ];

  networking.tempAddresses = "disabled";
  networking.enableIPv6 = true;

  networking.nat.enable = true;
  networking.nat.externalInterface = "enp0s3";
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.interfaces.enp0s3.ipv6.addresses = [ {
    address = "2600:3c01::f03c:91ff:fe08:5bfb";
    prefixLength = 64;
  } ];

  networking.domain = "jb55.com";
  networking.search = [ "jb55.com" ];
  networking.extraHosts = ''
    127.0.0.1 jb55.com
    ::1 jb55.com
  '';


  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.0.7/28" ];

      listenPort = ports.wireguard;

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/jb55/.wg/private";

     # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp0s3 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp0s3 -j MASQUERADE
      '';

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        { publicKey = "TbGgpOqD6teLon0ksZKS8zvvjHtkOGKNWPpHZxhVFWA=";
          allowedIPs = [ "10.100.0.1/32" ];
          endpoint = "24.84.152.187:53";
        }
        { publicKey = "wcoun9+1GX4awQF2Yd0WbsQ6RKHE9SsOsYv3qR7mbB0="; # quiver
          allowedIPs = [ "10.100.0.2/32" ];
        }
	      { publicKey = "vIh3IQgP92OhHaC9XBiJVDLlrs3GVcR6hlXaapjTiA0="; # iphone11
          allowedIPs = [ "10.100.0.3/32" ];
        }
        { publicKey = "oYTNuXPl5GQsz53cL55MO9MfI61DyZBrBDy9ZFBpDWU="; # mac
          allowedIPs = [ "10.100.0.8/32" ];
        }
	      { publicKey = "fj35gCObJ+uP/8tDpYsAD+b2XuSpa82umL/8LscIHwQ="; # pixel6
          allowedIPs = [ "10.100.0.9/32" ];
        }
      ];
    };
  };
}
