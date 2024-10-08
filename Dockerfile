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
RUN R -e "install.packages(c('shiny', 'htmltools', 'markdown', 'DT', 'data.table', 'bit64', 'readxl'), repos='http://cran.rstudio.com/')"

# Copy your Shiny app into the container
COPY app.R /srv/shiny-server/
COPY www /srv/shiny-server/www

# Expose the Shiny server port (default is 3838)
EXPOSE 3838

# Run Shiny server
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/app.R', host='0.0.0.0', port=3838)"]