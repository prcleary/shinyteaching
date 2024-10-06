# Use the rocker/shiny image as the base image
FROM rocker/shiny:latest
MAINTAINER Paul Cleary "paul.cleary@ukhsa.gov.uk"

# Install additional Linux dependencies (if needed)
RUN apt-get update -qq && apt-get install -y no-install-recommends \
    libxml2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libmariadbd-dev \
    libpq-dev \
    libsqlite3-dev \
    libssh2-1-dev \
    libssl-dev
    libxml2-dev \
    pandoc \
    unixodbc-dev

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# Install the R packages needed for the app
RUN R -e "install.packages(c('shiny', 'htmltools', 'markdown', 'DT', 'data.table', 'bit64'), repos='http://cran.rstudio.com/')"

# Copy your Shiny app into the container
COPY . /srv/shiny-server/

# Set environment to avoid issues with locale
ENV LANG en_GB.UTF-8
ENV LC_ALL en_GB.UTF-8

# Expose the Shiny server port (default is 3838)
EXPOSE 3838

# Run Shiny server
USER shiny
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]
