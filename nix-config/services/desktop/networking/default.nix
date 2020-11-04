extra:
{ config, lib, pkgs, ... }:
let
  ports = {
    notify = extra.private.notify-port;
  };

  firewallRules = [
    "nixos-fw -s 10.100.0.1/24,45.79.91.128 -p udp --dport ${toString ports.notify} -j nixos-fw-accept"
  ];

  addRule = rule: "iptables -A ${rule}";
  rmRule = rule: "iptables -D ${rule} || true";
  extraCommands = lib.concatStringsSep "\n" (map addRule firewallRules);
  extraStopCommands = lib.concatStringsSep "\n" (map rmRule firewallRules);
in
{
  networking.firewall.extraCommands = extraCommands;
  networking.firewall.extraStopCommands = extraStopCommands;
}
