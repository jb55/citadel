extra:
{ config, lib, pkgs, ... }:
let
  chromecastIP = "192.168.87.190";
  iptables = "iptables -A nixos-fw";
  ipr = "${pkgs.iproute}/bin/ip";
  hasVPN = true;
  writeBash = extra.util.writeBash;
  transmission-dir = "/zbig/torrents";
  download-dir = "${transmission-dir}/Downloads";
  openCloseTCP = op: dev: port: ''
    ip46tables -${op} nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept ${if op == "D" then "|| true" else ""}
  '';
  openTCP = dev: port: openCloseTCP "A" dev port;
  closeTCP = dev: port: openCloseTCP "D" dev port;
  vpn = {
    name = "pia";
    table = "300";
    credfile = pkgs.writeText "vpncreds" ''
      ${extra.private.vpncred.user}
      ${extra.private.vpncred.pass}
    '';
    routeup = writeBash "openvpn-pia-routeup" ''
      ${pkgs.iproute}/bin/ip route add default via $route_vpn_gateway dev $dev metric 1 table ${vpn.table}
      exit 0
    '';
#    up = writeBash "openvpn-pia-preup" config.services.openvpn.servers.pia.up;
#    down = writeBash "openvpn-pia-stop" config.services.openvpn.servers.pia.down;
  };

  ports = {
    lightning = 9735;
    lightningt = 9736;
    lightning_websocket = 8756;
    lntun = 7878;
    dns = 53;
    http = 80;
    wireguard = 51820;
    weechat = 9000;
    nncp = 5442;
    inherit (extra.private) notify-port;
  };

  firewallRules = [
    "nixos-fw -s 10.100.0.0/24,192.168.87.1/24 -p tcp --dport 8080 -j nixos-fw-accept" # dev
    "nixos-fw -s 10.100.0.0/24,192.168.87.1/24 -p tcp --dport 5442 -j nixos-fw-accept"
    "nixos-fw -s 10.100.0.0/24 -p tcp --dport 80 -j nixos-fw-accept"
    "nixos-fw -s 10.100.0.0/24 -p tcp --dport 3000 -j nixos-fw-accept"
    "nixos-fw -s 10.100.0.0/24 -p tcp --dport 25565 -j nixos-fw-accept"
    "nixos-fw -s 10.100.0.0/24 -p tcp --dport 25575 -j nixos-fw-accept"
    "nixos-fw -s 10.100.0.2/32 -p tcp --dport ${toString ports.lntun} -j nixos-fw-accept"
    "nixos-fw -s 10.100.0.0/24 -p tcp --dport ${toString ports.weechat} -j nixos-fw-accept"
    "nixos-fw -s 10.100.0.0/24,192.168.87.1/24 -p tcp --dport 8333 -j nixos-fw-accept" # bitcoin
    "nixos-fw -s 10.100.0.0/24,192.168.87.1/24 -p tcp --dport 8332 -j nixos-fw-accept" # bitcoin-rpc
    "nixos-fw -s 192.168.122.218 -p udp --dport 137 -j nixos-fw-accept"
    "nixos-fw -s 192.168.122.218 -p udp --dport 138 -j nixos-fw-accept"
    "nixos-fw -s 192.168.122.218 -p tcp --dport 139 -j nixos-fw-accept"
    "nixos-fw -s 192.168.122.218 -p tcp --dport 445 -j nixos-fw-accept"
    "OUTPUT -t mangle   -m cgroup --cgroup 11 -j MARK --set-mark 11"
    "POSTROUTING -t nat -m cgroup --cgroup 11 -o tun0 -j MASQUERADE"
  ];

  addRule = rule: "iptables -A ${rule}";
  rmRule = rule: "iptables -D ${rule} || true";
  extraCommands = lib.concatStringsSep "\n" (map addRule firewallRules);
  extraStopCommands = lib.concatStringsSep "\n" (map rmRule firewallRules);
in
{
  networking.hostId = extra.machine.hostId;

  #networking.firewall.trustedInterfaces = ["wg0"];
  networking.firewall.allowedTCPPorts = with ports; [ lightning lightning_websocket http ];
  networking.firewall.allowedUDPPorts = with ports; [ dns wireguard ];

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
        #{ publicKey = "Dp8Df75X8Kh9gd33e+CWyyhOvT4mT0X9ToPwBUEBU1k="; # macos
        #  allowedIPs = [ "10.100.0.4/32" ];
        #}
        #{ publicKey = "N4bIpjNL/IzV59y5KWHiR54n0rAKYcr3/BkVLzCmBBA="; # old-mac
        #  allowedIPs = [ "10.100.0.5/32" ];
        #}
        #{ publicKey = "Ynuism5cSJYUrMF/gWZti8W+PztLufaB/3mQlXV6HyY="; # vanessa-phone
        #  allowedIPs = [ "10.100.0.6/32" ];
        #} 
        { publicKey = "BklL4dTL8WK3xnmM899Hr50/UlXaLYhJQWllj2p4ZEg="; # charon
          allowedIPs = [ "10.100.0.7/32" ];
          endpoint = "45.79.91.128:51820";
        }
        { publicKey = "oYTNuXPl5GQsz53cL55MO9MfI61DyZBrBDy9ZFBpDWU="; # cross (air)
          allowedIPs = [ "10.100.0.8/32" ];
        } 
        { publicKey = "kBTRfnUGBwbTlyazK1J67VVpzNg/wLjgmSfI9+1J6S4="; # ipad-air
          allowedIPs = [ "10.100.0.12/32" ];
        } 
        { publicKey = "fj35gCObJ+uP/8tDpYsAD+b2XuSpa82umL/8LscIHwQ="; # pixel6-android
          allowedIPs = [ "10.100.0.9/32" ];
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

  services.jellyfin.enable = false;

  services.plex = {
    enable = true;
    group = "transmission";
    openFirewall = true;
  };

  #services.xinetd.enable = true;
  #services.xinetd.services =
  #[
  #  { name = "gopher";
  #    port = 70;
  #    server = "${pkgs.gophernicus}/bin/in.gophernicus";
  #    serverArgs = "-nf -r /var/gopher";
  #    extraConfig = ''
  #      disable = no
  #      env = PATH=${pkgs.coreutils}/bin:${pkgs.curl}/bin
  #      passenv = PATH
  #    '';
  #  }
  #];

  services.nginx.httpConfig = lib.mkIf config.services.transmission.enable ''
    server {
      listen 80;
      listen ${extra.machine.ztip}:80;
      listen 192.168.87.26;

      # server names for this server.
      # any requests that come in that match any these names will use the proxy.
      server_name plex.jb55.com plez.jb55.com media.home plex.home;

      location = / {
          return 302 http://plex.jb55.com/web/index.html;
      }

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
				proxy_set_header X-Forwarded-Proto $scheme;
				proxy_set_header Host $server_addr;
				proxy_set_header Referer $server_addr;
				proxy_set_header Origin $server_addr; 

        # plex headers
				proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
				proxy_set_header X-Plex-Device $http_x_plex_device;
				proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
				proxy_set_header X-Plex-Platform $http_x_plex_platform;
				proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
				proxy_set_header X-Plex-Product $http_x_plex_product;
				proxy_set_header X-Plex-Token $http_x_plex_token;
				proxy_set_header X-Plex-Version $http_x_plex_version;
				proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
				proxy_set_header X-Plex-Provides $http_x_plex_provides;
				proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
				proxy_set_header X-Plex-Model $http_x_plex_model;

				# Websockets
				proxy_http_version 1.1;
				proxy_set_header Upgrade $http_upgrade;
				proxy_set_header Connection "upgrade";

				# Buffering off send to the client as soon as the data is received from Plex.
				proxy_redirect off;
				proxy_buffering off;

				client_max_body_size 100M;
				send_timeout 100m;

        # include Host header
        proxy_set_header Host $host;

        # proxy request to plex server
        proxy_pass http://plex.jb55.com:32400/;
      }
    }

    server {
      listen 80;
      listen ${extra.machine.ztip}:80;
      listen 192.168.87.26;
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

  systemd.services.transmission.enable = false;
  systemd.services.transmission.requires = [ "openvpn-pia.service" ];
  systemd.services.transmission.after    = [ "openvpn-pia.service" ];
  systemd.services.transmission.serviceConfig.User = lib.mkForce "root";
  systemd.services.transmission.serviceConfig.ExecStart = lib.mkForce (
    writeBash "start-transmission-under-vpn" ''
      exec ${pkgs.libcgroup}/bin/cgexec --sticky -g net_cls:pia \
      ${pkgs.sudo}/bin/sudo -u transmission \
      ${pkgs.transmission}/bin/transmission-daemon \
        -f \
        --port ${toString config.services.transmission.port};
    ''
  );

  networking.firewall.extraCommands =
    # openvpn stuff, we only want to do this once
    (if hasVPN then ''
      # create separate routing table
      ${ipr} rule add fwmark 11 table ${vpn.table}

      # add fallback route that blocks traffic, should the VPN go down
      ${ipr} route add blackhole default metric 2 table ${vpn.table}

    '' else "") + extraCommands;

  networking.firewall.extraStopCommands =
    (if hasVPN then ''
        # remove separate routing table
        ${ipr} rule del fwmark 11 table ${vpn.table} || true
        ${ipr} route del blackhole default metric 2 table ${vpn.table} || true

    '' else "") + extraStopCommands;

  users.extraGroups.vpn-pia.members = [ "jb55" "transmission" ];
  users.extraGroups.tor.members = [ "jb55" ];

  systemd.services.openvpn-pia.path = [ pkgs.libcgroup ];
  services.openvpn.servers = {
    pia = {
      autoStart = false;

      config = ''
        client
        dev tun
        proto udp
        remote 66.115.146.27 1194
        resolv-retry infinite
        remote-random
        nobind
        tun-mtu 1500
        tun-mtu-extra 32
        mssfix 1450
        persist-key
        persist-tun
        ping 15
        ping-restart 0
        ping-timer-rem
        reneg-sec 0
        comp-lzo no

        remote-cert-tls server

        auth-user-pass ${vpn.credfile}
        fast-io
        cipher AES-256-CBC
        auth SHA512

        route-noexec
        route-up ${vpn.routeup}

        <ca>
        -----BEGIN CERTIFICATE-----
        MIIFCjCCAvKgAwIBAgIBATANBgkqhkiG9w0BAQ0FADA5MQswCQYDVQQGEwJQQTEQ
        MA4GA1UEChMHTm9yZFZQTjEYMBYGA1UEAxMPTm9yZFZQTiBSb290IENBMB4XDTE2
        MDEwMTAwMDAwMFoXDTM1MTIzMTIzNTk1OVowOTELMAkGA1UEBhMCUEExEDAOBgNV
        BAoTB05vcmRWUE4xGDAWBgNVBAMTD05vcmRWUE4gUm9vdCBDQTCCAiIwDQYJKoZI
        hvcNAQEBBQADggIPADCCAgoCggIBAMkr/BYhyo0F2upsIMXwC6QvkZps3NN2/eQF
        kfQIS1gql0aejsKsEnmY0Kaon8uZCTXPsRH1gQNgg5D2gixdd1mJUvV3dE3y9FJr
        XMoDkXdCGBodvKJyU6lcfEVF6/UxHcbBguZK9UtRHS9eJYm3rpL/5huQMCppX7kU
        eQ8dpCwd3iKITqwd1ZudDqsWaU0vqzC2H55IyaZ/5/TnCk31Q1UP6BksbbuRcwOV
        skEDsm6YoWDnn/IIzGOYnFJRzQH5jTz3j1QBvRIuQuBuvUkfhx1FEwhwZigrcxXu
        MP+QgM54kezgziJUaZcOM2zF3lvrwMvXDMfNeIoJABv9ljw969xQ8czQCU5lMVmA
        37ltv5Ec9U5hZuwk/9QO1Z+d/r6Jx0mlurS8gnCAKJgwa3kyZw6e4FZ8mYL4vpRR
        hPdvRTWCMJkeB4yBHyhxUmTRgJHm6YR3D6hcFAc9cQcTEl/I60tMdz33G6m0O42s
        Qt/+AR3YCY/RusWVBJB/qNS94EtNtj8iaebCQW1jHAhvGmFILVR9lzD0EzWKHkvy
        WEjmUVRgCDd6Ne3eFRNS73gdv/C3l5boYySeu4exkEYVxVRn8DhCxs0MnkMHWFK6
        MyzXCCn+JnWFDYPfDKHvpff/kLDobtPBf+Lbch5wQy9quY27xaj0XwLyjOltpiST
        LWae/Q4vAgMBAAGjHTAbMAwGA1UdEwQFMAMBAf8wCwYDVR0PBAQDAgEGMA0GCSqG
        SIb3DQEBDQUAA4ICAQC9fUL2sZPxIN2mD32VeNySTgZlCEdVmlq471o/bDMP4B8g
        nQesFRtXY2ZCjs50Jm73B2LViL9qlREmI6vE5IC8IsRBJSV4ce1WYxyXro5rmVg/
        k6a10rlsbK/eg//GHoJxDdXDOokLUSnxt7gk3QKpX6eCdh67p0PuWm/7WUJQxH2S
        DxsT9vB/iZriTIEe/ILoOQF0Aqp7AgNCcLcLAmbxXQkXYCCSB35Vp06u+eTWjG0/
        pyS5V14stGtw+fA0DJp5ZJV4eqJ5LqxMlYvEZ/qKTEdoCeaXv2QEmN6dVqjDoTAo
        k0t5u4YRXzEVCfXAC3ocplNdtCA72wjFJcSbfif4BSC8bDACTXtnPC7nD0VndZLp
        +RiNLeiENhk0oTC+UVdSc+n2nJOzkCK0vYu0Ads4JGIB7g8IB3z2t9ICmsWrgnhd
        NdcOe15BincrGA8avQ1cWXsfIKEjbrnEuEk9b5jel6NfHtPKoHc9mDpRdNPISeVa
        wDBM1mJChneHt59Nh8Gah74+TM1jBsw4fhJPvoc7Atcg740JErb904mZfkIEmojC
        VPhBHVQ9LHBAdM8qFI2kRK0IynOmAZhexlP/aT/kpEsEPyaZQlnBn3An1CRz8h0S
        PApL8PytggYKeQmRhl499+6jLxcZ2IegLfqq41dzIjwHwTMplg+1pKIOVojpWA==
        -----END CERTIFICATE-----
        </ca>
        key-direction 1
        <tls-auth>
        #
        # 2048 bit OpenVPN static key
        #
        -----BEGIN OpenVPN Static key V1-----
        e685bdaf659a25a200e2b9e39e51ff03
        0fc72cf1ce07232bd8b2be5e6c670143
        f51e937e670eee09d4f2ea5a6e4e6996
        5db852c275351b86fc4ca892d78ae002
        d6f70d029bd79c4d1c26cf14e9588033
        cf639f8a74809f29f72b9d58f9b8f5fe
        fc7938eade40e9fed6cb92184abb2cc1
        0eb1a296df243b251df0643d53724cdb
        5a92a1d6cb817804c4a9319b57d53be5
        80815bcfcb2df55018cc83fc43bc7ff8
        2d51f9b88364776ee9d12fc85cc7ea5b
        9741c4f598c485316db066d52db4540e
        212e1518a9bd4828219e24b20d88f598
        a196c9de96012090e333519ae18d3509
        9427e7b372d348d352dc4c85e18cd4b9
        3f8a56ddb2e64eb67adfc9b337157ff4
        -----END OpenVPN Static key V1-----
        </tls-auth>
      '';

      up = ''
        # enable ip forwarding
        echo 1 > /proc/sys/net/ipv4/ip_forward

        # create cgroup for 3rd party VPN (can change 'vpn' to your name of choice)
        mkdir -p /sys/fs/cgroup/net_cls/${vpn.name}

        # give it an arbitrary id
        echo 11 > /sys/fs/cgroup/net_cls/${vpn.name}/net_cls.classid

        # grant a non-root user access
        cgcreate -t jb55:vpn-pia -a jb55:vpn-pia -g net_cls:${vpn.name}

        # disable reverse path filtering for all interfaces
        for i in /proc/sys/net/ipv4/conf\/*/rp_filter; do echo 0 > $i; done
      '';

      down = ''
        echo 0 > /proc/sys/net/ipv4/ip_forward

        cgdelete -g net_cls:${vpn.name}

        # not sure if cgdelete does this...
        rm -rf /sys/fs/cgroup/net_cls/${vpn.name}
      '';
    };
  };

  networking.firewall.checkReversePath = false;
  networking.firewall.logReversePathDrops = true;
  networking.firewall.logRefusedConnections = false;
}
