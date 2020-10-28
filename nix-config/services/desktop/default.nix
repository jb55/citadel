{ composeKey, util, userConfig, theme, icon-theme, extra }:
{ config, lib, pkgs, ... }:
let
  clippings-pl-file = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/jb55/kindle-clippings/master/clippings.pl";
    sha256 = "13bn5lvm4p85369yj88jr62h3zalmmyrzmjc332qwlqgqhyf3dls";
  };
  clippings-pl = util.writeBash "clippings.pl" ''
    ${lib.getBin pkgs.perl}/bin/perl ${clippings-pl-file}
  '';

  secrets = extra.private;
in
{
  imports = [
    (import ./networking extra)
  ];

  services.hoogle = {
    enable = false;
    packages = pkgs.myHaskellPackages;
    haskellPackages = pkgs.haskellPackages;
  };

  services.gnome3.gnome-keyring.enable = if extra.is-minimal then false else true;

  services.trezord.enable = if extra.is-minimal then false else true;

  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

  services.spotifyd.enable = if extra.is-minimal then false else true;
  services.spotifyd.config = ''
    [global]
    username = bcasarin
    password = ${secrets.spotify.password}
    backend = pulseaudio
    bitrate = 160
    device_name = spotifyd
    no_audio_cache = true
    volume_normalisation = true
    normalisation_pregain = -10
  '';

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryFlavor = "gtk2";

  # programs.gnupg.trezor-agent = {
  #   enable = if extra.is-minimal then false else true;
  #   configPath = "/home/jb55/.gnupg";
  # };

  services.emacs.enable = if extra.is-minimal then false else true;
  services.emacs.install = if extra.is-minimal then false else true;

  systemd.user.services.emacs.path = with pkgs; [ bash nix ];
  systemd.user.services.emacs.serviceConfig.ExecStart =
    let
      cfg = config.services.emacs;
    in
      lib.mkIf (!extra.is-minimal) (
      lib.mkForce (
        pkgs.writeScript "start-emacs" ''
          #!/usr/bin/env bash
          source ${config.system.build.setEnvironment}

          # hacky af
          export NIX_PATH=dotfiles=/home/jb55/dotfiles:jb55pkgs=/home/jb55/etc/jb55pkgs:monstercatpkgs=/home/jb55/etc/monstercatpkgs:nixos-config=/home/jb55/etc/nix-files:nixpkgs=/home/jb55/nixpkgs:/home/jb55/.nix-defexpr/channels:nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels
          export NIXPKGS=/home/jb55/nixpkgs

          exec ${cfg.package}/bin/emacs --daemon
        ''
      ));

  services.redshift = {
    enable = if extra.is-minimal then false else true;
    temperature.day = 5500;
    temperature.night = 4300;

    brightness = {
      day = "1.0";
      night = "0.8";
    };
  };

  location.latitude = 49.270186;
  location.longitude = -123.109353;

  systemd.user.services.udiskie =  {
    enable = if extra.is-minimal then false else true;
    description = "userspace removable drive automounter";
    after    = [ "multi-user.target" ];
    wants    = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${lib.getBin pkgs.udiskie}/bin/udiskie";
    };
  };

  systemd.user.services.udp-notify-daemon = {
    enable = true;
    description = "udp notification daemon";
    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    path = with pkgs; [ bash gnupg libnotify netcat nettools ];

    serviceConfig.ExecStart = util.writeBash "notify-daemon" ''
      exec ${pkgs.socat}/bin/socat -d -d udp4-recvfrom:${toString extra.private.notify-port},reuseaddr,fork exec:/home/jb55/bin/recvalert
    '';
  };

  systemd.user.services.kindle-sync3 = {
    enable = false;
    description = "sync kindle";
    after    = [ "media-kindle.mount" ];
    requires = [ "media-kindle.mount" ];
    wantedBy = [ "media-kindle.mount" ];
    serviceConfig = {
      ExecStart = util.writeBash "kindle-sync" ''
        export PATH=${lib.makeBinPath (with pkgs; [ coreutils eject perl dos2unix git ])}:$PATH
        NOTES=/home/jb55/doc/notes/kindle
        mkdir -p $NOTES
        </media/kindle/documents/My\ Clippings.txt dos2unix | \
          ${clippings-pl} > $NOTES/clippings.yml
        cd $NOTES
        if [ ! -d ".git" ]; then
          git init .
          git remote add origin gh:jb55/my-clippings
        fi
        git add clippings.yml
        git commit -m "update"
        git push -u origin master
      '';
    };
  };

  services.mpd = {
    enable = false;
    dataDir = "/home/jb55/mpd";
    user = "jb55";
    group = "users";
    extraConfig = ''
      audio_output {
        type     "pulse"
        name     "Local MPD"
        server   "127.0.0.1"
      }
    '';
  };

  services.xserver = {
    enable = true;
    layout = "us";

    # xset r rate 200 50
    autoRepeatDelay = 200;
    autoRepeatInterval = 50;

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps, keypad:hex, altwin:swap_alt_win, lv3:ralt_switch, compose:${composeKey}";

    wacom.enable = false;

    displayManager = {
      defaultSession = "none+xmonad";
      sessionCommands = "${userConfig}/bin/xinitrc";
      lightdm = {
        enable = true;
        background = "${pkgs.fetchurl {
          url = "https://jb55.com/s/red-low-poly.png";
          sha256 = "e45cc45eb084d615babfae1aae703757c814d544e056f0627d175a6ab18b35ab";
        }}";
      };
    };

    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };

    desktopManager = {
      xterm.enable = false;
    };

  };

  # Enable the OpenSSH daemon.
  # Enable CUPS to print documents.
  services.printing = {
    enable = if extra.is-minimal then false else true;
    drivers = [ pkgs.gutenprint ] ;
  };

  systemd.user.services.standup = {
    enable   = if extra.is-minimal then false else true;
    description = "Standup notification";
    wantedBy = [ "graphical-session.target" ];
    after    = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.libnotify}/bin/notify-send -u critical standup";
    startAt = "Mon..Fri *-*-* 9:28:00";
  };

  systemd.user.services.urxvtd = {
    enable = true;
    description = "RXVT-Unicode Daemon";
    wantedBy = [ "graphical-session.target" ];
    after    = [ "graphical-session.target" ];
    path = [ pkgs.rxvt_unicode-with-plugins ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.rxvt_unicode-with-plugins}/bin/urxvtd -q -o";
    };
  };

  systemd.user.services.xautolock = {
    enable      = true;
    description = "X auto screen locker";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.xautolock}/bin/xautolock -time 10 -locker ${pkgs.slock}/bin/slock";
  };

  services.clipmenu.enable = true;

  environment.systemPackages = [pkgs.phonectl];
  systemd.user.services.phonectl = {
    enable      = if extra.is-minimal then false else true;
    description = "phonectl";
    wantedBy = [ "graphical-session.target" ];
    after    = [ "graphical-session.target" ];

    serviceConfig.ExecStart = "${pkgs.phonectl}/bin/phonectld";

    environment = with secrets.phonectl; {
      PHONECTLUSER=user;
      PHONECTLPASS=pass;
      PHONECTLPHONE=phone;
    };
  };

  # TODO: maybe doesn't have my package env
  # systemd.user.services.xbindkeys = {
  #   enable      = true;
  #   description = "X key bind helper";
  #   wantedBy    = [ "graphical-session.target" ];
  #   after       = [ "graphical-session.target" ];
  #   serviceConfig.ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys -n -f ${pkgs.jb55-dotfiles}/.xbindkeysrc";
  # };

  systemd.user.services.dunst = {
    enable      = if extra.is-minimal then false else true;

    description = "dunst notifier";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
  };

  systemd.user.services.xinitrc = {
    enable      = true;
    description = "X session init commands";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${userConfig}/bin/xinitrc";
    };
  };

}
