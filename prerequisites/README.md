## Prerequisites
In order to run docker on a windows PC:

## Step 1: Enable Hyper-V
Start a windows command line window and run the following command
```
powershell -C "Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All"
```
This will require a restart of your computer

## Step 2: Install Docker for windows
Downlload and install [Docker CE For windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
This may require a restart of your computer 

## Step 3: Configure docker
On the right side of the taskbar, find and open Docker. 
- Under `Settings -> General` tick the box *Expose Daemon on tcp://localhost:2375 without tls*
- Under `Settings -> Shared Drives` tick the box *C* and click apply
- Under `Settings -> Kubernetes` tick the box *Enable Kubernetes* and click apply
- Under `Settings -> Advanced` adjust the RAM and CPU allocated to the docker daemon. The higher the value the more resources will be available to your containers
