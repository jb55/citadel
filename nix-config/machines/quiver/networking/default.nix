extra:
{ config, lib, pkgs, ... }:
let
  chromecastIPs = [ "192.168.86.190" ];
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

in
{
  networking.extraHosts = ''
    10.0.9.1         secure.datavalet.io.
    172.24.242.111   securitycam.home.
    24.244.54.234    wifisignon.shaw.ca.
  '';

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.100.0.2/28" ];

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/home/jb55/.wg/private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        {
          publicKey = "TbGgpOqD6teLon0ksZKS8zvvjHtkOGKNWPpHZxhVFWA=";
          allowedIPs = [ "10.100.0.1/32" ];
          #endpoint = "127.0.0.1:3333";
          endpoint = "24.84.152.187:53";

          persistentKeepalive = 25;
        }
        {
          publicKey = "vIh3IQgP92OhHaC9XBiJVDLlrs3GVcR6hlXaapjTiA0=";

          allowedIPs = [ "10.100.0.3/32" ];

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
        {
          publicKey = "Dp8Df75X8Kh9gd33e+CWyyhOvT4mT0X9ToPwBUEBU1k="; # macos
          allowedIPs = [ "10.100.0.4/32" ];

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };


  networking.wireless.userControlled.enable = true;

  networking.firewall.enable = true;
  networking.firewall.extraCommands = ''
    ${lib.concatStringsSep "\n\n" (map openChromecast chromecastIPs)}

    # home network nginx
    iptables -A nixos-fw -p tcp -s 192.168.86.0/24 -d 192.168.86.0/24 --dport 80 -j nixos-fw-accept

    # mark tor-related packets
    iptables -t mangle -A OUTPUT -m cgroup --cgroup 12 -j MARK --set-mark 12

    # all tor traffic should never try to route outside our wireguard tunnel to our tor node
    iptables -t nat -A POSTROUTING -m cgroup --cgroup 12 -o wg0 -j MASQUERADE

    # create separate routing table
    ${ipr} rule add fwmark 12 table 12

    # add fallback route that blocks traffic, should the VPN go down
    ${ipr} route add blackhole default metric 2 table 12
  '';

  networking.firewall.extraStopCommands = ''
    iptables -D nixos-fw -p tcp -s 192.168.86.0/24 -d 192.168.86.0/24 --dport 80 -j nixos-fw-accept || true

    # mark tor-related packets
    iptables -t mangle -D OUTPUT -m cgroup --cgroup 12 -j MARK --set-mark 12 || true

    # all tor traffic should never try to route outside our wireguard tunnel to our tor node
    iptables -t nat -D POSTROUTING -m cgroup --cgroup 12 -o wg0 -j MASQUERADE || true

    # create separate routing table
    ${ipr} rule del fwmark 12 table 12

    # add fallback route that blocks traffic, should the VPN go down
    ${ipr} route del blackhole default metric 2 table 12
  '';


  #networking.firewall.allowedTCPPorts = [ 8333 ];
}
