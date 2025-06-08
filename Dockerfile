# Dockerfile for deploying R Shiny app to Heroku
FROM rocker/shiny:latest

# Set working directory
WORKDIR /srv/shiny-server/

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c( \
    'shiny', \
    'shinydashboard', \
    'DT', \
    'plotly', \
    'dplyr', \
    'ggplot2', \
    'readr', \
    'shinyWidgets' \
    ), repos='https://cran.rstudio.com/')"

# Copy application files
COPY app.R ./
COPY Opo.csv ./

# Expose port
EXPOSE 3838

# Run the application
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/app.R', host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', 3838)))"]