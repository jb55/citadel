extra:
{ config, lib, pkgs, ... }:
let mkfont = n: lesrc:
               pkgs.stdenv.mkDerivation rec {
                 name = "${n}-${version}";
                 src = pkgs.fetchurl lesrc;
                 version = "1.0";
                 phases = ["installPhase"];

                 installPhase = ''
                   mkdir -p $out/share/fonts/${n}
                   cp -v ${src} $out/share/fonts/${n}
                 '';
               };
    aldrich =
      mkfont "aldrich" {
        url = "https://jb55.com/s/bef303d9e370f941.ttf";
        sha256 = "ecc2fbf1117eed2d0b1bf32ee8624077577d568f1c785699353416b67b519227";
      };
    VarelaRound-Regular =
      mkfont "VarelaRound-Regular" {
        url = "https://jb55.com/s/c8bbd8415dea995f.ttf";
        sha256 = "c4327a38270780eb03d305de3514de62534262c73f9e7235eea6ce26904c2dc5";
      };
    Bookerly-Regular =
      mkfont "Bookerly-Regular" {
        url = "https://jb55.com/s/Bookerly-Regular.ttf";
        sha256 = "1db94d4ab763f812b3fe505c02cdeb0927251c118cc65322be23eb93a70eafd7";
      };
    Bookerly-RegularItalic =
      mkfont "Bookerly-RegularItalic" {
        url = "https://jb55.com/s/Bookerly-RegularItalic.ttf";
        sha256 = "6e364837e08fa89c0fed287a13c7149567ab5657847f666e45e523ecc9c7820b";
      };
    Bookerly-Bold =
      mkfont "Bookerly-Bold" {
        url = "https://jb55.com/s/Bookerly-Bold.ttf";
        sha256 = "367a28ceb9b2c79dbe5956624f023a54219d89f31d6d2e81e467e202273d40da";
      };
    Bookerly-BoldItalic =
      mkfont "Bookerly-BoldItalic" {
        url = "https://jb55.com/s/Bookerly-BoldItalic.ttf";
        sha256 = "d975e3260e26f1b33fc50b00540caece84a0800e9bc900922cf200645e79693f";
      };
    Questrial =
      mkfont "Questrial" {
        url = "https://jb55.com/s/1ccac9ff5cb42fd7.ttf";
        sha256 = "294729bb4bf3595490d2e3e89928e1754a7bfa91ce91e1e44ecd18c974a6dbbc";
      };
    Comfortaa-Regular =
      mkfont "Comfortaa-Regular" {
        url = "https://jb55.com/s/a266c50144cbad1a.ttf";
        sha256 = "db5133b6a09c8eba78b29dc05019d8f361f350483d679fd8c668e1c657a303fc";
      };
    Nunito-Regular =
      mkfont "Nunito-Regular" {
        url = "https://jb55.com/s/Nunito-Regular.ttf";
        sha256 = "9e2747806c4a30f0d4f39596a13dd97dc5484b96845d945d90b300e1bbdebc72";
      };
    Nunito-Bold =
      mkfont "Nunito-Bold" {
        url = "https://jb55.com/s/Nunito-Bold.ttf";
        sha256 = "8b9e27ba172e5b535b1d0564b4882f74aecc77a4dc4d20fc400bd2b2bc4418c1";
      };
    Nunito-Light =
      mkfont "Nunito-Light" {
        url = "https://jb55.com/s/Nunito-Light.ttf";
        sha256 = "25d4c5a89428f032e3851eed4f903a1c800c2bde74f3893f3ac62782ed67cfbf";
      };
    Nunito-ExtraLight =
      mkfont "Nunito-ExtraLight" {
        url = "https://jb55.com/s/Nunito-ExtraLight.ttf";
        sha256 = "5a45507eb9ab280700c0da004905c0ac9d774124a10be71cb650ce3e66983113";
      };

    ohsnap =
      pkgs.stdenv.mkDerivation rec {
        name = "ohsnap-${version}";
        version = "1.7.9";

        src = pkgs.fetchzip {
          url = "https://sourceforge.net/projects/osnapfont/files/${name}.tar.gz";
          sha256 = "0jvgii1sdv3gzmx8k68bd3fp2rmfsdigg67spbi2c83krb1x445v";
        };

        phases = ["unpackPhase" "installPhase"];

        installPhase = ''
          mkdir -p $out/share/fonts/ohsnap
          cp ${src}/* $out/share/fonts/ohsnap
        '';
      };

    myfonts = [ aldrich VarelaRound-Regular Questrial Comfortaa-Regular
                Bookerly-Regular Bookerly-RegularItalic Bookerly-Bold Bookerly-BoldItalic 
		ohsnap Nunito-Regular Nunito-Bold Nunito-Light Nunito-ExtraLight ];
in
{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fontconfig.defaultFonts.serif = [ "Bookerly" ];
    fontconfig.defaultFonts.monospace  = [ "IBM Plex Mono" ];
    fontconfig.defaultFonts.sansSerif  = [ "Noto Sans" ];
    enableDefaultFonts = if extra.is-minimal then false else true;
    fonts = if extra.is-minimal then [pkgs.terminus_font] else (with pkgs; [
      aldrich
      corefonts
      # emojione
      fira-code
      fira-mono
      inconsolata
      ipafont
      kochi-substitute
      libertinus
      ibm-plex
      noto-fonts
      noto-fonts-emoji
      opensans-ttf
      raleway
      profont
      terminus_font
      paratype-pt-mono
      source-code-pro
      ubuntu_font_family
      proggyfonts
    ] ++ myfonts);
  };
}
