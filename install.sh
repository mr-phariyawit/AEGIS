#!/bin/bash
# AEGIS Installer & Upgrader v2
# Usage:
#   ./install.sh [skills_dir]    Fresh install or upgrade
#   ./install.sh --check         Check current version
#   ./install.sh --backup        Backup only
#   ./install.sh --restore       List and restore backups
#   ./install.sh --diff          Preview changes
#   ./install.sh --force [dir]   Force overwrite

set -e

AEGIS_VERSION="5.2.0"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORCE_MODE=false
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Parse flags first
case "${1:-}" in
  --force) FORCE_MODE=true; SKILLS_DIR="${2:-$HOME/.claude/skills}" ;;
  --check|--backup|--restore|--diff|--help|-h) SKILLS_DIR="$HOME/.claude/skills" ;;
  *) SKILLS_DIR="${1:-$HOME/.claude/skills}" ;;
esac

AGENTS_DIR="$(dirname "$SKILLS_DIR")/.claude/agents"
COMMANDS_DIR="$(dirname "$SKILLS_DIR")/.claude/commands"
BACKUP_DIR="${SKILLS_DIR}/.aegis-backups"
VERSION_FILE="${SKILLS_DIR}/.aegis-version"
CUSTOM_DIR="${SKILLS_DIR}/.aegis-custom"

CORE_SKILLS=(
  ai-personas project-navigator aegis-orchestrator
  code-standards code-review adversarial-review
  code-coverage security-audit test-architect
  git-workflow api-docs tech-debt-tracker
  sprint-tracker retrospective course-correction
  aegis-builder skill-marketplace super-spec
)
AGENT_FILES=(sage pixel bolt vigil havoc forge muse navi)
COMMAND_FILES=(aegis-pipeline aegis-verify aegis-launch)

echo ""
echo "  ╔═══════════════════════════════════════════════╗"
echo "  ║  🛡️  AEGIS Installer v${AEGIS_VERSION}                    ║"
echo "  ╚═══════════════════════════════════════════════╝"
echo ""

get_version() {
  if [ -f "$VERSION_FILE" ]; then
    cat "$VERSION_FILE"
  elif [ "$(find "$SKILLS_DIR" -maxdepth 2 -name 'SKILL.md' 2>/dev/null | wc -l)" -gt 0 ]; then
    echo "legacy"
  else
    echo "none"
  fi
}

do_backup() {
  local bp="${BACKUP_DIR}/${TIMESTAMP}"
  mkdir -p "$bp/skills" "$bp/agents" "$bp/commands"
  for d in "$SKILLS_DIR"/*/; do
    local n=$(basename "$d")
    [ -f "${d}SKILL.md" ] && [ "$n" != ".aegis-backups" ] && [ "$n" != ".aegis-custom" ] && \
      mkdir -p "$bp/skills/$n" && cp -r "$d"* "$bp/skills/$n/" 2>/dev/null
  done
  [ -d "$AGENTS_DIR" ] && cp "$AGENTS_DIR"/*.md "$bp/agents/" 2>/dev/null || true
  [ -d "$COMMANDS_DIR" ] && cp "$COMMANDS_DIR"/*.md "$bp/commands/" 2>/dev/null || true
  [ -f "$VERSION_FILE" ] && cp "$VERSION_FILE" "$bp/"
  echo "  📦 Backup: $bp"
}

detect_custom() {
  local result=""
  for skill in "${CORE_SKILLS[@]}"; do
    local inst="${SKILLS_DIR}/${skill}/SKILL.md"
    local src="${SCRIPT_DIR}/skills/${skill}/SKILL.md"
    [ -f "$inst" ] && [ -f "$src" ] && ! diff -q "$inst" "$src" >/dev/null 2>&1 && result="$result $skill"
  done
  for d in "$SKILLS_DIR"/*/; do
    local n=$(basename "$d")
    [ ! -f "${d}SKILL.md" ] && continue
    local core=false
    for c in "${CORE_SKILLS[@]}"; do [ "$n" = "$c" ] && core=true; done
    [ "$core" = false ] && [ "$n" != ".aegis-backups" ] && [ "$n" != ".aegis-custom" ] && result="$result USER:$n"
  done
  echo "$result"
}

save_custom() {
  mkdir -p "$CUSTOM_DIR"
  for item in $(detect_custom); do
    if [[ "$item" == USER:* ]]; then
      local n="${item#USER:}"
      echo "     + Custom skill preserved: $n"
      mkdir -p "${CUSTOM_DIR}/$n"
      cp -r "${SKILLS_DIR}/$n/"* "${CUSTOM_DIR}/$n/" 2>/dev/null || true
    else
      echo "     ~ Modified skill saved: $item"
      mkdir -p "${CUSTOM_DIR}/$item"
      cp "${SKILLS_DIR}/$item/SKILL.md" "${CUSTOM_DIR}/$item/SKILL.md.user" 2>/dev/null || true
    fi
  done
}

restore_custom() {
  [ ! -d "$CUSTOM_DIR" ] && return
  echo "  🔄 Restoring customizations..."
  for d in "$CUSTOM_DIR"/*/; do
    local n=$(basename "$d")
    if [ -f "$d/SKILL.md.user" ]; then
      cp "$d/SKILL.md.user" "${SKILLS_DIR}/$n/SKILL.md.user-backup"
      echo "     ~ $n: your changes → SKILL.md.user-backup (merge manually)"
    elif [ -f "$d/SKILL.md" ]; then
      mkdir -p "${SKILLS_DIR}/$n"
      cp -r "$d"* "${SKILLS_DIR}/$n/"
      echo "     + $n: custom skill restored"
    fi
  done
}

install_skills() {
  echo "  📥 Installing skills..."
  local new=0 upd=0 skip=0
  for skill in "${CORE_SKILLS[@]}"; do
    local src="${SCRIPT_DIR}/skills/${skill}/SKILL.md"
    local tgt="${SKILLS_DIR}/${skill}/SKILL.md"
    [ ! -f "$src" ] && continue
    mkdir -p "${SKILLS_DIR}/${skill}"
    if [ ! -f "$tgt" ]; then
      cp "$src" "$tgt"
      [ -d "${SCRIPT_DIR}/skills/${skill}/scripts" ] && cp -r "${SCRIPT_DIR}/skills/${skill}/scripts" "${SKILLS_DIR}/${skill}/"
      [ -d "${SCRIPT_DIR}/skills/${skill}/references" ] && cp -r "${SCRIPT_DIR}/skills/${skill}/references" "${SKILLS_DIR}/${skill}/"
      echo "     ✅ $skill (new)"
      ((new++))
    elif ! diff -q "$src" "$tgt" >/dev/null 2>&1; then
      cp "$src" "$tgt"
      echo "     ↑  $skill (updated)"
      ((upd++))
    else
      ((skip++))
    fi
  done
  echo "     New: $new | Updated: $upd | Unchanged: $skip"
}

install_agents() {
  echo "  🤖 Installing agents..."
  mkdir -p "$AGENTS_DIR"
  for a in "${AGENT_FILES[@]}"; do
    local src="${SCRIPT_DIR}/.claude/agents/${a}.md"
    local tgt="${AGENTS_DIR}/${a}.md"
    [ ! -f "$src" ] && continue
    if [ -f "$tgt" ] && diff -q "$src" "$tgt" >/dev/null 2>&1; then continue; fi
    [ -f "$tgt" ] && cp "$tgt" "${tgt}.bak"
    cp "$src" "$tgt"
    echo "     ✅ ${a}.md"
  done
}

install_commands() {
  echo "  ⚡ Installing commands..."
  mkdir -p "$COMMANDS_DIR"
  for c in "${COMMAND_FILES[@]}"; do
    local src="${SCRIPT_DIR}/.claude/commands/${c}.md"
    local tgt="${COMMANDS_DIR}/${c}.md"
    [ ! -f "$src" ] && continue
    if [ -f "$tgt" ] && diff -q "$src" "$tgt" >/dev/null 2>&1; then continue; fi
    cp "$src" "$tgt"
    echo "     ✅ ${c}.md"
  done
}

migration_notes() {
  local from="$1"
  [ "$from" = "none" ] || [ "$from" = "legacy" ] && return
  echo ""
  echo "  ═══ What's New ═══"
  [[ "$from" < "5.0.0" ]] && echo "  v5.0: test-architect, aegis-builder, skill-marketplace, MIT License"
  [[ "$from" < "5.1.0" ]] && echo "  v5.1: super-spec (BRD+SRS+UX+PBI engine for Sage)"
  [[ "$from" < "5.2.0" ]] && echo "  v5.2: aegis-orchestrator, 8 subagent definitions, 3 commands"
}

# ═══ Handle flags ═══
case "${1:-}" in
  --check)
    v=$(get_version)
    echo "  Installed: $v"
    echo "  Available: $AEGIS_VERSION"
    [ "$v" = "$AEGIS_VERSION" ] && echo "  ✅ Up to date" || echo "  ⬆️  Run: ./install.sh"
    exit 0 ;;
  --backup)
    do_backup; exit 0 ;;
  --restore)
    if [ -d "$BACKUP_DIR" ]; then
      echo "  Available backups:"
      ls -1 "$BACKUP_DIR" 2>/dev/null | while read b; do
        v="?"; [ -f "${BACKUP_DIR}/$b/.aegis-version" ] && v=$(cat "${BACKUP_DIR}/$b/.aegis-version")
        echo "     $b (v$v)"
      done
      echo ""; echo "  To restore: copy backup skills/ back to $SKILLS_DIR"
    else
      echo "  No backups found."
    fi
    exit 0 ;;
  --diff)
    echo "  Changes that would be applied:"
    ch=0
    for s in "${CORE_SKILLS[@]}"; do
      src="${SCRIPT_DIR}/skills/${s}/SKILL.md"
      tgt="${SKILLS_DIR}/${s}/SKILL.md"
      [ ! -f "$src" ] && continue
      if [ ! -f "$tgt" ]; then echo "     + NEW: $s"; ((ch++))
      elif ! diff -q "$src" "$tgt" >/dev/null 2>&1; then echo "     ↑ UPD: $s"; ((ch++)); fi
    done
    for a in "${AGENT_FILES[@]}"; do
      [ -f "${SCRIPT_DIR}/.claude/agents/${a}.md" ] && [ ! -f "${AGENTS_DIR}/${a}.md" ] && echo "     + NEW: agents/${a}.md" && ((ch++))
    done
    echo "  Total: $ch changes"
    [ "$ch" -eq 0 ] && echo "  ✅ Already up to date!"
    exit 0 ;;
  --help|-h)
    echo "  ./install.sh [dir]      Install or upgrade"
    echo "  ./install.sh --check    Check version"
    echo "  ./install.sh --diff     Preview changes"
    echo "  ./install.sh --backup   Backup current"
    echo "  ./install.sh --restore  List backups"
    echo "  ./install.sh --force    Force reinstall"
    exit 0 ;;
esac

# ═══ Main flow ═══
V=$(get_version)
echo "  Target: $SKILLS_DIR"

case "$V" in
  none)
    echo "  Status: Fresh install"
    echo "" ;;
  legacy)
    echo "  Status: Legacy install (no version file)"
    echo "  ⚠️  Backing up before upgrade..."
    do_backup; save_custom; echo "" ;;
  "$AEGIS_VERSION")
    if [ "$FORCE_MODE" = true ]; then
      echo "  Status: Reinstalling v${AEGIS_VERSION} (force mode)"
    else
      echo "  ✅ Already on v${AEGIS_VERSION}"
      echo "  Use --force to reinstall, --diff to compare files"
      exit 0
    fi ;;
  *)
    echo "  Installed: v${V}"
    echo "  Available: v${AEGIS_VERSION}"
    echo "  ⚠️  Upgrading..."
    do_backup; save_custom; echo "" ;;
esac

install_skills; echo ""
install_agents; echo ""
install_commands; echo ""
restore_custom; echo ""
echo "$AEGIS_VERSION" > "$VERSION_FILE"
migration_notes "$V"

echo ""
echo "  ═══════════════════════════════════════════════"
echo "  ✅ AEGIS v${AEGIS_VERSION} installed!"
echo ""
echo "  Skills:   $(find "$SKILLS_DIR" -maxdepth 2 -name 'SKILL.md' 2>/dev/null | wc -l | tr -d ' ')"
echo "  Agents:   $(ls "$AGENTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')"
echo "  Commands: $(ls "$COMMANDS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')"
echo ""
echo "  🚀 Say: \"Navi, what should I do next?\""
echo "  🔧 Check: ./install.sh --check"
echo "  📦 Backup: ./install.sh --backup"
echo "  ═══════════════════════════════════════════════"
echo ""
