#!/bin/bash

sudo docker network create --driver=bridge hadoop 2> /dev/null

# Remove container
sudo docker rm -f namenode1 2> /dev/null

# Start hadoop-namenode container
sudo docker run -dit --name namenode1 --hostname hadoop-namenode --net=hadoop -p 8088:8088 -p 9870:9870 namenode:1.1

# Remove container
sudo docker rm -f datanode1 2> /dev/null

# Start hadoop-datanode container
sudo docker run -dit --name datanode1 --hostname hadoop-datanode --net=hadoop -p 8042:8042 -p 9864:9864 datanode:1.1
