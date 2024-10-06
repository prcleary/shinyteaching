# Use the rocker/shiny image as the base image
FROM rocker/shiny:4.2.2
MAINTAINER Paul Cleary <paul.cleary@ukhsa.gov.uk>

# Install additional Linux dependencies (if needed)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    pandoc \
    && apt-get clean

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
USER 998
CMD ["/usr/bin/shiny-server"]
