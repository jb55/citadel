pkgs: rec {
  hostId = "d7ee0243"; # needed for zfs
  ztip = "10.100.0.1";
  subnet = "192.168.86.1/24";
  ip = "192.168.86.25";
  nix-serve = {
    port = 10845;
    bindAddress = ztip;
  };
  sessionCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr -r 240
    ${pkgs.xorg.xgamma}/bin/xgamma -gamma 0.8
  '';

}
