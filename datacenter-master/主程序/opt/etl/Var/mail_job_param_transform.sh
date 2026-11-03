#!/bin/bash

# 初始化参数数组
declare -A params=()

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v)
            shift
            [[ $1 == *=* ]] || { echo "Invalid format: $1"; exit 1; }
            key="${1%%=*}"
            value="${1#*=}"
            params["$key"]="$value"
            ;;
        *)
            shift
            ;;
    esac
done

# 构建JSON键值对
json_parts=()
for key in "${!params[@]}"; do
    value="${params[$key]}"
    json_parts+=("\"currentProcess.$key\":\"$value\"")
done

# 拼接最终结果
if [[ ${#json_parts[@]} -gt 0 ]]; then
    # 使用IFS拼接数组元素
    IFS=","
    json_content="${json_parts[*]}"
    unset IFS
    result="xq-job-return: {$json_content}"
else
    result="xq-job-return: {}"
fi

echo "$result"


# echo "xq-job-return: {\"currentProcess.bizdate_s\":\""$bizdate_s""\","\"currentProcess.bizdate_e\":\""$bizdate_e""\","\"currentProcess.startdate_hg\":\""$startdate_hg""\","\"currentProcess.enddate_ew\":\""$enddate_ew""\","\"currentProcess.startdate_var\":\""$startdate_var""\","\"currentProcess.bizdate_sn\":\""$bizdate_sn""\","\"currentProcess.bizdate_en\":\""$bizdate_en""\","\"currentProcess.bizdate_sy\":\""$bizdate_sy""\","\"currentProcess.bizdate_ey\":\""$bizdate_ey""\","\"currentProcess.enddate_var\":\""$enddate_var""\","\"currentProcess.bizdate_eg\":\""$bizdate_eg""\"}""
