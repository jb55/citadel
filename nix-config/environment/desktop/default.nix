{ userConfig, theme, icon-theme, extra }:
{ config, lib, pkgs, ... }:
let gtk2rc = pkgs.writeText "gtk2rc" ''
      gtk-icon-theme-name = "${icon-theme.name}"
      gtk-theme-name = "${theme.name}"
    '';

    jb55pkgs = import <jb55pkgs> { inherit pkgs; };

    jbpkgs = with jb55pkgs; [
       snap
       #cmdtree
       #zoom-link-opener
       x11-rename
       #hoogle-zen
       #viscal
    ];
    
    aitools = [];
    #aitools = (with inputs.llm-agents.packages.${pkgs.system}; [
    #  claude-code
    #]);

    df = pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
       #dfVersion = "0.44.11";
       enableIntro = false;
       enableFPS = false;
       enableDFHack = false;
       enableTextMode = false;
       theme = "cla";
    };

    mypkgs = (with pkgs; [
      #blender
      clipmenu
      xcolor
      chromium
      #colorpicker
      dasht
      dmenu
      dunst
      dynamic-colors
      feh
      getmail6 # for getmail-gmail-xoauth-tokens
      gnome-calculator
      gtk-engine-murrine
      hwi
      lagrange
      lastpass-cli
      libnotify
      mpv
      msmtp
      muchsync
      neomutt
      notmuch
      oath-toolkit
      obs-studio
      pamixer
      pavucontrol
      pinentry-gnome3
      postgresql # psql
      qalculate-gtk
      qutebrowser
      rxvt-unicode
      recoll
      signal-desktop
      simplescreenrecorder
      slock
      sxiv
      todo-txt-cli
      #tdesktop
      userConfig
      vdirsyncer
      w3m
      wmctrl
      xautolock
      xbindkeys
      xclip
      xdotool
      dragon-drop
      xorg.xev
      xorg.xmodmap
      xorg.xset
      zathura
      zoom-us

      #aerc 
      #bitcoin     --- probably don't want a binary substitute of this
      #khal
      #python37Packages.trezor
      #texlive.combined.scheme-full
      #steam
      #wine
      #df
    ]) ++ jbpkgs ++ aitools;

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
    #GTK2_RC_FILES = "${gtk2rc}:${theme.package}/share/themes/${theme.name}/gtk-2.0/gtkrc:$GTK2_RC_FILES";
    #GTK_DATA_PREFIX = "${theme.package}";
    #GTK_EXEC_PREFIX = "${theme.package}";
    #GTK_IM_MODULE = "xim";
    #GTK_PATH = "${theme.package}:${pkgs.gtk3.out}";
    #GTK_THEME = "${theme.name}";
    QT_STYLE_OVERRIDE = "GTK+";
    #VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"; # radv
  };

  programs.steam.enable = true;
  programs.steam.extraPackages = [ pkgs.xorg.libXScrnSaver ];
  programs.gamemode.enable = true;

  environment.systemPackages = if extra.is-minimal then (with pkgs; [
    #steam
    #steam-run
    #wine
    
    #lastpass-cli
    rxvt-unicode
  ]) else mypkgs;

  programs.slock.enable = true;
}
