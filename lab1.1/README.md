# Introduction

This module contains brief introoduction to what docker is and how to build images and launch and interact with container using the Docker cli

## What is a container

Containers is a construct in Linux that makes it possible to partition the kernel namespace and give each process (or process) tree its own space. 


## Useful docker commands

The below section contains a short walkthrough of a number of useful commands. It is based on a custom image created from a the `Dockerfile` in this folder

The Dockerfile is a manifest for how to build docker images (much like maven or make which is a manifest for how to compile sourcecode into a binary)

Each line in a docker file begins with a directive (usually written in capital letters). Below is simple Dockerfile using the `FROM`, `COPY` and `CMD` directive
```
FROM ubuntu:latest
COPY loop.sh /loop.sh
CMD ["bin/bash", "/loop.sh"]
```

- `FROM` Defines which image to baseline on. While it is possible to start completely from scratch, baselining on one of the common linux distributions is fairly common. Those base docker images comes with a lot of tools preinstalled, much like the linux distributions do.
- `COPY` copies a file into the container
- `CMD` defines what command should be executed when the container runs. In this case `/loop.sh` is executed by bash.

`loop.sh` is a very simple bash script that contains an inifinite loop that will print `Hello $NAME from loop.sh`

```
while true; do 
	echo "Hello $NAME from loop.sh"
	sleep 1
done
```

### Build a docker container
Run the following command to build the container using the manifest in the docker file. the -t tag gives the built image a name
```
docker build -t my-image .
```

### List all images currently in the local repository
```
docker images
```

### Run a docker container
```
docker run -d --name mycontainer my-image
```
The above command takes the image `my-image` and starts a new container with name `mycontainer`
By default the shell will follow the output of the container but as we are adding the flag `-d` it will start in detached mode in the background.

### List all docker containers currently running
```
docker ps
```

### View the logs of a container
```
docker logs mycontainer
```
The above command views the logs of the container called `mycontainer`

### Execute a shell in a running container
```
docker exec -it mycontainer /bin/bash
```
The above command will connect to the running container with name `mycontainer` and launch the program `/bin/bash`. This is a great tool for troubleshooting and for viewing how it looks inside a container.

It is also possible to view the proces tree from the inside of a container by running `ps -axf`from the terminal
```
#>: ps -axf
PID TTY     STAT  TIME COMMAND
  14 pts/0   Ss    0:00 /bin/bash
 156 pts/0   R+    0:00  \_ ps -axf
   1 ?       Ss    0:00 bin/bash /loop.sh
 155 ?       S     0:00 sleep 1
```
Pid 1 in the container is the process we specified in the cmd of the container. The sleep process (PID 155) is also visible. The other two processes are there because we launched them when we exeucted kubectl exec, first a bash shell (PID 14) and then we executed `ps -af`(PID 156)


#### Exit the container
To exit the container type `exit`

### Run a docker container and inject environment variables
```
docker run -d --name containerWithEnv -e NAME=John my-image
```
The above command will start a container from  image `my-image` with name `containerWithEnv` and set the environment variable `NAME` to John.

You can verify this by executing a shell in the running container with `docker exec -it containerWithEnv /bin/bash` and in that shell running `echo $NAME`

You can also view the log output of the container using `docker logs containerWithEnv`. The bash script runnig will see that the `$NAME` variable is set and use that in its output.

Injecting environment variables is a great way to pass environmental configuration into the container at launch. This way endpoints, password etc can be kept outside of a genereic image wich can work everywhere from local development environments to live proudction environments.

### Run a docker container and mount a volume
```
docker run -d --name containerWithVolume -v /c/Users:/users my-image
```
The above command will start a container from  image `my-image` with name `containerWithVolume` and make the folder C:\Users available under /users

You can verify this by executing a shell in the running container with `docker exec -it containerWithVolume /bin/bash` and in that shell navigate to /users

You can also run `df -h` inside a shell in the container, that will give the following output
```
$df -h
Filesystem      Size  Used Avail Use% Mounted on
overlay          59G   11G   45G  20% /
tmpfs            64M     0   64M   0% /dev
//10.0.75.1/C   475G  259G  216G  55% /users

```

### Kill a running container
```
docker stop <NAME>
```

### Remove an image from the local repository
```
docker rm <NAME>
```