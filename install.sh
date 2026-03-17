#!/bin/bash
# AEGIS Installer — Install skills to your Claude environment
# Usage: ./install.sh [skills_dir]

set -e

SKILLS_DIR="${1:-$HOME/.claude/skills}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🛡️  AEGIS v5.0.0 Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create skills directory if not exists
mkdir -p "$SKILLS_DIR"

# Install each skill
SKILLS=(
  ai-personas project-navigator
  code-standards code-review adversarial-review
  code-coverage security-audit
  git-workflow api-docs tech-debt-tracker
  sprint-tracker retrospective course-correction
  test-architect aegis-builder skill-marketplace
)

installed=0
for skill in "${SKILLS[@]}"; do
  if [ -f "$SCRIPT_DIR/skills/$skill/SKILL.md" ]; then
    mkdir -p "$SKILLS_DIR/$skill"
    cp -r "$SCRIPT_DIR/skills/$skill/"* "$SKILLS_DIR/$skill/"
    echo "  ✅ $skill"
    ((installed++))
  else
    echo "  ❌ $skill — SKILL.md not found"
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installed $installed/16 skills to $SKILLS_DIR"
echo ""
echo "🚀 Getting started:"
echo "   Open Claude and say: \"Navi, what should I do next?\""
echo ""
echo "📖 Documentation:"
echo "   docs/AEGIS-User-Manual-v5.pdf"
echo ""
