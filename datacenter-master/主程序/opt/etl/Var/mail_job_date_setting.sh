#!/bin/bash

# 获取当天日期（格式：YYYYMMDD）
today=$(date +%Y%m%d)

# 获取上个月的第一天（格式：YYYYMMDD）
# 1. 获取本月第一天
# 2. 减去1天得到上个月最后一天
# 3. 将日期设置为1号得到上个月第一天
first_day_last_month=$(date -d "$(date +%Y%m01) -1 day" +%Y%m01)

# 获取上个月的最后一天（格式：YYYYMMDD）
# 1. 获取本月第一天
# 2. 减去1天得到上个月最后一天
last_day_last_month=$(date -d "$(date +%Y%m01) -1 day" +%Y%m%d)


echo "xq-job-return: {\"currentProcess.first_day_last_month\":\""$first_day_last_month""\","\"currentProcess.last_day_last_month\":\""$last_day_last_month""\"}""