#!/bin/bash

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 配置文件路径（与脚本同目录）
CONFIG_FILE="${SCRIPT_DIR}/config.ini"

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "错误: 配置文件 $CONFIG_FILE 不存在" >&2
    exit 1
fi

# 显示用法信息
show_usage() {
    echo "用法: $0 <键名>"
    echo "示例:"
    echo "  $0 windpassword    # 查询密码"
    echo "  $0 windusername    # 查询用户名"
    echo "  $0 windurl         # 查询URL"
    echo "  $0 winddbname      # 查询数据库名"
    echo ""
    echo "可用的键名:"
    # 从配置文件中提取所有键名
    grep -E '^[[:alnum:]]+=' "$CONFIG_FILE" | cut -d'=' -f1 | sed 's/^/  /'
    exit 1
}

# 检查是否提供了参数
if [ $# -eq 0 ]; then
    show_usage
fi

KEY_NAME="$1"

# 在配置文件中查找键值对  
VALUE_LINE=$(grep -E "^[[:space:]]*${KEY_NAME}=" "$CONFIG_FILE")

# 检查是否找到
if [ -z "$VALUE_LINE" ]; then
    echo "错误: 键 '$KEY_NAME' 在配置文件中不存在" >&2
    show_usage
fi

# 提取值（处理可能存在的空格和特殊字符）
# 提取值（处理空格、注释和引号）
CONFIG_VALUE=$(echo "$VALUE_LINE" | 
    # 移除键名、等号及周围空格
    sed -E "s/^[[:space:]]*${KEY_NAME}[[:space:]]*=[[:space:]]*//" |
    # 移除行尾空格
    sed -E "s/[[:space:]]+$//" |
    # 移除双引号（如果整个值被双引号包裹）
    sed -E "s/^\"(.*)\"$/\1/" |
    # 移除单引号（如果整个值被单引号包裹）
    sed -E "s/^'(.*)'$/\1/")

# 输出结果
echo "$CONFIG_VALUE"

