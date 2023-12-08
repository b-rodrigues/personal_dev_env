{ pkgs ? import (fetchTarball "https://github.com/b-rodrigues/nixpkgs/archive/06b93631a20bc9c1e73d7b5c706af12ee01922aa.tar.gz") {} }:

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
               rev = "ea92a88ecdfc2d74bdf1dde3e441d008521b1756";
               sha256 = "sha256-fKNtFaWPyoiS7xOOlhjok3Ddqsij7CymoKAeTT8ygIU=";
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
 
