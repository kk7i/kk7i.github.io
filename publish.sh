#!/bin/bash
# ============================================================
#  publish.sh - Publish the kk7i portfolio
#  Prerequisite: the empty kk7i.github.io repository already exists on GitHub.
#  Usage: run ./publish.sh for the first deployment and after each subsequent change.
# ============================================================
set -e
cd "$(dirname "$0")"

if git remote get-url origin >/dev/null 2>&1; then
  echo "📤 Pushing to GitHub..."
  git push -u origin main 2>/dev/null || git push
else
  echo "❌ No remote is configured. Run this first: ./init-repo.sh kk7i"
  exit 1
fi

echo ""
echo "🎉 Push complete!"
echo "   Homepage: https://kk7i.github.io/"
echo ""
echo "⚠️ For the first push: open repository Settings → Pages → Deploy from branch → main / (root) → Save"
echo "   It should be live in 1–2 minutes; every later push will trigger a new deployment."