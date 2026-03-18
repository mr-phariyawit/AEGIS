---
description: "Run AEGIS launch readiness — all agents verify production readiness with live progress, Navi makes GO/NO-GO"
argument-hint: ""
---

# AEGIS Launch Readiness

Full pre-production check with live progress. All agents verify, Navi decides.

## Step 1: Setup
```bash
mkdir -p _aegis-output/.progress
rm -f _aegis-output/.progress/*.json
```

## Step 2: Dispatch 6 agents in parallel (all background)

1. **Sage** (bg): "All spec requirements implemented? Standards compliance score? Progress → _aegis-output/.progress/sage.json"
2. **Vigil** (bg): "Code review clean? Coverage meets 80%/90% thresholds? Progress → _aegis-output/.progress/vigil.json"
3. **Havoc** (bg): "Security audit clean? No critical CVEs? No secrets? Progress → _aegis-output/.progress/havoc.json"
4. **Forge** (bg): "Debt score ≥70? Git clean? Sprint complete? Progress → _aegis-output/.progress/forge.json"
5. **Bolt** (bg): "API docs current? No drift? Progress → _aegis-output/.progress/bolt.json"
6. **Navi pre-scan** (bg): "9-criteria readiness checklist. Progress → _aegis-output/.progress/navi.json"

## Step 3: Monitor (IMMEDIATELY)
```bash
bash aegis-monitor.sh 300 5
```

## Step 4: Navi Synthesis

After all done, dispatch Navi: "Read ALL reports. Make GO / NO-GO decision with evidence. Save to _aegis-output/LAUNCH-DECISION.md"

## Step 5: Present Decision

Read `_aegis-output/LAUNCH-DECISION.md` and present the verdict.
