FROM rocker/tidyverse
MAINTAINER Eric T Dawson

ENTRYPOINT /bin/bash
ADD install_pkgs.r /usr/bin/
RUN Rscript /usr/bin/install_pkgs.r
