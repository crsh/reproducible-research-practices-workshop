# Select base image
FROM rocker/rstudio:4.1.2

# System libraries
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libgsl0-dev \
  libnlopt-dev \
  libxt6 \
  ssh

# TeX Live
ENV CTAN_REPO=http://mirror.ctan.org/systems/texlive/tlnet
RUN /rocker_scripts/install_texlive.sh
ENV PATH=$PATH:/usr/local/texlive/bin/x86_64-linux

RUN tlmgr install \
  apa6 apa7 booktabs caption csquotes \
  endfloat environ etoolbox fancyhdr \
  fancyvrb framed lineno microtype mptopdf \
  ms parskip pgf sttools threeparttable \
  threeparttablex trimspaces txfonts upquote url was xcolor \
  geometry amsmath kvoptions kvsetkeys kvdefinekeys ltxcmds zapfding \
  auxhook infwarerr multirow babel-english stringenc uniquecounter  \
  epstopdf-pkg grfext bigintcalc bitset etexcmds gettitlestring \
  hycolor hyperref intcalc letltxmacro pdfescape refcount rerunfilecheck

# Setup R packages for papaja
RUN install2.r --error \
--skipinstalled \
  tinytex \
  remotes \
  markdown \
  mime

## Latest papaja development version
RUN Rscript -e "remotes::install_github('crsh/papaja')"
