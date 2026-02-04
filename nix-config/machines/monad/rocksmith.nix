{ config, lib, pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    jack.enable = true;
  };

  ### Audio Extra
  security.rtkit.enable = true; # Enables rtkit (https://directory.fsf.org/wiki/RealtimeKit)

  # domain = "@audio": This specifies that the limits apply to users in the @audio group.
  # item = "memlock": Controls the amount of memory that can be locked into RAM.
  # value (`unlimited`) allows members of the @audio group to lock as much memory as needed. This is crucial for audio processing to avoid swapping and ensure low latency.
  #
  # item = "rtprio": Controls the real-time priority that can be assigned to processes.
  # value (`99`) is the highest real-time priority level. This setting allows audio applications to run with real-time scheduling, reducing latency and ensuring smoother performance.
  #
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
  ];

  # Add user to `audio` and `rtkit` groups.
  users.users.jb55.extraGroups = [ "audio" "rtkit" ];

  environment.systemPackages = with pkgs; [
    qjackctl
    rtaudio
  ];

  ### Steam (https://nixos.wiki/wiki/Steam)
  programs.steam.package = pkgs.steam.override {
    extraLibraries = pkgs: [ pkgs.pkgsi686Linux.pipewire.jack ]; # Adds pipewire jack (32-bit)
  };

  programs.steam.extraPackages = [ pkgs.wineasio ];
}
