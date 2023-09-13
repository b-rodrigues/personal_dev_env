{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/976fa3369d722e76f37c77493d99829540d43845.tar.gz") {} }:

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
               rev = "0de486b5f451d98b38720042eac24f62f5638139";
               sha256 = "sha256-1znkk+5KHHBCeKN0YP6abYB5KWnxbvlgNkYj9LyS2ls=";
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
          ggridges
          httpgd
          janitor
          openxlsx
          reactable
          skimr
          tarchetypes
          targets
          tidyverse
          (buildRPackage {
             name = "rix";
             src = fetchgit {
               url = "https://github.com/b-rodrigues/rix/";
               branchName = "master";
               rev = "b8c14242f7ac4743d1cacb0de9a92cb51b7e3ece";
               sha256 = "sha256-vOJoB41DVjP2fEzR/f5p5FJOn6sw8S15aaMiS5S1FXg=";
          };
          propagatedBuildInputs = [
            httr
            jsonlite
            sys
             ];
          }) 
        ];
  };

  other_pkgs = [
        quarto pandoc
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
 
