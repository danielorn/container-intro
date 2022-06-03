# Container Hierarchy

Containers are built my merging multiple layers together. Each directive in a docker file becomes a layer. Layers can also be imported from other already built images using the `FROM` directive. This is useful when you want to share a common foundation between a set of applications, or when you want to release customizable and extendable images to a wider audience.

The example we will take a look at here is to create a base image containing an apache web server. It will not contain any customized html pages or application code, just a plain apache2 installation. This image can then be used as a base to add customized web pages into it.

This way a developer that creates websites does not need to worry about how apache was setup and configured, she only needs to remember to copy her application into the designated folder inside the container.

## Creating the base image ##

The file `base/Dockerfile` is bases on ubuntu and installs apache.
```
FROM ubuntu:latest
RUN apt-get update && apt-get install apache2 -y
CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80
```

Build the image with the following command
```
nerdctl build -t apache base/
```

Start the base image using the following command
```
nerdctl run --name apache2 -d -p 1980:80 apache
```

The `-p` flag tells docker to forward local port `1980` to container port `80`.
Thus you should be able to browse [http://localhost:1980](http://localhost:1980) and see the default apache page

Stop the apache2 container using the following command
```
nerdctl stop apache2 && nerdctl rm apache2
```

## Creating the app ##

The file `app/Dockerfile` uses the apache image built previously as its base image and copies in its own index.html file.
```
FROM apache
COPY index.html /var/www/html
```

Build the image with the following command
```
nerdctl build -t web app/
```
Start the base image using the following command
```
nerdctl run --name web -d -p 1980:80 web
```

[http://localhost:1980](http://localhost:1980) Should now give you a custom "hello world" page.

Stop the web container using the following command
```
nerdctl stop web && nerdctl rm web
```