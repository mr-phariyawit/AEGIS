#!/bin/bash
# ═══════════════════════════════════════════════════════════
# AEGIS Watch — Real-time Agent Progress Monitor
# 
# Usage:
#   ./aegis-watch.sh              # Auto-refresh every 2s
#   ./aegis-watch.sh --once       # Print once and exit
#   ./aegis-watch.sh --json       # Raw JSON output
# ═══════════════════════════════════════════════════════════

PROGRESS_DIR="_aegis-output/.progress"
STALL_THRESHOLD=30  # seconds

print_status() {
  local now=$(date +%s)
  local all_done=true
  local total_agents=0
  local done_agents=0
  local error_agents=0

  echo ""
  echo "  🛡️  AEGIS Agent Status"
  echo "  ══════════════════════════════════════════════════"
  echo ""

  if [ ! -d "$PROGRESS_DIR" ] || [ -z "$(ls -A "$PROGRESS_DIR" 2>/dev/null)" ]; then
    echo "  No agents running. Start with: /aegis-pipeline"
    echo ""
    return
  fi

  printf "  %-10s %-12s %-6s %-30s %s\n" "AGENT" "STATUS" "PROG" "STEP" "HEALTH"
  printf "  %-10s %-12s %-6s %-30s %s\n" "─────" "──────" "────" "────" "──────"

  for f in "$PROGRESS_DIR"/*.json; do
    [ ! -f "$f" ] && continue
    ((total_agents++))

    local name=$(basename "$f" .json)
    local status=$(grep -o '"status":"[^"]*"' "$f" 2>/dev/null | head -1 | cut -d'"' -f4)
    local progress=$(grep -o '"progress":[0-9]*' "$f" 2>/dev/null | head -1 | cut -d: -f2)
    local step=$(grep -o '"step":"[^"]*"' "$f" 2>/dev/null | head -1 | cut -d'"' -f4)
    local last_active=$(grep -o '"last_active":"[^"]*"' "$f" 2>/dev/null | head -1 | cut -d'"' -f4)

    # Default values
    [ -z "$status" ] && status="unknown"
    [ -z "$progress" ] && progress=0
    [ -z "$step" ] && step="..."
    
    # Truncate step to 28 chars
    [ ${#step} -gt 28 ] && step="${step:0:25}..."

    # Build progress bar (10 chars)
    local filled=$((progress / 10))
    local empty=$((10 - filled))
    local bar=""
    for ((i=0; i<filled; i++)); do bar="${bar}█"; done
    for ((i=0; i<empty; i++)); do bar="${bar}░"; done

    # Status icon
    local icon="🔵"
    case "$status" in
      running)  icon="🟢"; all_done=false ;;
      starting) icon="🔵"; all_done=false ;;
      done)     icon="✅"; ((done_agents++)) ;;
      error)    icon="🔴"; ((error_agents++)) ;;
      *)        icon="❓"; all_done=false ;;
    esac

    # Stall detection (Vigil's requirement)
    local health=""
    if [ "$status" = "running" ] && [ -n "$last_active" ]; then
      # Try to parse last_active as HH:MM:SS
      local active_epoch=$(date -d "$last_active" +%s 2>/dev/null || date -j -f "%H:%M:%S" "$last_active" +%s 2>/dev/null)
      if [ -n "$active_epoch" ]; then
        local diff=$((now - active_epoch))
        if [ "$diff" -gt "$STALL_THRESHOLD" ]; then
          health="⚠️  stalled (${diff}s ago)"
        else
          health="♥ ${diff}s ago"
        fi
      fi
    fi

    printf "  %-10s %s %-10s %s %4d%%  %-28s %s\n" "$name" "$icon" "$status" "$bar" "$progress" "$step" "$health"
  done

  echo ""
  echo "  ──────────────────────────────────────────────────"
  echo "  Agents: $total_agents total | $done_agents done | $error_agents errors"
  
  if [ "$all_done" = true ] && [ "$total_agents" -gt 0 ]; then
    echo ""
    echo "  ✅ All agents completed!"
    echo ""
    # Print completion summary
    if [ -f "_aegis-output/AEGIS-REPORT.md" ]; then
      echo "  📊 Report ready: _aegis-output/AEGIS-REPORT.md"
    fi
  fi
  echo ""
}

# Handle flags
case "${1:-}" in
  --once)
    print_status
    exit 0
    ;;
  --json)
    echo "["
    first=true
    for f in "$PROGRESS_DIR"/*.json; do
      [ ! -f "$f" ] && continue
      [ "$first" = false ] && echo ","
      cat "$f"
      first=false
    done
    echo "]"
    exit 0
    ;;
  --help|-h)
    echo "AEGIS Watch — Real-time Agent Progress Monitor"
    echo ""
    echo "Usage:"
    echo "  ./aegis-watch.sh          Auto-refresh every 2s"
    echo "  ./aegis-watch.sh --once   Print once and exit"
    echo "  ./aegis-watch.sh --json   Raw JSON output"
    echo "  ./aegis-watch.sh --help   This help"
    exit 0
    ;;
esac

# Auto-refresh mode
if command -v watch &>/dev/null; then
  watch -n 2 -t "$0 --once"
else
  # Fallback for systems without watch
  while true; do
    clear
    print_status
    sleep 2
  done
fi
