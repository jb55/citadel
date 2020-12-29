pkgs: rec {
  hostId = "d7ee0243"; # needed for zfs
  ztip = "10.100.0.1";
  nix-serve = {
    port = 10845;
    bindAddress = ztip;
  };
  sessionCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr -r 144
    ${pkgs.xorg.xgamma}/bin/xgamma -gamma 0.8
  '';
}
