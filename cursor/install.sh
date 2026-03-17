#!/bin/bash
# Cursor Skills 一键安装脚本
# 将本仓库中的 cursor 规则文件安装到当前项目的 .cursor/rules/ 下

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RULES_SRC="$SCRIPT_DIR/rules"
RULES_DST=".cursor/rules"

if [ ! -d ".git" ]; then
    echo "警告: 当前目录不是 git 仓库根目录，请在项目根目录下运行此脚本"
    read -p "是否继续？(y/N) " confirm
    [ "$confirm" != "y" ] && exit 0
fi

mkdir -p "$RULES_DST"

for rule_file in "$RULES_SRC"/*.mdc; do
    [ -f "$rule_file" ] || continue
    rule_name=$(basename "$rule_file")
    cp "$rule_file" "$RULES_DST/$rule_name"
    echo "已安装: $rule_name -> $RULES_DST/$rule_name"
done

echo ""
echo "安装完成！已安装的 rules:"
ls "$RULES_DST"
