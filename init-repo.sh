#!/bin/bash
# ============================================================
#  init-repo.sh —— 首次初始化你的作品集仓库
#  用法: ./init-repo.sh <你的GitHub用户名>
#
#  它会:
#    1. 把本目录重命名为 <用户名>.github.io
#    2. 替换 index.html 里的 URL 占位符
#    3. git init + 首次 commit + 配好 origin (用 SSH)
#    4. 提醒你去 GitHub 网页端创建空仓库 + 开启 Pages
# ============================================================
set -e

USERNAME="$1"
if [ -z "$USERNAME" ]; then
  echo "❌ 用法: $0 <你的GitHub用户名>"
  exit 1
fi

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

# 如果当前目录名还不是 用户名.github.io，则改名
CURRENT="$(basename "$ROOT")"
TARGET="$USERNAME.github.io"
if [ "$CURRENT" != "$TARGET" ]; then
  PARENT="$(dirname "$ROOT")"
  # 若目标已存在则报错
  if [ -e "$PARENT/$TARGET" ]; then
    echo "❌ $PARENT/$TARGET 已存在，请先处理"
    exit 1
  fi
  cd "$PARENT"
  mv "$CURRENT" "$TARGET"
  cd "$TARGET"
  ROOT="$(pwd)"
fi

# 替换脚本里 & index.html 里的 URL 占位符
if [ -f "add-work.sh" ]; then
  sed -i.bak "s|<你的用户名>|$USERNAME|g" add-work.sh && rm -f add-work.sh.bak
fi
sed -i.bak "s|<你的用户名>|$USERNAME|g" index.html && rm -f index.html.bak

# 禁用 Jekyll（关键！否则 GitHub 会尝试构建静态文件）
touch .nojekyll

# 权限
chmod +x add-work.sh init-repo.sh

# 首次 git
git init
git add .
git commit -m "init: 作品集脚手架 + 维护规约"

# 配 remote（SSH）。若你用 HTTPS，改成 https://github.com/$USERNAME/$TARGET.git
git branch -M main
git remote add origin "git@github.com:$USERNAME/$TARGET.git"

echo ""
echo "=============================================="
echo "🎉 本地仓库已就绪: $ROOT"
echo ""
echo "下一步（只需做一次）:"
echo "  1) 去 GitHub 网页端新建一个【空】仓库，名字必须是:"
echo "       $TARGET"
echo "     (不要勾选 README / .gitignore / license)"
echo ""
echo "  2) 回到终端，推送:"
echo "       cd $ROOT"
echo "       git push -u origin main"
echo ""
echo "  3) 仓库 Settings → Pages → Deploy from branch"
echo "     → 选 main / (root) → Save"
echo ""
echo "  4) 几分钟后访问: https://$USERNAME.github.io/"
echo "=============================================="
