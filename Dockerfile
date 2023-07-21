#### Dockerfile for R-shiny app

FROM rocker/shiny-verse:4

#LABEL "R-Shiny dashboard for NIPT quality metrics"

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev
	
	
## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

RUN mkdir /app
RUN mkdir app/nipt_data

# copy necessary files
## renv.lock file
COPY /NIPT_app/renv.lock ./renv.lock

## app folder
COPY /NIPT_app /app

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'renv::restore()'
#RUN touch /app/ex.txt

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]
