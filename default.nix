{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/8a2df89b69678ef20c7376d93a33f6af825a2bb7.tar.gz") {} }:

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
          arrow
          blogdown
          bookdown
          chronicler
          data_table
          desc
          flexdashboard
          #fusen
          (buildRPackage {
             name = "fusen";
             src = fetchgit {
               url = "https://github.com/ThinkR-open/fusen/";
               branchName = "main";
               rev = "d617172447d2947efb20ad6a4463742b8a5d79dc";
               sha256 = "sha256-TOHA1ymLUSgZMYIA1a2yvuv0799svaDOl3zOhNRxcmw=";
          };
          propagatedBuildInputs = [
            attachment
            cli
            desc
            devtools
            glue
            here 
            magrittr
            parsermd 
            roxygen2
            stringi
            tibble
            tidyr
            usethis
            yaml
             ];
          })
          (buildRPackage {
             name = "rix";
             src = fetchgit {
               url = "https://github.com/b-rodrigues/rix/";
               branchName = "master";
               rev = "ae39d2142461688b1be41db800752a949ebb3c7b";
               sha256 = "sha256-rOhFnc01CzRE6Hl73xGvaE/bQCoX0d5tZ10jzAoqQ7g=";
          };
          propagatedBuildInputs = [
            httr
            jsonlite
            sys
             ];
          }) 
          ggridges
          httpgd
          janitor
          openxlsx
          reactable
          skimr
          tarchetypes
          targets
          tidyverse
        ];
  };

  other_pkgs = [
        quarto
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
 