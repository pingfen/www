#!/bin/bash

git pull
docker build -t pingfen/www -f ./Dockerfile .
docker stop www
docker rm www
docker run --name www -d --restart  unless-stopped -p 1313:443 pingfen/www hugo server --bind 0.0.0.0 -p 443 --baseURL https://pingfen.io
