extra:
{ config, lib, pkgs, ... }:
let sites = [./sites/jb55.com
             ./sites/npmrepo.com
             ./sites/wineparty.xyz
             ./sites/hearpress.com
            ];
    logDir = "/var/log/nginx";
in {
  services.logrotate.config = ''
    ${logDir}/*.log {
      daily
      missingok
      rotate 52
      compress
      delaycompress
      notifempty
      # 20MB
      minsize 20971520
      create 640 root adm
      sharedscripts
      postrotate
              ${pkgs.procps}/bin/pkill -USR1 nginx
      endscript
    }
  '';

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
      types_hash_max_size 2048;
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

      ${lib.concatStringsSep "\n\n" (map builtins.readFile sites)}
    '';
  };
}
