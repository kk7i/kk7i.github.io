#!/bin/bash
# ============================================================
#  init-repo.sh - Initialize your portfolio repository
#  Usage: ./init-repo.sh <your-github-username>
#
#  It will:
#    1. Rename this directory to <username>.github.io.
#    2. Replace URL placeholders in index.html.
#    3. Run git init, create the first commit, and configure the SSH origin.
#    4. Remind you to create an empty repository and enable Pages on GitHub.
# ============================================================
set -e

USERNAME="$1"
if [ -z "$USERNAME" ]; then
  echo "❌ Usage: $0 <your-github-username>"
  exit 1
fi

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

# Rename the directory if it is not already named username.github.io.
CURRENT="$(basename "$ROOT")"
TARGET="$USERNAME.github.io"
if [ "$CURRENT" != "$TARGET" ]; then
  PARENT="$(dirname "$ROOT")"
  # Fail if the target already exists.
  if [ -e "$PARENT/$TARGET" ]; then
    echo "❌ $PARENT/$TARGET already exists. Resolve it first."
    exit 1
  fi
  cd "$PARENT"
  mv "$CURRENT" "$TARGET"
  cd "$TARGET"
  ROOT="$(pwd)"
fi

# Replace URL placeholders in the scripts and index.html.
if [ -f "add-work.sh" ]; then
  sed -i.bak "s|<your-username>|$USERNAME|g" add-work.sh && rm -f add-work.sh.bak
fi
sed -i.bak "s|<your-username>|$USERNAME|g" index.html && rm -f index.html.bak

# Disable Jekyll so GitHub serves the static files directly.
touch .nojekyll

# Set executable permissions.
chmod +x add-work.sh init-repo.sh

# Create the initial git commit.
git init
git add .
git commit -m "init: portfolio scaffold and maintenance rules"

# Configure the SSH remote. For HTTPS, use https://github.com/$USERNAME/$TARGET.git instead.
git branch -M main
git remote add origin "git@github.com:$USERNAME/$TARGET.git"

echo ""
echo "=============================================="
echo "🎉 Local repository is ready: $ROOT"
echo ""
echo "Next steps (one-time setup):"
echo "  1) Create an empty repository on GitHub with this exact name:"
echo "       $TARGET"
echo "     (Do not initialize it with a README, .gitignore, or license.)"
echo ""
echo "  2) Return to the terminal and push:"
echo "       cd $ROOT"
echo "       git push -u origin main"
echo ""
echo "  3) In the repository, open Settings → Pages → Deploy from branch"
echo "     → select main / (root) → Save"
echo ""
echo "  4) Visit https://$USERNAME.github.io/ after a few minutes."
echo "=============================================="
