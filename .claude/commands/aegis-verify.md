---
description: "Run AEGIS verify gate — parallel code review + security + git check with live progress"
argument-hint: "[optional: file or PR to review]"
---

# AEGIS Verify Gate

Pre-merge quality check with live progress monitoring.

## Step 1: Setup
```bash
mkdir -p _aegis-output/.progress
rm -f _aegis-output/.progress/*.json
```

## Step 2: Dispatch 3 agents in parallel (background)

**Vigil** (background): "5-pass code review + test coverage on changed files. Write progress to _aegis-output/.progress/vigil.json after EVERY step. Save to _aegis-output/review-report.md and _aegis-output/coverage-report.md"

**Havoc** (background): "Security audit on changed files — secrets, injection, auth bypass. Write progress to _aegis-output/.progress/havoc.json after EVERY step. Save to _aegis-output/security-report.md"

**Forge** (background): "Validate commit messages, branch naming, PR template. Write progress to _aegis-output/.progress/forge.json after EVERY step. Save to _aegis-output/git-report.md"

## Step 3: Monitor (IMMEDIATELY after dispatch)
```bash
bash aegis-monitor.sh 180 5
```

## Step 4: Present Verdict

Read all reports. Synthesize: **PASS** (no critical) / **WARN** (warnings only) / **FAIL** (critical findings).

## ⚠️ GUARD: Do NOT End Your Turn Early

Your response is NOT complete until you have:
1. Confirmed all agents finished (monitor exited)
2. Read all reports and synthesized PASS/WARN/FAIL verdict
3. Presented the verdict to the user
