extra:
{ config, lib, pkgs, ... }:
let logDir = "/var/log/nginx";

    damus-api = (import (pkgs.fetchFromGitHub {
      owner  = "damus-io";
      repo   = "api";
      rev    = "68a4aafbf284ec2281e1a842177c8fd1386586c1";
      sha256 = "sha256-fxDrV2J8DtwVlU9hq2DRkQGLrarJMh3VxifouQeryEU=";
    }) {}).package;

    damus-api-port = 4000;
    damus-api-staging-port = 4001;
    damus-api-service = {env, port, db}: {
      description = "damus-api-${env}";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
      serviceConfig.ExecStart = "${damus-api}/bin/damus-api";

      environment = {
        PORT="${toString port}";
        DEEPL_KEY=extra.private.deepl_key;
        LN_NODE_ID=extra.private.ln_node_id;
        LN_NODE_ADDRESS=extra.private.ln_node_address;
        LN_RUNE=extra.private.ln_rune;
        LN_WS_PROXY=extra.private.ln_ws_proxy;
        DB_PATH=db;
      };
    };
in {
  systemd.services.damus-api-staging = damus-api-service {
    env = "staging";
    port = damus-api-staging-port;
    db = "/home/purple/api/staging";
  };

  systemd.services.damus-api = damus-api-service {
    env = "production";
    port = damus-api-port;
    db = "/home/purple/api/production";
  };

  services.nginx = {
    enable = true;

    config = ''
      worker_processes 2;

      events {
      	worker_connections 768;
        # multi_accept on;
      }
    '';

    httpConfig = ''
      port_in_redirect off;
      ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
      ssl_prefer_server_ciphers on;

      # HSTS (ngx_http_headers_module is required) (15768000 seconds = 6 months)
      add_header Strict-Transport-Security max-age=15768000;

      sendfile on;
      tcp_nopush on;
      tcp_nodelay on;
      keepalive_timeout 65;
      # server_tokens off;
      proxy_buffering off;
      proxy_read_timeout 300s;
      expires off;

      access_log ${logDir}/access.log;
      error_log ${logDir}/error.log;

      gzip on;
      gzip_disable "msie6";

      server {
        listen      80 default_server;
        server_name "";
        return      444;
      }

      server {
        listen 80;

        server_name api.damus.io;

        location / {
          proxy_pass http://localhost:${toString damus-api-port};
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
        }
      }

      server {
        listen 80;

        server_name api.staging.damus.io;

        location / {
          proxy_pass http://localhost:${toString damus-api-staging-port};
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
        }
      }

      server {
        listen 80;

        server_name damus.io;

        location / {
          autoindex on;
          root /www/damus.io;

          add_header 'Access-Control-Allow-Origin' '*' always;
          add_header 'Access-Control-Expose-Headers' 'Content-Length' always;
        }

        location ~* "^/(?<note>note1[qpzry9x8gf2tvdw0s3jn54khce6mua7l]+)(?<end>.png)?/?$" {
          proxy_pass http://localhost:3000;
        }

        location ~* "^/(?<nevent>nevent1[qpzry9x8gf2tvdw0s3jn54khce6mua7l]+)(?<end>.png)?/?$" {
          proxy_pass http://localhost:3000;
        }

        location ~* "^/(?<pk>npub1[qpzry9x8gf2tvdw0s3jn54khce6mua7l]+)(?<end>.png)?/?$" {
          proxy_pass http://localhost:3000;
        }

        location ~* "^/(?<pk>nprofile1[qpzry9x8gf2tvdw0s3jn54khce6mua7l]+)(?<end>.png)?/?$" {
          proxy_pass http://localhost:3000;
        }

        location /github-hook {
          proxy_pass http://localhost:3111;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
        }

        location /appstore {
          return 301 https://apps.apple.com/us/app/damus/id1628663131;
        }

        location /devchat {
          return 301 https://t.me/+abMSAEO6ho8xYjdh;
        }

        location /testflight {
          return 301 https://testflight.apple.com/join/CLwjLxWl;
        }

        location /code {
          return 301 https://github.com/damus-io/damus/pulls;
        }

        location /list/patches {
          return 301 https://groups.google.com/a/damus.io/g/patches;
        }

        location /list/product {
          return 301 https://groups.google.com/a/damus.io/g/product;
        }

        location /list/design {
          return 301 https://groups.google.com/a/damus.io/g/design;
        }

        location /list/dev {
          return 301 https://groups.google.com/a/damus.io/g/dev;
        }

        location /figma {
          return 301 https://www.figma.com/file/ORaT1T0Ywfbm0sIjwy5Rgq/Damus-iOS?type=design&node-id=0-1&t=AGpDcKb6rHfpQ9CA-0;
        }

        location /merch/hat {
          return 302 http://lnlink.org/?d=ASED88EIzNU2uFJoQfClxYISu55lhKHrSTCA58HMNPgtrXECMjQuODQuMTUyLjE4Nzo4MzI0AANgB6Cj2QCeZAFOZ1nS6qGuRe4Vf6qzwJyQ5Qo3b0HRt_w9MTIwJm1ldGhvZD1pbnZvaWNlfG1ldGhvZD13YWl0aW52b2ljZSZwbmFtZWxhYmVsXmxubGluay0mcmF0ZT04BERhbXVzIEhhdAAFAALG8AZUaGFua3MgZm9yIHN1cHBvcnRpbmcgRGFtdXMhAA==;
        }

        location /merch {
          return 302 http://lnlink.org/?d=ASED88EIzNU2uFJoQfClxYISu55lhKHrSTCA58HMNPgtrXECMjQuODQuMTUyLjE4Nzo4MzI0AANgB6Cj2QCeZAFOZ1nS6qGuRe4Vf6qzwJyQ5Qo3b0HRt_w9MTIwJm1ldGhvZD1pbnZvaWNlfG1ldGhvZD13YWl0aW52b2ljZSZwbmFtZWxhYmVsXmxubGluay0mcmF0ZT04BERhbXVzIE1lcmNoAAUAAfvQBlRoYW5rcyBmb3Igc3VwcG9ydGluZyBkYW11cyEA;
        }
      }

      server {
        listen 80;
        listen [::]:80;

        server_name www.damus.io;
        return 301 https://damus.io$request_uri;
      }
    '';
  };
}
