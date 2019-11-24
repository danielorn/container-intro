# A single page php application packaged as a docker container
This is a very simple php application packaged as a docker image

## Overview of application

The application itself consists of only one file, `index.php`, which can be found in the `www`folder.

The application will print a title saying "Hello from $NAME", where $NAME is an envrionment variable. It will also print it's IP:

```
<h1>Hello from <?php print $_ENV['NAME'] ?></h1>
<p class="lead">My IP is <?php print $_SERVER['SERVER_ADDR'] ?></p>
```

The Dockerfile is simple, it baselines on a publicly available image for php running on top of apache. Since the bae image contains all necessary setup we just need to copy our `www` folder into the designated location in the image, which is `/var/www/html`

```
FROM php:7.2-apache        # Baseline on php image
COPY www/ /var/www/html/   # Copy custom html
COPY start.sh /start.sh    # Custom Startup script
RUN chmod +x /start.sh     # Make custom startup script executable
CMD ["/start.sh"]          # Set startup script
```

## Build docker image

```
docker build -t web:v1 .
```

## Test the image locally

The follwoing command will launch our image as a container, passing in "My Cool Application"  as the environment variable `NAME` and binding port 1024 on the host machine to 80 inside the container.

```
docker run -d --name web -p 1024:80 -e NAME="My Cool Application" web:v1
``` 

The app can be viewed in a web browser by visiting http://localhost:1024
