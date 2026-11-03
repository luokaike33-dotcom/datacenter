#!/bin/bash

#执行hsql脚本
export HADOOP_USER_NAME=etl_ty

hive -e "TRUNCATE TABLE ty_dwd.etl_signal"

 
