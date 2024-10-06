# Use the rocker/shiny image as the base image
FROM rocker/shiny:latest

# Install additional Linux dependencies (if needed)
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

# Install the R packages needed for the app
RUN R -e "install.packages(c('shiny', 'htmltools', 'markdown', 'DT', 'data.table', 'bit64'), repos='http://cran.rstudio.com/')"

# Copy your Shiny app into the container
COPY app.R /srv/shiny-server/app.R

# Set environment to avoid issues with locale
ENV LANG en_GB.UTF-8
ENV LC_ALL en_GB.UTF-8

# Expose the Shiny server port (default is 3838)
EXPOSE 3838

# Run Shiny server
USER shiny
CMD Rscript /srv/shiny-server/app.R