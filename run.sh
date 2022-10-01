#!/bin/sh

docker build -t powershell . && docker run -p 9191:8080 powershell