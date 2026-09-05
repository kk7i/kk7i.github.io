#!/bin/bash
# ============================================================
#  add-work.sh - Publish a new work (fully automated)
#  Usage: ./add-work.sh <topic-directory> <emoji-title> <one-line-description>
#
#  Example: ./add-work.sh voice-ai-hacks "🎙️ Voice × AI Collaboration Hacks" \
#                       "A six-layer framework for voice AI workflows"
#
#  Prerequisite: put the finished HTML at works/<topic-directory>/index.html first.
# ============================================================
set -e

NAME="$1"   # Directory name, for example voice-ai-hacks
TITLE="$2"  # Title with an emoji
DESC="$3"   # One-line description

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

# Infer the username from the git remote first, then from the directory name (kk7i.github.io -> kk7i).
USERNAME="$(git remote get-url origin 2>/dev/null | sed -E 's#.*github.com[:/]([^/]+)/[^.]+\.github\.io\.git.*#\1#;t;d')"
[ -z "$USERNAME" ] && USERNAME="$(basename "$ROOT" | sed -E 's/\.github\.io$//')"

# --- Validate arguments ---
if [ -z "$NAME" ] || [ -z "$TITLE" ] || [ -z "$DESC" ]; then
  echo "❌ Usage: $0 <topic-directory> <emoji-title> <one-line-description>"
  exit 1
fi

WORK_DIR="works/$NAME"
if [ ! -f "$WORK_DIR/index.html" ]; then
  echo "❌ Cannot find $WORK_DIR/index.html"
  echo "   Copy the finished HTML there first: mkdir -p $WORK_DIR && cp your-file.html $WORK_DIR/index.html"
  exit 1
fi

# --- Insert the card before <!-- WORKS-LIST --> ---
# Use awk for macOS/Linux compatibility; this avoids depending on GNU sed -i.
TODAY="$(date +%Y-%m-%d)"
CARD="  <a class=\"card\" href=\"works/$NAME/\">\n    <span class=\"date\">$TODAY</span><br>\n    <span class=\"title\">$TITLE</span>\n    <div class=\"desc\">$DESC</div>\n  </a>"

awk -v card="$CARD" 'BEGIN{printed=0} /<!-- WORKS-LIST -->/{ if(!printed){print card; printed=1} } {print}' \
  index.html > index.html.tmp && mv index.html.tmp index.html

echo "✅ Card inserted into the homepage (date $TODAY)"

# --- Commit and push ---
git add "$WORK_DIR" index.html
git commit -m "add: $TITLE"
git push

echo ""
echo "🎉 Publication complete!"
echo "   Homepage: https://$USERNAME.github.io/"
echo "   New work: https://$USERNAME.github.io/works/$NAME/"
