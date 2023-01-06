extra:
{ config, lib, pkgs, ... }:
let gitExtra = {
      git = {projectroot = "/var/git-public/repos";};
      host = "git.jb55.com";
    };
    radicale_data = "/var/radicale/data";
    httpipePort = "8899";
    # httpiped = (import (pkgs.fetchgit {
    #   url = https://github.com/jb55/httpipe;
    #   rev = "376de0e37bba505ba5f23c46435277bb74603acd";
    #   sha256 = "1x9d98z6zbs22x38xwxjnb6mwladbah9xajyl7kk8bm418l8wac4";
    # }) { nodejs = pkgs.nodejs; }).package;
    npmrepo = (import (pkgs.fetchFromGitHub {
      owner  = "jb55";
      repo   = "npm-repo-proxy";
      rev    = "5bb651689c9e74299094ac989125685c810ee9b2";
      sha256 = "16cjcz2cakrgl3crn63s5w1k4h4y51h8v0326v5bim8r1hxrpq4n";
    }) {}).package;

    lnurl-commando = (import (pkgs.fetchFromGitHub {
      owner  = "jb55";
      repo   = "lnurl-commando";
      rev    = "1abfb1d03c49be2c73517f3f576fe5299952a077";
      sha256 = "0h4s1aqvydaj32ahjx4x9f28s8z7dxwsmf0knajmb6fidgyjxj7p";
    }) {}).package;

    ln-proxy-port = "8777";
    sendsats-port = "8193";

    ln-ws-proxy = (import (pkgs.fetchFromGitHub {
      owner = "jb55";
      repo  = "ln-ws-proxy";
      rev   = "d201ba9f4f8a7c55e97c2c718837cccca7e50338";
      sha256 = "1j43mzm0g0051n5lb231vmkxg75v0bdx0pqprix24xav5jw2a19c";
    }) {}).package;
    
    sendsatslol = (import (pkgs.fetchzip {
      url = "https://jb55.com/s/sendsatslol.tar.gz";
      sha256 = "11jn5sxppc62zpck9i9cqalh5par33xxkm8qlxb7xscykr3qdfv4";
    }) {}).package;

    pgpkeys = pkgs.fetchurl {
      url = "https://jb55.com/s/329bdbb1552cf060.pub";
      sha256 = "91ec02a43317289057c3f7c4f4129558ae799a4789a98bda0fd9360142096731";
    };

    laser-eyes = pkgs.fetchurl {
      url = "https://jb55.com/s/laser-eyes.png";
      sha256 = "b4c54a631168a3d970c7cb89e3753ecc02f8850ad381b9c0b41979e3a248ca3f";
    };

    nip05 = pkgs.writeText "nip05.json" ''
    {
      "names": {
        "jb55": "32e1827635450ebb3c5a7d12c1f8e7b2b514439ac10a67eef3d9fd9c5c68e245",
        "notepad": "4570d7a0b49b5524797120810116a2a5c18281423b173a557056f08f15c5382d",
        "clightning": "9630f464cca6a5147aa8a35f0bcdd3ce485324e732fd39e09233b1d848238f31",
        "minebot": "6cad545430904b84a8101c5783b65043f19ae29d2da1076b8fc3e64892736f03",
        "gpt3": "5c10ed0678805156d39ef1ef6d46110fe1e7e590ae04986ccf48ba1299cb53e2",
        "_": "32e1827635450ebb3c5a7d12c1f8e7b2b514439ac10a67eef3d9fd9c5c68e245"
      },

      "relays": {
        "32e1827635450ebb3c5a7d12c1f8e7b2b514439ac10a67eef3d9fd9c5c68e245": ["wss://relay.damus.io"],
        "4570d7a0b49b5524797120810116a2a5c18281423b173a557056f08f15c5382d": ["wss://relay.damus.io"],
        "9630f464cca6a5147aa8a35f0bcdd3ce485324e732fd39e09233b1d848238f31": ["wss://relay.damus.io"],
        "6cad545430904b84a8101c5783b65043f19ae29d2da1076b8fc3e64892736f03": ["wss://relay.damus.io"],
        "5c10ed0678805156d39ef1ef6d46110fe1e7e590ae04986ccf48ba1299cb53e2": ["wss://relay.damus.io"]
      }
    }
    '';

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
      permissions = rw

      # Give owners read-write access to everything else:
      [owner-write]
      user = .+
      collection = {user}/[^/]+
      permissions = rw

      # Everyone can read the root collection
      [read]
      user = .*
      collection = .*
      permissions = R
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

  users.extraGroups.jb55cert.members = [ "prosody" "nginx" "radicale" ];
  users.extraGroups.vmail.members = [ "jb55" ];

  services.gitDaemon.basePath = "/var/git-public/repos";
  services.gitDaemon.enable = true;

  users.users = {
    git = {
      uid = config.ids.uids.git;
      description = "Git daemon user";
    };
  };

  users.groups = {
    git.gid = config.ids.gids.git;
  };

  services.radicale.enable = true;

  services.radicale.settings.storage.filesystem_folder = "/var/radicale/data";
  services.radicale.settings.auth.type = "htpasswd";
  services.radicale.settings.auth.htpasswd_filename = "${extra.private.radicale.users}";
  services.radicale.settings.auth.htpasswd_encryption = "plain";
  services.radicale.settings.auth.delay = "1";
  services.radicale.settings.server.hosts = "127.0.0.1:5232";
  services.radicale.settings.server.ssl = "False";
  services.radicale.settings.server.max_connections = "20";
  services.radicale.settings.server.max_content_length = "10000000";
  services.radicale.settings.server.timeout = "10";
  services.radicale.settings.rights.type = "from_file";
  services.radicale.settings.rights.file = "${radicale-rights}";

  security.acme.acceptTerms = true;

  security.acme.certs."jb55.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    #postRun = "systemctl restart prosody";
    email = myemail;
  };

  security.acme.certs."cln.jb55.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    #postRun = "systemctl restart prosody";
    email = myemail;
  };

  security.acme.certs."git.jb55.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    email = myemail;
  };

  security.acme.certs."openpgpkey.jb55.com" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
    email = myemail;
  };

  #security.acme.certs."sheetzen.com" = {
  #  webroot = "/var/www/challenges";
  #  group = "jb55cert";
  #  email = myemail;
  #};

  security.acme.certs."bitcoinwizard.net" = {
    webroot = "/var/www/challenges";
    group = "jb55cert";
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

  users.extraUsers.smtpd.extraGroups = [ "jb55cert" ];
  users.extraUsers.jb55.extraGroups = [ "jb55cert" ];
  #users.extraUsers.prosody.extraGroups = [ "jb55cert" ];

  services.prosody.enable = false;
  services.prosody.xmppComplianceSuite = false;
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

  systemd.services.sendsatslol = {
    description = "sendsatslol";

    wantedBy = [ "multi-user.target" ];

    environment = {
      PORT = sendsats-port;
    };

    serviceConfig.Restart = "always";
    serviceConfig.WorkingDirectory = "/www/sendsats.lol";
    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${sendsatslol}/lib/node_modules/sendsats.lol/sendsats";
  };

  systemd.services.ln-ws-proxy = {
    description = "ln-ws-proxy";

    wantedBy = [ "multi-user.target" ];

    environment = {
      PORT = ln-proxy-port;
    };

    serviceConfig.Restart = "always";
    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${ln-ws-proxy}/lib/node_modules/ln-ws-proxy/ln-ws-proxy";
  };

  systemd.services.lnurl-commando = {
    description = "lnurl-commando";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = ''
    ${lnurl-commando}/lib/node_modules/lnurl-commando/lnurl-commando --nodeid 03f3c108ccd536b8526841f0a5c58212bb9e6584a1eb493080e7c1cc34f82dad71 --host 24.84.152.187:443 --rune 'CFZ1H1X34ZjHYEciNUNeFLSLlz-KM6jTJF4UpejtQZM9MTEmbWV0aG9kPWludm9pY2U=' --callback 'https://jb55.com/pr' --description "jb55's lightning address" --longDescription "Welcome to my clightning-powered lightning address. Any donation is greatly appreciated!" --thumbnail ${laser-eyes} --identifier "jb55@jb55.com" 
    '';
  };

  systemd.services.npmrepo = {
    description = "npmrepo.com";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${npmrepo}/bin/npm-repo-proxy";
  };

  services.fcgiwrap.enable = true;

  services.nginx.httpConfig = ''
    limit_req_zone $binary_remote_addr zone=email_form:10m rate=3r/m;
    limit_req_zone $binary_remote_addr zone=payreq:10m rate=10r/m;


    server {
      listen 443 ssl;
      listen [::]:443 ssl;

      server_name bitcoinwizard.net;
      root /www/bitcoinwizard.net;
      index index.html;

      ssl_certificate /var/lib/acme/bitcoinwizard.net/fullchain.pem;
      ssl_certificate_key /var/lib/acme/bitcoinwizard.net/key.pem;

      location / {
        try_files $uri $uri/ =404;
      }

      location /email {
        limit_req zone=email_form;
        gzip off;
        # fcgiwrap is set up to listen on this host:port
        fastcgi_pass                  unix:${config.services.fcgiwrap.socketAddress};
        include                       ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME /www/bitcoinwizard.net/emailform.py;

        client_max_body_size 512;

        # export all repositories under GIT_PROJECT_ROOT

        fastcgi_param PATH_INFO           $uri;
      }

    }

    server {
      listen 80;
      listen [::]:80;

      server_name cdn.jb55.com;

      location / {
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Expose-Headers' 'Content-Length' always;

        autoindex on;
        root /www/cdn.jb55.com;
      }
    }

    server {
      listen 80;
      listen [::]:80;

      server_name damus.io;

      location / {
        autoindex on;
        root /www/damus.io;
      }

      location /code {
        return 301 https://github.com/damus-io;
      }
    }

    server {
      listen 80;
      listen [::]:80;

      server_name www.damus.io;
      return 301 https://damus.io$request_uri;
    }

    server {
      listen 443 ssl;
      listen [::]:443 ssl;

      server_name www.bitcoinwizard.net;
      return 301 https://bitcoinwizard.net$request_uri;
    }

    server {
      listen 80;
      listen [::]:80;

      server_name bitcoinwizard.net www.bitcoinwizard.net;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location / {
        return 301 https://bitcoinwizard.net$request_uri;
      }
    }

    server {
      listen 443 ssl;
      listen [::]:443 ssl;

    }

    server {
      listen 443 default_server ssl;
      listen [::]:443 default_server ssl;

      server_name _;
      return 444;

      ssl_certificate /var/lib/acme/jb55.com/fullchain.pem;
      ssl_certificate_key /var/lib/acme/jb55.com/key.pem;
    }

    server {
      listen 80;
      listen [::]:80;

      server_name git.jb55.com;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location ~ ^(/[^/\s]+)/?$ {
	if (-f $document_root$1/file/README.md.html) {
	  return 302 $1/file/README.md.html;
	}
	if (-f $document_root$1/file/README.html) {
	  return 302 $1/file/README.html;
	}
	if (-f $document_root$1/file/README.txt.html) {
	  return 302 $1/file/README.txt.html;
	}
	if (-f $document_root$1/log.html) {
	  return 302 $1/log.html;
	}
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
      listen [::]:80;
      server_name openpgpkey.jb55.com;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }
    }

    server {
      listen 80;
      listen [::]:80;
      server_name lnlink.org www.lnlink.org tls.lnlink.org;
      root /www/jb55/public/lnlink/link;
    }

    server {
      listen 80;
      listen [::]:80;
      server_name proxy.lnlink.org;

      location / {
        proxy_pass http://127.0.0.1:${ln-proxy-port};
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
      }
    }

    server {
      listen 80;
      listen [::]:80;
      server_name lnlink.app;
      root /www/jb55/public/lnlink;
    }

    server {
      listen 443 ssl;
      listen [::]:443 ssl;
      server_name openpgpkey.jb55.com;

      ssl_certificate /var/lib/acme/openpgpkey.jb55.com/fullchain.pem;
      ssl_certificate_key /var/lib/acme/openpgpkey.jb55.com/key.pem;

      location = /.well-known/openpgpkey/jb55.com/hu/9adqqiba8jxrhu5wf18bfapmnwjk5ybo {
        alias ${pgpkeys};
      }
    }

    server {
      listen 80;
      listen [::]:80;
      
      server_name sendsats.lol;

      location / {
        index index.html;
        root /www/sendsats.lol/public;
      }

      location /.well-known/lnurlp {
        proxy_set_header Host $host;
        proxy_redirect off;
        proxy_pass http://127.0.0.1:${sendsats-port}$request_uri;
      }

      location ~ /@ {
        proxy_set_header Host $host;
        proxy_redirect off;
        proxy_pass http://127.0.0.1:${sendsats-port}$request_uri;
      }


    }

    server {
      listen 80;
      listen [::]:80;

      server_name www.sendsats.lol;

      location / {
        return 301 https://sendsats.lol$request_uri;
      }
    }

    server {
      listen 443 ;
      listen [::]:443 ;

      server_name jb55.com;
      root /www/jb55/public;
      index index.html index.htm;

      ssl_certificate /var/lib/acme/jb55.com/fullchain.pem;
      ssl_certificate_key /var/lib/acme/jb55.com/key.pem;

      rewrite ^/pkgs.tar.gz$ https://github.com/jb55/jb55pkgs/archive/master.tar.gz permanent;
      rewrite ^/pkgs/?$ https://github.com/jb55/jb55pkgs/archive/master.tar.gz permanent;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location /.well-known/lnurlp/jb55/ {
        proxy_set_header Host $host;
        proxy_redirect off;
        proxy_pass http://127.0.0.1:8083/;
      }

      location /pr/ {
        limit_req zone=payreq;

        proxy_set_header Host $host;
        proxy_redirect off;
        proxy_pass http://127.0.0.1:8083/;
      }

      location /inbox {
        proxy_set_header Host $host;
        proxy_redirect off;
        proxy_pass http://127.0.0.1:5188/inbox;
      }

      location / {
        gzip on;
        gzip_types application/json application/wasm;
        charset utf-8;

        proxy_set_header Host $host;
        proxy_redirect off;

        if ( $http_accept ~ "application/activity\+json" ) { 
		proxy_pass http://127.0.0.1:5188;
	}

        if ( $http_accept ~ "application/ld\+json" ) { 
		proxy_pass http://127.0.0.1:5188;
	}

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

      location = /saylor-saif {
        return 302 https://episodes.castos.com/5ffc6bf0bf71b5-21733898/34.-Michael-Saylor-on-The-Fiat-Standard.mp3;
      }

      location = /attack {
        return 302 https://nakamotoinstitute.org/mempool/speculative-attack/;
      }

      location = /social {
        return 302 https://bitcoinhackers.org/users/jb55;
      }

      location = /tftc {
        return 302 https://www.youtube.com/watch?v=_Y_Mlk__KR0;
      }

      location /phlog {
        autoindex on;
      }

      location /.well-known/webfinger {
        proxy_pass         http://localhost:5188/;
        proxy_redirect     off;
	proxy_set_header   Host $host;
      }

      location = /.well-known/openpgpkey/jb55.com/hu/9adqqiba8jxrhu5wf18bfapmnwjk5ybo {
        add_header Access-Control-Allow-Origin *;
        alias ${pgpkeys};
      }

      location = /.well-known/nostr.json {
        add_header Access-Control-Allow-Origin *;
        alias ${nip05};
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
      listen 443 ssl;
      listen [::]:443 ssl;

      server_name cln.jb55.com;

      ssl_certificate /var/lib/acme/cln.jb55.com/fullchain.pem;
      ssl_certificate_key /var/lib/acme/cln.jb55.com/key.pem;

      location / {
        proxy_pass http://24.84.152.187:8324;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
      }
    }

    server {
      listen 80;
      listen [::]:80;

      server_name cln.jb55.com;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location / {
        return 301 https://cln.jb55.com$request_uri;
      }
    }

    server {
      listen 80;
      listen [::]:80;

      server_name jb55.com www.jb55.com;

      location /.well-known/acme-challenge {
        root /var/www/challenges;
      }

      location / {
        return 301 https://jb55.com$request_uri;
      }
    }

  '';

}
