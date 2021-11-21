{ config, lib, pkgs, ... }:
{
  services.nginx.httpConfig = ''
      server {
        listen      80 default_server;
        server_name _;
        index index.html index.htm;
        location / {
          try_files $uri $uri/ =404;
        }
      }
  '';
}
