## Prerequisites
The labs require an environment with docker and Kubernetes, which can be installed locally using Rancher Desktop and WSL 2

## Step 1: Enable WSL 2
Start a windows command line window and run the following command
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
## Step 2: Restart Computer

## Step 3: Install the WSL2 Linux kernel package
Download and run the [WSL2 Linux kernel update package for x64 machines](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
It can also be installed by running the following command in a powershell prompt

```powershell
Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile wsl_update_x64.msi -UseBasicParsing
Start-Process msiexec.exe -Wait -ArgumentList "/I $((Get-Location).Path)\wsl_update_x64.msi /quiet"
```

## Step 4: Install Rancher Desktop
Download and install Rancher Desktop from [rancherdesktop.io](https://rancherdesktop.io/)

## Step 5: Launch Rancher Desktop
Start Rancher dektop. The first time this will take some time as it downloads and configures dependencies. If the process fails or hangs, please proceed to the next step

## Step 6: Configure Rancher Desktop
Close rancher desktop (make sure to exit it fully by right clicking on the icon in the activity field and select "Quit Rancher Desktop" and not just closing the window). Open the file `%USERPROFILE%\AppData\Roaming\rancher-desktop\settings.json` in a text editor and make sure the setting `experimentalHostResolver` is set to `true`

## Step 7: Launch Rancher Desktop
Launch rancher Desktop from the start menu or from the desktop icon.

## Step 8: Verify Installation

1. Run the command `kubectl get pods` in a terminal. The output should be similar to below
   ```
    No resources found in default namespace.
   ```
2. Run the command `nerdctl run hello-world:latest` in a terminal. The output should be similar to below
    ```
    Hello from Docker!
    This message shows that your installation appears to be working correctly.

    To generate this message, Docker took the following steps:
    1. The Docker client contacted the Docker daemon.
    2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
        (amd64)
    3. The Docker daemon created a new container from that image which runs the
        executable that produces the output you are currently reading.
    4. The Docker daemon streamed that output to the Docker client, which sent it
        to your terminal.

    To try something more ambitious, you can run an Ubuntu container with:
    $ docker run -it ubuntu bash

    Share images, automate workflows, and more with a free Docker ID:
    https://hub.docker.com/

    For more examples and ideas, visit:
    https://docs.docker.com/get-started/
    ```
