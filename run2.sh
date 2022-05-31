#!/bin/bash

HADOOP_HOME="/usr/local/hadoop/current"

$HADOOP_HOME/bin/hdfs --daemon start datanode
$HADOOP_HOME/bin/yarn --daemon start nodemanager

/bin/bash
