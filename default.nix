{ pkgs ? import (fetchTarball "https://github.com/b-rodrigues/nixpkgs/archive/8147cf10a9454e462970fbdb01e0841b93671e09.tar.gz") {} }:

  with pkgs;

let
  pkgs = rec {
    hugo_0251 = stdenv.mkDerivation {
        name = "hugo_0251";
        src = fetchFromGitHub {
          owner = "gohugoio";
          repo = "hugo";
          rev = "v0.25.1";
          sha256 = "sha256-fwU1EHwui0OflOovzIOGdwjGoVsJyX0tKrwlT46uniU=";
        };
        buildInputs = [go];
        installPhase = ''
          mkdir -p $out/bin
          cp -r . $out/bin/
        '';
      };

    r_pkgs = rWrapper.override {
        packages = with rPackages; [
          blogdown
          bookdown
          chronicler
          codemetar
          data_table
          desc
          flexdashboard
          fusen
          ggridges
          httpgd
          quarto
          janitor
          openxlsx
          reactable
          skimr
          tarchetypes
          targets
          tidyverse
          withr
          (buildRPackage {
             name = "rix";
             src = fetchgit {
               url = "https://github.com/b-rodrigues/rix/";
               branchName = "master";
               rev = "da9a95e2af3b32480d22cd7f3ec515765196b303";
               sha256 = "sha256-Q0Gwkr6dJgdi6TgRsQjgTFH1BJSiZVpB76/xpOhk7ew=";
          };
          propagatedBuildInputs = [
            codetools
            httr
            jsonlite
            sys
           ];
          }) 
        ];
  };

  other_pkgs = [
        quarto pandoc nix
  ];

  dev_env = mkShell rec {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
    name = "dev_env";
    buildInputs = [
      r_pkgs
      hugo_0251
      ] ++ other_pkgs;
  };
 };
in
 pkgs
 
