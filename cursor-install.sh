#!/bin/bash
# Cursor Skills 一键安装脚本
# 用法: bash <(curl -s https://raw.githubusercontent.com/zzmzz/skills/main/cursor-install.sh)
# 或: bash cursor-install.sh [项目目录]

set -e

PROJECT_DIR="${1:-.}"
RULES_DIR="$PROJECT_DIR/.cursor/rules"
REPO_URL="https://raw.githubusercontent.com/zzmzz/skills/main"

# 所有 skill 名称列表，新增 skill 时在此添加
SKILLS=(research)

mkdir -p "$RULES_DIR"

for skill in "${SKILLS[@]}"; do
    echo "安装 $skill ..."
    curl -sL "$REPO_URL/skills/$skill/SKILL.md" -o "$RULES_DIR/$skill.mdc"
    echo "  -> $RULES_DIR/$skill.mdc"
done

echo ""
echo "安装完成！已安装 ${#SKILLS[@]} 个 rules 到 $RULES_DIR"
