# Container and Azure Kubernetes Service Tutorial

Many are the developers that have experienced the dreaded _”It works on my computer, but not on the servers”_, and then spent far too many hours comparing the environments, just to find that the cause of the error is not at all in the application, but in a configuration file in the application server. 

With containers this is about to change, as one of the many benefits of a container is that it packages most of the runtime environment instead of just the application for distribution.

[Link to slide deck](http://bit.ly/container-intro-ies)

[Link to prerequisites](prerequisites/)

## Part 1 - What is a Linux Container and what is it good for
This part uncovers what a Linux container really is, how it works and a short walkthrough of useful commands

- [Lab 1.1: Introduction to Docker](lab1.1/)
- [Lab 1.2: Container Hierarchies](lab1.2/)

## Part 2 - Containerizing an application
Part 2 covers how to containerize a simple web application and deploy it to Kubernetes

- [Lab 2.1: Containerizing aa simple web application](lab2.1/)
- [Lab 2.2: Deploy, expose and scale in Kubernetes](lab2.2/)
- [Lab 2.3: Add a probe and do rolling updates](lab2.3/)
