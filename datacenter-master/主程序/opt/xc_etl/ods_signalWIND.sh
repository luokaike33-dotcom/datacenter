#!/bin/bash

#执行hsql脚本
export HADOOP_USER_NAME=etl_ty

hive -f /opt/xc_etl/etl_signalWIND.hql 
