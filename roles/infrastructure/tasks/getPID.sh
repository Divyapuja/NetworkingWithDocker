#!/bin/bash -v
sudo docker inspect -f {{.State.Pid}} $1
