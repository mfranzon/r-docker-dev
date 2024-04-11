# Use an official R runtime as a parent image
FROM rocker/shiny:latest

# Install required libraries
RUN sudo apt update
RUN sudo apt install libpq-dev -y

# Install R packages
RUN R -e "install.packages(c('shiny','RPostgres','shinyalert'))"
# Set new workdir
WORKDIR /home/app

# Copy the app files into the Docker image
COPY src/ .

# Expose port
EXPOSE 3838

# Run the app
CMD ["R", "-e", "shiny::runApp('/home/app', host='0.0.0.0', port=3838)"]
