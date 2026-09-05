#!/bin/bash
# ============================================================
#  publish.sh —— kk7i 作品集「一键上线」
#  前提: 你已在 GitHub 网页端建好空仓库 kk7i.github.io
#  用法: 首次部署 ./publish.sh，之后每次有改动 ./publish.sh 即可
# ============================================================
set -e
cd "$(dirname "$0")"

if git remote get-url origin >/dev/null 2>&1; then
  echo "📤 推送到 GitHub..."
  git push -u origin main 2>/dev/null || git push
else
  echo "❌ 还没配 remote。先运行一次: ./init-repo.sh kk7i"
  exit 1
fi

echo ""
echo "🎉 推送完成！"
echo "   首页: https://kk7i.github.io/"
echo ""
echo "⚠️ 若这是首次推送: 去仓库 Settings → Pages → Deploy from branch → main / (root) → Save"
echo "   约 1-2 分钟后生效，之后每次 push 会自动重新部署。"