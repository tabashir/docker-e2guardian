#!/bin/sh

docker stop e2guardiantest
docker rm e2guardiantest
docker run -it --name e2guardiantest vin0x64/e2guardian
