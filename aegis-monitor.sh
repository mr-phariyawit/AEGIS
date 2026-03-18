#!/bin/bash
# AEGIS Inline Progress Monitor
# Run by main agent AFTER dispatching subagents
# Polls progress files, prints status, exits when all done
#
# Usage: bash aegis-monitor.sh [timeout_sec] [poll_interval_sec]

DIR="_aegis-output/.progress"
TIMEOUT=${1:-300}
POLL=${2:-5}
ELAPSED=0

mkdir -p "$DIR"

bar() {
  local p=${1:-0}
  local f=$((p/5)) e=$((20-p/5)) b=""
  for ((i=0;i<f;i++)); do b+="█"; done
  for ((i=0;i<e;i++)); do b+="░"; done
  echo "$b"
}

poll() {
  local now=$(date +%s)
  local all_done=true has_agents=false

  for f in "$DIR"/*.json 2>/dev/null; do
    [ ! -f "$f" ] && continue
    has_agents=true

    local n=$(basename "$f" .json)
    local st=$(grep -o '"status":"[^"]*"' "$f" | head -1 | cut -d'"' -f4)
    local pc=$(grep -o '"progress":[0-9]*' "$f" | head -1 | cut -d: -f2)
    local sp=$(grep -o '"step":"[^"]*"' "$f" | head -1 | cut -d'"' -f4)

    st=${st:-starting}; pc=${pc:-0}; sp=${sp:-init}
    [ ${#sp} -gt 30 ] && sp="${sp:0:27}..."

    local ico="⏳" health=""
    case "$st" in
      running)  ico="🔄"; all_done=false ;;
      starting) ico="🔵"; all_done=false ;;
      done)     ico="✅" ;;
      error)    ico="❌" ;;
      *)        ico="❓"; all_done=false ;;
    esac

    # Stall check via file mtime
    local age=$(( now - $(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null || echo "$now") ))
    [ "$st" = "running" ] && [ "$age" -gt 30 ] && health=" ⚠️ stall(${age}s)"

    printf "  %s %-8s %s %3d%%  %s%s\n" "$ico" "$n" "$(bar $pc)" "$pc" "$sp" "$health"
  done

  $has_agents || { echo "  ⏳ Waiting for agents to start..."; return 1; }
  $all_done && return 0
  return 1
}

echo ""
echo "  🛡️ AEGIS — Monitoring agents..."
echo "  ─────────────────────────────────────────"

while [ "$ELAPSED" -lt "$TIMEOUT" ]; do
  poll && break
  sleep "$POLL"
  ELAPSED=$((ELAPSED + POLL))
  echo "  ─────────────────────────────────────────"
done

echo ""
if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
  echo "  ⚠️ Timeout (${TIMEOUT}s). Check /aegis-status"
else
  echo "  ✅ All agents done! (${ELAPSED}s)"
fi
echo ""
