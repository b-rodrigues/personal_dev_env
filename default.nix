{ pkgs ? import (fetchTarball "https://github.com/b-rodrigues/nixpkgs/archive/bab0aa0f13586cef832226ecd2a7ef9fe6ca28ff.tar.gz") {} }:

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
          covr
          data_table
          desc
          diffviewer
          DT
          flexdashboard
          fusen
          ggridges
          htmltools
          httpgd
          quarto
          janitor
          openxlsx
          reactable
          rhub
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
               rev = "7535ed4d3b14c657744433577151a28e058ac33d";
               sha256 = "sha256-8wLHAs7Z+ErHVh+/mTaU4C2M2N+u6k/s/r9WZ6CWqIc=";
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
 
