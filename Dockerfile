FROM openanalytics/r-base

MAINTAINER Tobias Verbeke "tobias.verbeke@openanalytics.eu"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0

# system library dependency for the euler app
RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    unixodbc-dev \
    r-cran-rodbc

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/')"

# install dependencies of your app
RUN R -e "install.packages(c('data.table', 'dplyr', 'rhandsontable', 'devtools'), repos='https://cloud.r-project.org/')"

# copy the app to the image
RUN mkdir /root/app
COPY shiny_save /root/shiny_save

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/shiny_save', host='0.0.0.0', port=3838)"]