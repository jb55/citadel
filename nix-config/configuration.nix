# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let machine = extra.private.machine;
    isDesktop = machine != "purple";
    machinePath = p: let m = "/" + machine;
                     in ./machines + m + p;
    machineConfig = import (machinePath "/config") pkgs;
    userConfig = pkgs.callPackage ./nixpkgs/dotfiles.nix {
      machineSessionCommands = machineConfig.sessionCommands;
    };
    extra = {
      is-minimal = false;
      git-server = import ./misc/git-server.nix;
      util       = import ./misc/util.nix { inherit pkgs; };
      private    = import ./private.nix { inherit pkgs; };
      machine    = machineConfig;
    };
    util = extra.util;
    caches = [ "https://cache.nixos.org" ];
    composeKey = if machine == "quiver" then "ralt" else "prsc";
    home = "/home/jb55";
    isDark = true;
    bash = "${pkgs.bashInteractive}/bin/bash";
    theme = if isDark then {
      package = pkgs.theme-vertex;
      name = "Vertex-Dark";
    }
    else {
      package = pkgs.arc-theme;
      name = "Arc";
    };
    icon-theme = {
      package = pkgs.numix-icon-theme;
      name = "Numix";
    };
    user = {
        name = "jb55";
        isNormalUser = true;
        group = "users";
        uid = 1000;
        extraGroups = [ "wheel" "dialout" ];
        createHome = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAvMdnEEAd/ZQM+pYp6ZYG/1NPE/HSwIKoec0/QgGy4UlO0EvpWWhxPaV0HlNUFfwiHE0I2TwHc+KOKcG9jcbLAjCk5rvqU7K8UeZ0v/J83bQh78dr4le09WLyhczamJN0EkNddpCyUqIbH0q3ISGPmTiW4oQniejtkdJPn2bBwb3Za8jLzlh2UZ/ZJXhKvcGjQ/M1+fBmFUwCp5Lpvg0XYXrmp9mxAaO+fxY32EGItXcjYM41xr/gAcpmzL5rNQ9a9YBYFn2VzlpL+H7319tgdZa4L57S49FPQ748paTPDDqUzHtQD5FEZXe7DZZPZViRsPc370km/5yIgsEhMPKr jb55"
        ];
        home = home;
        shell = bash;
      };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./certs
      (import ./services extra)
      (import ./environment extra)
      (import ./networking machine)
      (import (machinePath "") extra)
    ] ++ (if isDesktop then [
      (import ./hardware/desktop extra)
      # ./wayland
      (import ./fonts extra)
      (import ./environment/desktop { inherit userConfig theme icon-theme extra; })
      (import ./services/desktop { inherit extra util composeKey userConfig theme icon-theme; })
    ] else []);

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  #environment.ld-linux = false;
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
    DefaultTimeoutStartSec=20s
  '';

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-chinese-addons
      fcitx5-mozc
      fcitx5-nord
    ];
  };

  i18n.extraLocaleSettings = {
    LC_TIME="en_DK.UTF-8";
  };

  documentation.nixos.enable = false;
  documentation.dev.enable = true;
  #documentation.man.generateCaches = true; # list manpages

  programs.ssh.startAgent = true;

  time.timeZone = "America/Vancouver";
  system.stateVersion = "24.11";

  nixpkgs.config = import ./nixpkgs/config.nix;

  nix.useSandbox = machine != "charon";
  nix.trustedUsers = [ "root" "jb55" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-substituters = ["https://ai.cachix.org"];
  nix.settings.trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];

  boot.blacklistedKernelModules = [ "pcspkr" ]; # STOP THE BEEPING

  users.extraUsers.jb55 = user;
  users.extraGroups.docker.members = [ "jb55" ];

  users.defaultUserShell = bash;
  users.mutableUsers = true;

  console.useXkbConfig = true;

  programs.zsh.enable = false;
  programs.direnv.enable = true;

}
