extra:
{ config, lib, pkgs, ... }:
{
  imports = [
  ];

  systemd.user.services.myopia-reminder = {
    enable   = true;
    description = "Myopia Reminder";

    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];

    serviceConfig.ExecStart = extra.util.writeBash "myopia-reminder" ''
      ${pkgs.libnotify}/bin/notify-send -u critical "👁"
    '';

    startAt = "*:0/20"; # every 20 minutes
  };
}
