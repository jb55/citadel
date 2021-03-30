{ userConfig, theme, icon-theme, extra }:
{ config, lib, pkgs, ... }:
let gtk2rc = pkgs.writeText "gtk2rc" ''
      gtk-icon-theme-name = "${icon-theme.name}"
      gtk-theme-name = "${theme.name}"

      binding "gtk-binding-menu" {
        bind "j" { "move-current" (next) }
        bind "k" { "move-current" (prev) }
        bind "h" { "move-current" (parent) }
        bind "l" { "move-current" (child) }
      }
      class "GtkMenuShell" binding "gtk-binding-menu"
    '';

    jb55pkgs = import <jb55pkgs> { inherit pkgs; };

    jbpkgs = with jb55pkgs; [
       snap
       cmdtree
       zoom-link-opener
       x11-rename
       viscal
    ];

    df = pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
       #dfVersion = "0.44.11";
       enableIntro = false;
       enableFPS = false;
       enableDFHack = false;
       enableTextMode = true;
    };

    mypkgs = (with pkgs; [
      aerc
      clipmenu
      colorpicker
      dmenu
      dragon-drop
      dunst
      dynamic-colors
      feh
      todo-txt-cli
      getmail # for getmail-gmail-xoauth-tokens
      gnome3.gnome-calculator
      gtk-engine-murrine
      lastpass-cli
      libnotify
      msmtp
      muchsync
      neomutt
      notmuch
      oathToolkit
      pandoc
      pavucontrol
      pinentry
      postgresql # psql
      python37Packages.trezor
      qalculate-gtk
      qutebrowser
      rxvt_unicode-with-plugins
      signal-desktop
      simplescreenrecorder
      slock
      spotify
      sxiv
      texlive.combined.scheme-full
      userConfig
      mpv
      w3m
      wine
      steam
      wmctrl
      xautolock
      xbindkeys
      xclip
      vdirsyncer
      xdotool
      xlibs.xev
      xlibs.xmodmap
      xlibs.xset
      zathura
      zoom-us

      df
    ]) ++ jbpkgs;

in {

  # latest emacs overlay
  #nixpkgs.overlays =  [
  #  (import (builtins.fetchTarball {
  #    url = https://github.com/nix-community/emacs-overlay/archive/773a9f17db9296b45e6b7864d8cee741c8d0d7c7.tar.gz;
  #    sha256 = "157klv69myjmdgqvxv0avv32yfra3i21h5bxjhksvaii1xf3w1gp";
  #  }))
  #];

  environment.variables = lib.mkIf (!extra.is-minimal) {
    LC_TIME="en_DK.UTF-8";
    GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
    GTK2_RC_FILES = "${gtk2rc}:${theme.package}/share/themes/${theme.name}/gtk-2.0/gtkrc:$GTK2_RC_FILES";
    GTK_DATA_PREFIX = "${theme.package}";
    GTK_EXEC_PREFIX = "${theme.package}";
    GTK_IM_MODULE = "xim";
    GTK_PATH = "${theme.package}:${pkgs.gtk3.out}";
    GTK_THEME = "${theme.name}";
    QT_STYLE_OVERRIDE = "GTK+";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"; # radv
  };

  environment.systemPackages = if extra.is-minimal then (with pkgs; [
    steam
    steam-run
    wine
    lastpass-cli
    rxvt_unicode-with-plugins
  ]) else mypkgs;

  security.wrappers = {
    slock.source = "${pkgs.slock}/bin/slock";
  };
}
