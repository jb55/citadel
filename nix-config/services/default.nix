extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    #./footswitch
    #./fail-notifier
    ./mailz
  ];

  #services.mongodb.enable = true;
  #services.redis.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";

  services.atd.enable = true;

  #services.logrotate.enable = false;
  #services.logrotate.extraConfig = ''
  #  dateext
  #  dateformat %Y-%m-%d.
  #  compresscmd ${pkgs.xz.bin}/bin/xz
  #  uncompresscmd ${pkgs.xz.bin}/bin/unxz
  #  compressext .xz
  #'';
}
