extra:
{ config, lib, pkgs, ... }:
let gitExtra = {
      git = {projectroot = "/var/git";};
      host = "git.zero.jb55.com";
    };
    httpipePort = "8899";
    # httpiped = (import (pkgs.fetchgit {
    #   url = https://github.com/jb55/httpipe;
    #   rev = "376de0e37bba505ba5f23c46435277bb74603acd";
    #   sha256 = "1x9d98z6zbs22x38xwxjnb6mwladbah9xajyl7kk8bm418l8wac4";
    # }) { nodejs = pkgs.nodejs; }).package;
    npmrepo = (import (pkgs.fetchFromGitHub {
      owner  = "jb55";
      repo   = "npm-repo-proxy";
      rev    = "bef839a95736588ec40c917fa63d490cd736f307";
      sha256 = "1j2xclgcmz9hbf47k4ygyzmiradfg9q30m8bzr1i2x91kz1ck946";
    }) {}).package;

    gaufre = (import (pkgs.fetchFromGitHub {
      owner  = "jb55";
      repo   = "gaufre";
      rev    = "fe9d3cb3a6e4616d1f2f95607cea3a0582db4872";
      sha256 = "091lbcijfzbbr3sm4nxqzz5pdgwqlhhxsa6qy0svmk44q3nd6zvh";
    }) {}).package;

    pgpkeys = pkgs.fetchurl {
      url = "https://jb55.com/s/pgpkey.pub";
      sha256 = "d264cec5342a647964f0882e444f61272768e2a885a28ba67b6a44e14d9dab28";
    };

    gitCfg = extra.git-server { inherit config pkgs; extra = extra // gitExtra; };
    hearpress = (import <jb55pkgs> { nixpkgs = pkgs; }).hearpress;
    myemail = "jb55@jb55.com";
    xmpp_modules = [
	    "csi"
	    "smacks"
	    "mam"
	    "cloud_notify"
	    "carbons"
	    "http_upload"
    ];
    radicale-rights = pkgs.writeText "radicale-rights" ''
      [vanessa-famcal-access]
      user = vanessa
      collection = jb55/4bcae62e-9c8b-0d94-d8ef-977a29a24a84
      permission = rw

      # Give owners read-write access to everything else:
      [owner-write]
      user = .+
      collection = %(login)s(/.*)?
      permission = rw

      # Everyone can read the root collection
      [read]
      user = .*
      collection =
      permission = r
    '';
    jb55-activity = pkgs.writeText "jb55-custom-activity" ''
      {
        "@context": [
          "https://www.w3.org/ns/activitystreams"
        ],
        "inbox": "https://jb55/inbox",
        "id": "https://jb55.com",
        "type": "Person",
        "preferredUsername": "jb55",
        "name": "William Casarin",
        "summary": "This is not a real activitypub endpoint yet! I'm still building it",
        "url": "https://jb55.com",
        "manuallyApprovesFollowers": false,
        "icon": {
          "type": "Image",
          "mediaType": "image/jpeg",
          "url": "https://jb55.com/me.jpg"
        },
        "publicKey": {
          "id": "https://jb55.com#main-key",
          "owner": "https://jb55.com",
          "publicKeyPem": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnJOPxwmRGBBQYm7YgHRu\nbTaYaKbMoEQiui+37nizXA73CRNeKblSXIaJnfOKfz/ttRG0GH43GzHTpghUDuZX\n+QBpyOk8UMmCW5gM0Y5c3IOv0zLezqLXrVEM8UXMUHE3hxf61r1NKl1+IG9MwhtH\nayx0Kaz6vT/V8nkotCSlb91lMT8X28bButwN86RCclZncecQXuVvgXnFeZCeBLM+\nqV2tBPnn14Ws+AqVvVnBW8xXwVfSPFHQchSLAusdWI7Kw/oWN/on2CqfRASoaVAS\nqKG+uPuJ+1f92iH0ZY1wLB2/ITl7HKTiIMKNikXTWcUudkMlKxc5Iqb7HMHuaPZ9\nIQIDAQAB\n-----END PUBLIC KEY-----"
        }
      }
    '';
    webfinger = pkgs.writeText "webfinger-acct-jb55" ''
      {
        "subject": "acct:jb55@jb55.com",
        "aliases": [
          "https://jb55.com"
        ],
        "links": [
          {
            "rel": "http://webfinger.net/rel/profile-page",
            "type": "text/html",
            "href": "https://jb55.com"
          },
          {
            "rel": "self",
            "type": "application/activity+json",
            "href": "https://jb55.com"
          }
        ]
      }
    '';
in
{
  imports = [
    ./networking
    ./hardware
    (import ./nginx extra)
    #(import ./sheetzen extra)
    #(import ./vidstats extra)
  ];

  services.xinetd.enable = true;
  services.xinetd.services =
  [
    { name = "gopher";
      port = 70;
      server = "${pkgs.gophernicus}/bin/in.gophernicus";
      serverArgs = "-h jb55.com -nf -r /var/gopher";
      extraConfig = ''
        disable = no
      '';
    }
  ];

  users.extraGroups.jb55cert.members = [ "prosody" "nginx" ];
  users.extraGroups.vmail.members = [ "jb55" ];

  services.gitDaemon.basePath = "/var/git-public/repos";
  services.gitDaemon.enable = true;

  services.radicale.enable = true;
  services.radicale.config = ''
    [auth]
    type = htpasswd
    htpasswd_filename = /home/jb55/.config/radicale/users
    htpasswd_encryption = plain
    delay = 1

    [storage]
    filesystem_folder = /home/jb55/.config/radicale/data

    [server]
    hosts = 127.0.0.1:5232
    ssl = False
    max_connections = 20

    # 1 Megabyte
    max_content_length = 10000000

    timeout = 10

    [rights]
    type = from_file
    file = ${radicale-rights}
  '';

  security.acme.certs."jb55.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    allowKeysForGroup = true;
    #postRun = "systemctl restart prosody";
    email = myemail;
  };

  security.acme.certs."git.jb55.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    allowKeysForGroup = true;
    email = myemail;
  };

  security.acme.certs."openpgpkey.jb55.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    allowKeysForGroup = true;
    email = myemail;
  };

  security.acme.certs."sheetzen.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    allowKeysForGroup = true;
    email = myemail;
  };

  security.acme.certs."bitcoinwizard.net" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    allowKeysForGroup = true;
    email = myemail;
  };

  services.mailz = {
    enable = true;
    domain = "jb55.com";

    users = {
      jb55 = {
        password = "$6$KHmFLeDBaXBE1Jkg$eEN8HM3LpZ4muDK/JWC25qW9xSZq0AqsF4tlzEan7yctROJ9A/lSqz6gN1b1GtwE7efroXGHtDi2FEJ2ujDAl0";
        aliases = [ "postmaster" "bill" "will" "william" "me" "jb" "guestdaddy" ];
      };

    };

    sieves = builtins.readFile ./dovecot/filters.sieve;
  };

  users.extraUsers.prosody.extraGroups = [ "jb55cert" ];
  services.prosody.enable = true;
  services.prosody.admins = [ "jb55@jb55.com" ];
  services.prosody.allowRegistration = false;
  services.prosody.extraModules = xmpp_modules;
  services.prosody.package = pkgs.prosody.override { 
	withCommunityModules = xmpp_modules; 
  };
  services.prosody.extraConfig = ''
    c2s_require_encryption = true
 
    http_upload_expire_after = 60 * 60 * 24 * 7
  '';
  services.prosody.ssl = {
    cert = "/var/lib/acme/jb55.com/fullchain.pem";
    key = "/var/lib/acme/jb55.com/key.pem";
  };
  services.prosody.virtualHosts.jb55 = {
    enabled = true;
    domain = "jb55.com";
    ssl = {
      cert = "/var/lib/acme/jb55.com/fullchain.pem";
      key = "/var/lib/acme/jb55.com/key.pem";
    };
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5";
    package = pkgs.postgresql95;
    enable = false;
    enableTCPIP = true;
    authentication = ''
      # type db  user address        method
      local  all all                 trust
      host   all all  172.24.0.0/16  trust
      host   all all  127.0.0.1/16  trust
    '';
    #extraConfig = ''
    #  listen_addresses = '${extra.ztip}'
    #'';
  };

  systemd.services.npmrepo = {
    description = "npmrepo.com";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${npmrepo}/bin/npm-repo-proxy";
  };

  systemd.services.gaufre = {
    description = "personal gopher proxy";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${gaufre}/bin/gaufre 7070";
  };

  services.fcgiwrap.enable = true;

  services.nginx.httpConfig = ''
    ${gitCfg}

    server {
      listen 443 ssl;
      server_name bitcoinwizard.net;
      root /home/jb55/www/coretto.io;
      index index.html;

      ssl_certificate /var/lib/acme/bitcoinwizard.net/fullchain.pem;
      ssl_certificate_key /var/lib/acme/bitcoinwizard.net/key.pem;

      location / {
        try_files $uri $uri/ =404;
      }

      location /email {
        gzip off;
        # fcgiwrap is set up to listen on this host:port
        fastcgi_pass                  unix:${config.services.fcgiwrap.socketAddress};
        include                       ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /home/jb55/www/coretto.io/emailform.py;

        client_max_body_size 512;

        # export all repositories under GIT_PROJECT_ROOT

        fastcgi_param PATH_INFO           $uri;
      }


    }

    server {
      listen 443 ssl;
      server_name www.bitcoinwizard.net;
      return 301 https://bitcoinwizard.net$request_uri;
    }

    server {
      listen 80;
      server_name bitcoinwizard.net www.bitcoinwizard.net;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location / {
        return 301 https://bitcoinwizard.net$request_uri;
      }
    }

    server {
      listen 80;
      server_name git.jb55.com;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      root /var/git-public/stagit;
      index index.html index.htm;

      # location / {
      #   return 301 https://git.jb55.com$request_uri;
      # }
    }

    # server {
    #   listen       443 ssl;
    #   server_name  git.jb55.com;

    #   root /var/git-public/stagit;
    #   index index.html index.htm;

    #   ssl_certificate /var/lib/acme/git.jb55.com/fullchain.pem;
    #   ssl_certificate_key /var/lib/acme/git.jb55.com/key.pem;
    # }

    server {
      listen 80;
      server_name openpgpkey.jb55.com;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }
    }

    server {
      listen 443 ssl;
      server_name openpgpkey.jb55.com;

      ssl_certificate /var/lib/acme/openpgpkey.jb55.com/fullchain.pem;
      ssl_certificate_key /var/lib/acme/openpgpkey.jb55.com/key.pem;

      location /.well-known/openpgpkey/jb55.com/hu/9adqqiba8jxrhu5wf18bfapmnwjk5ybo {
        alias ${pgpkeys};
      }
    }

    server {
      listen 443 ssl;
      server_name jb55.com;
      root /www/jb55/public;
      index index.html index.htm;

      ssl_certificate /var/lib/acme/jb55.com/fullchain.pem;
      ssl_certificate_key /var/lib/acme/jb55.com/key.pem;

      rewrite ^/pkgs.tar.gz$ https://github.com/jb55/jb55pkgs/archive/master.tar.gz permanent;
      rewrite ^/pkgs/?$ https://github.com/jb55/jb55pkgs/archive/master.tar.gz permanent;

      location / {
        gzip on;
        gzip_types application/json;

        error_page 418 = @jb55activity;

        if ( $http_accept ~ "application/activity\+json" ) { return 418; }

        try_files $uri $uri/ =404;
      }

      location ~ ^/[01] {
        proxy_pass  http://localhost:7070;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
        proxy_buffering off;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      }

      location /phlog {
        autoindex on;
      }

      location @jb55activity {
         root /;
         default_type application/activity+json;
         try_files ${jb55-activity} =404;
      }

      location = /.well-known/webfinger {
         error_page 418 = @jb55webfinger;
         if ( $query_string = "resource=acct:jb55@jb55.com" ) { return 418; }
         return 404;
      }

      location @jb55webfinger {
         root /;
         default_type application/jrd+json;
         try_files ${webfinger} =404;
      }

      location /cal/ {
        proxy_pass        http://127.0.0.1:5232/;
        proxy_set_header  X-Script-Name /cal;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
      }

      location ^~ /files/calls {
        error_page 405 =200 $uri;
      }
    }

    server {
      listen 80;
      server_name jb55.com www.jb55.com;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location ~ ^/[01] {
        proxy_pass  http://localhost:7070;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
        proxy_buffering off;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      }

      location / {
        return 301 https://jb55.com$request_uri;
      }
    }
    server {
      listen 443 ssl;
      server_name www.jb55.com;
      return 301 https://jb55.com$request_uri;
    }

  '';

}
