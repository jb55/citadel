extra:
{ config, lib, pkgs, ... }:
let util = extra.util;
    nix-serve = extra.machine.nix-serve;
    zenstates = pkgs.fetchFromGitHub {
      owner  = "r4m0n";
      repo   = "ZenStates-Linux";
      rev    = "0bc27f4740e382f2a2896dc1dabfec1d0ac96818";
      sha256 = "1h1h2n50d2cwcyw3zp4lamfvrdjy1gjghffvl3qrp6arfsfa615y";
    };
    jb55pkgs = import <jb55pkgs> { inherit pkgs; };
    git-email-contacts = "${jb55pkgs.git-email-contacts}/bin/git-email-contacts";
    email-notify = util.writeBash "email-notify-user" ''
      export HOME=/home/jb55
      export PATH=${lib.makeBinPath (with pkgs; [ eject libnotify muchsync notmuch openssh ])}:$PATH
      (
        flock -x -w 100 200 || exit 1

        muchsync charon

        #DISPLAY=:0 notify-send --category=email "you got mail"

      ) 200>/tmp/email-notify.lock
    '';

in
{
  imports = [
    ./hardware
    # ./contracts/commit
    # ./contracts/plastiq

    #(import ../../misc/dnsmasq-adblock.nix)
    (import ../../misc/msmtp extra)
    (import ./networking extra)
    (import ../../misc/imap-notifier extra)
  ] ++ (if !extra.is-minimal then [ (import ./bitcoin extra) ] else []);

  #hardware.steam-hardware.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.ofono.enable = true;
  services.ofono.plugins = with pkgs; [ ofono-phonesim ];

  services.prometheus.enable = false;
  # services.prometheus.dataDir = "/zbig/data/prometheus";
  services.grafana.enable = false;
  services.grafana.port = 3005;
  services.grafana.provision.datasources = [
    { name = "bitcoin";
      type = "prometheus";
      access = "direct";
      isDefault = true;
    }
  ];

  # services.guix.enable = true;
  services.synergy.server.enable = if extra.is-minimal then false else true;
  services.synergy.server.autoStart = true;
  services.synergy.server.screenName = "desktop";
  services.synergy.server.configFile = pkgs.writeText "barrier-cfg" ''
    section: screens
      desktop:
      mac:
      win:
    end
    section: aliases
        desktop:
          192.168.86.26
        mac:
          10.100.0.4
        win:
          192.168.122.218
    end
    section: links
      desktop:
          left = mac
          right = win
      mac:
          right = desktop
      win:
          left = desktop
    end
    section: options
      keystroke(alt+control+h) = switchInDirection(left)
      keystroke(alt+control+l) = switchInDirection(right)
    end
  '';

  services.bitlbee.enable = if extra.is-minimal then false else true;
  services.bitlbee.libpurple_plugins = with pkgs; [
    pidgin-skypeweb
    purple-facebook
    purple-hangouts
    telegram-purple
    purple-matrix
  ];

  # services.thelounge.enable = true;
  # services.thelounge.theme = "thelounge-theme-mininapse";
  # services.thelounge.port = 9002;

  services.dnscrypt-proxy2.enable = false;
  services.dnscrypt-proxy2.settings = {

    listen_addresses = [ "127.0.0.1:43" ];
    server_names = ["cs-ca2" "ev-to"];
    fallback_resolver = "1.1.1.1:53";
    sources = {
      public-resolvers = {
        urls = ["https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/public-resolvers.md"
                "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md"
               ];
        cache_file = "public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 71;
      };

      relays = {
        urls = ["https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/relays.md"];
        cache_file = "relays.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 71;
      };
    };
    anonymized_dns.routes = [
      { server_name="cs-ca2"; via=["anon-ev-va"]; }
      { server_name="ev-to"; via=["anon-cs-ca2"]; }
    ];
  };

  services.dnsmasq.enable = true;
  services.dnsmasq.resolveLocalQueries = true;
  #services.dnsmasq.servers = ["127.0.0.1#43"];
  # services.dnsmasq.servers = ["127.0.0.1#43" "1.1.1.1" "8.8.8.8"];
  services.dnsmasq.servers = ["8.8.8.8" "8.8.4.4" ];
  services.dnsmasq.extraConfig = ''
    cache-size=10000
    addn-hosts=/var/hosts
    conf-file=/var/dnsmasq-hosts
    conf-file=/var/distracting-hosts
  '';


  services.bitlbee.plugins = with pkgs; [
    bitlbee-mastodon
  ];

  # shitcoin vendor
  services.keybase.enable = false;

  systemd.services.block-distracting-hosts = {
    description = "Block Distracting Hosts";

    path = with pkgs; [ systemd procps ];

    serviceConfig.ExecStart = util.writeBash "block-distracting-hosts" ''
      set -e
      cp /var/undistracting-hosts /var/distracting-hosts

      # crude way to clear the cache...
      systemctl restart dnsmasq
      pkill qutebrowser
    '';

    startAt = "Mon..Fri *-*-* 09:00:00";
  };

  systemd.user.services.bitcoin-contacts = {
    enable = if extra.is-minimal then false else true;
    description = "Email bitcoin PR patches that have me as a git-contact";

    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];

    path = with pkgs; [ openssh msmtp libnotify netcat ];

    environment = {
	SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
    };

    serviceConfig.ExecStart = util.writeBash "bitcoin-contacts" ''
	export SSH_ASKPASS="${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass"
	cd /home/jb55/dev/github/bitcoin/bitcoin 
	while true
	do
		duration="5m"
		${git-email-contacts}
		printf "done for now, waiting %s...\n" $duration 2>&1
		sleep $duration
	done
    '';
  };

  systemd.user.services.stop-spotify-bedtime = {
    enable      = if extra.is-minimal then false else true;
    description = "Stop spotify when Elliott goes to bed";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.dbus}/bin/dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop";

    startAt = "*-*-* 19:30:00";
  };

  systemd.services.unblock-distracting-hosts = {
    enable = if extra.is-minimal then false else true;

    description = "Unblock Distracting Hosts";

    path = with pkgs; [ systemd ];

    serviceConfig.ExecStart = util.writeBash "unblock-distracting-hosts" ''
      set -e
      echo "" > /var/distracting-hosts
      systemctl restart dnsmasq
    '';

    startAt = "Mon..Fri *-*-* 17:00:00";
  };

  virtualisation.docker.enable = if extra.is-minimal then false else true;

  boot.kernelPatches = [
    #{ # pci acs hack, not really safe or a good idea
    #  name = "acs-overrides";
    #  patch = pkgs.fetchurl {
    #    url = "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
    #    sha256 = "1b1qjlqkbwpv82aja48pj9vpi9p6jggc8g92p4rg7zjjjs2ldp24";
    #  };
    #}
  ];

  #boot.kernelParams = [ "pcie_acs_override=downstream" ];

  systemd.user.services.clightning-rpc-tunnel = {
    description = "clightning mainnet rpc tunnel";
    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    serviceConfig.ExecStart = extra.util.writeBash "lightning-tunnel" ''
      ${pkgs.socat}/bin/socat -d -d TCP-LISTEN:7878,fork,reuseaddr,range=10.100.0.2/32 UNIX-CONNECT:/home/jb55/.lightning/bitcoin/lightning-rpc
    '';
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuOvmf = true;
  virtualisation.libvirtd.qemuVerbatimConfig = ''
    user = "jb55"
    group = "kvm"
    cgroup_device_acl = [
      "/dev/input/by-id/usb-Topre_Corporation_Realforce-event-kbd",
      "/dev/input/by-id/usb-Razer_Razer_DeathAdder_2013-event-mouse",
      "/dev/null", "/dev/full", "/dev/zero",
      "/dev/random", "/dev/urandom",
      "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
      "/dev/rtc","/dev/hpet", "/dev/sev"
    ]
  '';

  services.samba = {
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 jb55 qemu-libvirtd -"
    "f /dev/shm/scream 0660 jb55 qemu-libvirtd -"
  ];

  systemd.user.services.scream-ivshmem = {
    enable = true;
    description = "Scream IVSHMEM";
    serviceConfig = {
      ExecStart = "${pkgs.scream-receivers}/bin/scream-ivshmem-pulse /dev/shm/scream";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
    requires = [ "pulseaudio.service" ];
  };

  systemd.user.services.btc-ban-aws = {
    enable   = if extra.is-minimal then false else true;
    description = "Ban Bitcoin EC2 nodes";
    wantedBy = [ "bitcoind-mainnet.service" ];
    after    = [ "bitcoind-mainnet.service" ];
    serviceConfig.ExecStart = util.writeBash "btc-ban-ec2" ''
      # lets chill for a bit before we do this
      ${pkgs.curl}/bin/curl -s 'https://ip-ranges.amazonaws.com/ip-ranges.json' |
      ${pkgs.jq}/bin/jq -rc '.prefixes[].ip_prefix | {"jsonrpc": "1.0", "id":"aws-banscript", method: "setban", "params": [., "add", 3450]}' |
      ${pkgs.jq}/bin/jq -s  |
      ${pkgs.curl}/bin/curl -s -u ${extra.private.btc-user}:${extra.private.btc-pass} --data-binary @/dev/stdin -H 'content-type: text/plain' ${extra.private.btc-rpc-host}:${extra.private.btc-rpc-port}
    '';
    startAt = "*-*-* *:00:00"; #hourly
  };

  environment.systemPackages = [ pkgs.virt-manager ];

  virtualisation.virtualbox.host.enable = false;#if extra.is-minimal then false else true;
  virtualisation.virtualbox.host.enableHardening = false;
  #virtualization.virtualbox.host.enableExtensionPack = true;

  users.extraUsers.jb55.extraGroups = [ "vboxusers" "bitcoin" "kvm" "input" ];

  services.xserver.videoDrivers = [ ];

  users.extraGroups.tor.members = [ "jb55" "nginx" ];
  users.extraGroups.bitcoin.members = [ "jb55" ];
  users.extraGroups.nginx.members = [ "jb55" ];
  users.extraGroups.transmission.members = [ "nginx" "jb55" ];

  programs.mosh.enable = false;
  programs.adb.enable = true;

  documentation.nixos.enable = false;

  # services.trezord.enable = if extra.is-minimal then false else true;
  services.redis.enable = if extra.is-minimal then false else true;

  services.zeronet.enable = false;
  #services.zeronet.trackers = ''
  #  http://tracker.nyap2p.com:8080/announce
  #  http://tracker3.itzmx.com:6961/announce
  #  http://tracker1.itzmx.com:8080/announce
  #  https://trakx.herokuapp.com:443/announce
  #  udp://ultra.zt.ua:6969/announce
  #'';

  services.mongodb.enable = if extra.is-minimal then false else false;

  services.tor.enable = if extra.is-minimal then false else true;
  services.tor.controlPort = 9051;
  services.tor.client.enable = true;
  services.tor.settings = extra.private.tor.settings;

  services.fcgiwrap.enable = if extra.is-minimal then false else true;

  services.nix-serve.enable = false;
  services.nix-serve.bindAddress = nix-serve.bindAddress;
  services.nix-serve.port = nix-serve.port;

  services.xserver.screenSection = ''
    Option "metamodes" "1920x1080_144 +0+0"
    Option "dpi" "96 x 96"
  '';

  services.nginx.enable = if extra.is-minimal then false else true;
  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/var/www" ];
  services.nginx.httpConfig = ''
      server {
        listen 80;
        listen ${extra.machine.ztip}:80;
        listen 192.168.86.26;

	server_name notes.jb55.com;

	location / {
	    root                  /var/www/notes;
	    autoindex on;
            index index.html;

	    client_body_temp_path /var/www/tmp;

	    dav_methods PUT DELETE MKCOL COPY MOVE;
	    dav_ext_methods PROPFIND OPTIONS;

	    client_max_body_size 10M;

	    create_full_put_path  on;
	    dav_access            user:rw group:rw  all:rw;
	}
      }

    '' + (if config.services.nix-serve.enable then ''
      server {
        listen ${nix-serve.bindAddress}:80;
        server_name cache.monad.jb55.com;

        location / {
          proxy_pass  http://${nix-serve.bindAddress}:${toString nix-serve.port};
          proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
          proxy_redirect off;
          proxy_buffering off;
          proxy_set_header        Host            $host;
          proxy_set_header        X-Real-IP       $remote_addr;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        }
      }
    '' else "") + (if config.services.tor.enable then extra.private.tor.nginx else "");

  # services.footswitch = {
  #   enable = false;
  #   enable-led = true;
  #   led = "input5::numlock";
  # };

  systemd.services.disable-c6 = {
    description = "Ryzen Disable C6 State";

    wantedBy = [ "basic.target" ];
    after = [ "sysinit.target" "local-fs.target" ];

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = util.writeBash "disable-c6-state" ''
      ${pkgs.kmod}/bin/modprobe msr
      ${pkgs.python2}/bin/python ${zenstates}/zenstates.py --c6-disable --list
    '';
  };

  services.mysql.enable = false;
  services.mysql.package = pkgs.mariadb;

  # services.postgresql = {
  #   dataDir = "/var/db/postgresql/100/";
  #   enable = true;
  #   package = pkgs.postgresql_10;
  #   # extraPlugins = with pkgs; [ pgmp ];
  #   authentication = pkgs.lib.mkForce ''
  #     # type db  user address            method
  #     local  all all                     trust
  #     host   all all  127.0.0.1/32       trust
  #     host   all all  192.168.86.0/24    trust
  #   '';
  #   extraConfig = ''
  #     listen_addresses = '0.0.0.0'
  #   '';
  # };

  # services.postgresql = {
  #   dataDir = "/var/db/postgresql/96/";
  #   enable = true;
  #   package = pkgs.postgresql96;
  #   # extraPlugins = with pkgs; [ pgmp ];
  #   authentication = pkgs.lib.mkForce ''
  #     # type db  user address            method
  #     local  all all                     trust
  #     host   all all  127.0.0.1/32       trust
  #     host   all all  192.168.86.0/24    trust
  #   '';
  #   extraConfig = ''
  #     listen_addresses = '0.0.0.0'
  #   '';
  # };

  # security.pam.u2f = {
  #   enable = true;
  #   interactive = true;
  #   cue = true;
  #   control = "sufficient";
  #   authfile = "${pkgs.writeText "pam-u2f-config" ''
  #     jb55:vMXUgYb1ytYmOVgqFDwVOxJmvVI9F3gdSJVbvsi1A1VA-3mftTUhgARo4Kmm_8SAH6IJJ8p3LSXPSbtTSXMIpQ,04d8c1542a7391ee83112a577db968b84351f0090a9abe7c75bedcd94777cf15727c68ce4ac8858ff2812ded3c86d978efc5893b25cf906032632019fe792d3ec4
  #   ''}";
  # };

}
