#!/bin/bash
docker run -d --name web -p 1024:80 -e NAME="My Cool Application" web