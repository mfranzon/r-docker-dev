# Use an official R runtime as a parent image
# The 4.1.2 version is choosen for compatibility with libpq-dev library
FROM r-base:4.1.2 

# Install required libraries
RUN apt update
RUN apt install libpq-dev -y

# Install R packages, if you want to install also
# the dependencies for Postgres install also
# RPostgres
RUN R -e "install.packages(c('shiny', 'shinyalert'))" 

# Set new workdir
WORKDIR /home/app

# Copy the app files into the Docker image
COPY src/ .

# Expose port
EXPOSE 3838

# Run the app
CMD ["R", "-e", "shiny::runApp('/home/app', host='0.0.0.0', port=3838)"]
