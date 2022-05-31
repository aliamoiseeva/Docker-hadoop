#!/bin/bash

HADOOP_HOME="/usr/local/hadoop/current"

$HADOOP_HOME/bin/hdfs namenode -format cluster1
$HADOOP_HOME/bin/hdfs --daemon start namenode
$HADOOP_HOME/bin/yarn --daemon start resourcemanager

/bin/bash
