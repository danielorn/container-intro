FROM ubuntu:latest
RUN apt-get update && apt-get install apache2 -y
CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80