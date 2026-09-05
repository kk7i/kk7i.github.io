#!/bin/bash
# ============================================================
#  add-work.sh —— 发布一个新作品（全自动）
#  用法: ./add-work.sh <主题目录名> <emoji标题> <一句话描述>
#
#  示例: ./add-work.sh voice-ai-hacks "🎙️ 语音 × AI 协作 Hacks" \
#                       "六层框架拆解语音 AI 工作流：触发→听写→清洗→路由→编排→反馈"
#
#  前提: 先把你的成品 HTML 放到  works/<主题目录名>/index.html
# ============================================================
set -e

NAME="$1"   # 目录名，如 voice-ai-hacks
TITLE="$2"  # 带 emoji 的标题
DESC="$3"   # 一句话描述

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

# 自动推导用户名：优先用 git remote，否则用目录名（kk7i.github.io -> kk7i）
USERNAME="$(git remote get-url origin 2>/dev/null | sed -E 's#.*github.com[:/]([^/]+)/[^.]+\.github\.io\.git.*#\1#;t;d')"
[ -z "$USERNAME" ] && USERNAME="$(basename "$ROOT" | sed -E 's/\.github\.io$//')"

# --- 参数检查 ---
if [ -z "$NAME" ] || [ -z "$TITLE" ] || [ -z "$DESC" ]; then
  echo "❌ 用法: $0 <目录名> <emoji标题> <一句话描述>"
  exit 1
fi

WORK_DIR="works/$NAME"
if [ ! -f "$WORK_DIR/index.html" ]; then
  echo "❌ 找不到 $WORK_DIR/index.html"
  echo "   请先把成品 HTML 复制过去: mkdir -p $WORK_DIR && cp 你的文件.html $WORK_DIR/index.html"
  exit 1
fi

# --- 插入卡片到 <!-- WORKS-LIST --> 之前 ---
# 用 awk 保证跨平台（mac/linux）兼容，不依赖 GNU sed -i
TODAY="$(date +%Y-%m-%d)"
CARD="  <a class=\"card\" href=\"$NAME/\">\n    <span class=\"date\">$TODAY</span><br>\n    <span class=\"title\">$TITLE</span>\n    <div class=\"desc\">$DESC</div>\n  </a>"

awk -v card="$CARD" 'BEGIN{printed=0} /<!-- WORKS-LIST -->/{ if(!printed){print card; printed=1} } {print}' \
  index.html > index.html.tmp && mv index.html.tmp index.html

echo "✅ 卡片已插入首页 (日期 $TODAY)"

# --- 提交并推送 ---
git add "$WORK_DIR" index.html
git commit -m "add: $TITLE"
git push

echo ""
echo "🎉 发布完成！"
echo "   首页:    https://$USERNAME.github.io/"
echo "   新作品:  https://$USERNAME.github.io/$NAME/"
