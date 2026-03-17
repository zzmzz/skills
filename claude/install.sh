#!/bin/bash
# Claude Code Skills 一键安装脚本
# 将本仓库中的所有 skills 安装到 ~/.claude/skills/ 下

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DST="$HOME/.claude/skills"

mkdir -p "$SKILLS_DST"

for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name=$(basename "$skill_dir")
    target="$SKILLS_DST/$skill_name"

    if [ -L "$target" ]; then
        echo "更新链接: $skill_name"
        rm "$target"
    elif [ -d "$target" ]; then
        echo "跳过: $skill_name (已存在且非符号链接，如需覆盖请手动删除 $target)"
        continue
    fi

    ln -s "$skill_dir" "$target"
    echo "已安装: $skill_name -> $target"
done

echo ""
echo "安装完成！已安装的 skills:"
ls -la "$SKILLS_DST" | grep "^l"
