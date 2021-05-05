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

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        { publicKey = "TbGgpOqD6teLon0ksZKS8zvvjHtkOGKNWPpHZxhVFWA=";
          allowedIPs = [ "10.100.0.1/32" ];
          endpoint = "24.84.152.187:51820";
        }
        { publicKey = "wcoun9+1GX4awQF2Yd0WbsQ6RKHE9SsOsYv3qR7mbB0="; # quiver
          allowedIPs = [ "10.100.0.2/32" ];
        }
	{ publicKey = "vIh3IQgP92OhHaC9XBiJVDLlrs3GVcR6hlXaapjTiA0="; # phone
          allowedIPs = [ "10.100.0.3/32" ];
        }
        { publicKey = "Dp8Df75X8Kh9gd33e+CWyyhOvT4mT0X9ToPwBUEBU1k="; # mac
          allowedIPs = [ "10.100.0.4/32" ];
        }
      ];
    };
  };
}
