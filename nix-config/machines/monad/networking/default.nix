extra:
{ config, lib, pkgs, ... }:
let
  chromecastIP = "192.168.86.190";
  iptables = "iptables -A nixos-fw";
  ipr = "${pkgs.iproute}/bin/ip";
  writeBash = extra.util.writeBash;
  transmission-dir = "/zbig/torrents";
  download-dir = "${transmission-dir}/Downloads";
  openCloseTCP = op: dev: port: ''
    ip46tables -${op} nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept ${if op == "D" then "|| true" else ""}
  '';
  openTCP = dev: port: openCloseTCP "A" dev port;
  closeTCP = dev: port: openCloseTCP "D" dev port;

  ports = {
    synergy = 24800;
    lightning = 9735;
    lightningt = 9736;
    dns = 53;
    http = 80;
    wireguard = 51820;
    inherit (extra.private) notify-port;
  };

  firewallRules = [
    "nixos-fw -s 10.100.0.1/24,192.168.86.1/24 -p tcp --dport 8080 -j nixos-fw-accept" # dev
    "nixos-fw -s 192.168.122.218 -p udp --dport 137 -j nixos-fw-accept"
    "nixos-fw -s 192.168.122.218 -p udp --dport 138 -j nixos-fw-accept"
    "nixos-fw -s 192.168.122.218 -p tcp --dport 139 -j nixos-fw-accept"
    "nixos-fw -s 192.168.122.218 -p tcp --dport 445 -j nixos-fw-accept"
  ];

  addRule = rule: "iptables -A ${rule}";
  rmRule = rule: "iptables -D ${rule} || true";
  extraCommands = lib.concatStringsSep "\n" (map addRule firewallRules);
  extraStopCommands = lib.concatStringsSep "\n" (map rmRule firewallRules);
in
{
  networking.hostId = extra.machine.hostId;

  #networking.firewall.trustedInterfaces = ["wg0"];
  networking.firewall.allowedTCPPorts = with ports; [ lightning lightningt synergy http ];
  networking.firewall.allowedUDPPorts = [ ports.dns ports.wireguard ];

  networking.firewall.extraCommands = extraCommands;
  networking.firewall.extraStopCommands = extraStopCommands;

  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      listenPort = ports.wireguard;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp30s0 -j MASQUERADE
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp30s0 -j MASQUERADE
      '';

      privateKeyFile = "/home/jb55/.wg/private";

      peers = [
        { publicKey = "wcoun9+1GX4awQF2Yd0WbsQ6RKHE9SsOsYv3qR7mbB0="; # quiver
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { publicKey = "vIh3IQgP92OhHaC9XBiJVDLlrs3GVcR6hlXaapjTiA0="; # phone
          allowedIPs = [ "10.100.0.3/32" ];
        }
        { publicKey = "Dp8Df75X8Kh9gd33e+CWyyhOvT4mT0X9ToPwBUEBU1k="; # macos
          allowedIPs = [ "10.100.0.4/32" ];
        }
      ];
    };

    rcx0 = {
     # Determines the IP address and subnet of the server's end of the tunnel interface.
     ips = [ "10.200.0.2/32" ];

     privateKeyFile = "/home/jb55/.wg/rcx/private";

     peers = [
       { publicKey = "wC+mEE9/PJDuIfr7DFZWnM8HbQz5fSOFHmmzQRxULzM="; # server
         allowedIPs = [ "10.200.0.1/32" ];
         endpoint = "159.89.143.225:53";
         persistentKeepalive = 25;
       }
       { publicKey = "vrKDdLPXAXAPP7XuuQl/dsD+z3dV/Z0uhgc+yjJ4Nys="; # winvm
         allowedIPs = [ "10.200.0.3/32" ];
         endpoint = "192.168.122.218:51820";
         persistentKeepalive = 25;
       }
     ];
    };
  };


  services.transmission = {
    enable = true;
    home = transmission-dir;
    settings = {
      incomplete-dir-enable = true;
      rpc-whitelist = "127.0.0.1";
    };

    port = 14325;
  };

  services.plex = {
    enable = false;
    group = "transmission";
    openFirewall = true;
  };

  services.xinetd.enable = true;
  services.xinetd.services =
  [
    { name = "gopher";
      port = 70;
      server = "${pkgs.gophernicus}/bin/in.gophernicus";
      serverArgs = "-nf -r /var/gopher";
      extraConfig = ''
        disable = no
        env = PATH=${pkgs.coreutils}/bin:${pkgs.curl}/bin
        passenv = PATH
      '';
    }
  ];

  services.nginx.httpConfig = lib.mkIf config.services.transmission.enable ''
    server {
      listen 80;
      listen ${extra.machine.ztip}:80;
      listen 192.168.86.26;

      # server names for this server.
      # any requests that come in that match any these names will use the proxy.
      server_name plex.jb55.com plez.jb55.com media.home plex.home;

      # this is where everything cool happens (you probably don't need to change anything here):
      location / {
        # if a request to / comes in, 301 redirect to the main plex page.
        # but only if it doesn't contain the X-Plex-Device-Name header
        # this fixes a bug where you get permission issues when accessing the web dashboard

        if ($http_x_plex_device_name = \'\') {
          rewrite ^/$ http://$http_host/web/index.html;
        }

        # set some headers and proxy stuff.
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_redirect off;

        # include Host header
        proxy_set_header Host $host;

        # proxy request to plex server
        proxy_pass http://127.0.0.1:32400;
      }
    }

    server {
      listen 80;
      listen ${extra.machine.ztip}:80;
      listen 192.168.86.26;
      server_name torrents.jb55.com torrentz.jb55.com torrents.home torrent.home;

      location = /download {
        return 301 " /download/";
      }

      location /download/ {
        alias ${download-dir}/;
        autoindex on;
      }

      location / {
        proxy_read_timeout 300;
        proxy_pass_header  X-Transmission-Session-Id;
        proxy_set_header   X-Forwarded-Host   $host;
        proxy_set_header   X-Forwarded-Server $host;
        proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_pass         http://127.0.0.1:${toString config.services.transmission.port}/transmission/web/;
      }

      location /rpc {
        proxy_pass         http://127.0.0.1:${toString config.services.transmission.port}/transmission/rpc;
      }

      location /upload {
        proxy_pass         http://127.0.0.1:${toString config.services.transmission.port}/transmission/upload;
      }
    }
  '';

}
