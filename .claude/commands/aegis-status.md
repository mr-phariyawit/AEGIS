---
description: "Check real-time progress of all running AEGIS agents — shows status, progress %, current step, and stall detection"
argument-hint: ""
---

# AEGIS Status — Agent Progress Monitor

Check the progress of all running AEGIS agents by reading their heartbeat files.

## Steps

1. Check if any agents are running:
```bash
ls _aegis-output/.progress/*.json 2>/dev/null | wc -l
```

2. If agents exist, read and display each agent's status:
```bash
for f in _aegis-output/.progress/*.json; do
  echo "---"
  cat "$f" 2>/dev/null
done
```

3. Present a summary table to the user:

| Agent | Status | Progress | Current Step | Health |
|-------|--------|----------|-------------|--------|
| (from progress files) |

4. **Stall detection**: If any agent's `last_active` timestamp is more than 30 seconds old and status is still `running`, warn:
   - "⚠️ [agent] may be stalled — last active [X]s ago"

5. **Completion check**: If all agents show `status: done`, announce:
   - "✅ All agents completed! Report ready at _aegis-output/AEGIS-REPORT.md"

6. If no progress files exist, inform the user:
   - "No agents running. Start with /aegis-pipeline or /aegis-verify"

## Alternative: Terminal Watch

For continuous monitoring in a separate terminal:
```bash
./aegis-watch.sh
```
