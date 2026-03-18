---
description: "Run the full AEGIS pipeline — dispatches all agents in parallel with live progress monitoring"
argument-hint: "[optional: specific directory or scope]"
---

# AEGIS Full Pipeline

Run a comprehensive project analysis using parallel subagents with live progress.

## CRITICAL: Show Progress Inline

After dispatching agents, you MUST run the progress monitor so the user can see live updates. Never leave the user staring at a blank screen while agents work.

## Step 1: Setup

```bash
mkdir -p _aegis-output/.progress
rm -f _aegis-output/.progress/*.json
```

## Step 2: Dispatch Phase 1 agents (all 4 in parallel, in background)

Spawn ALL of these as background tasks simultaneously:

**Agent 1 — Sage** (background)
Use the `sage` agent: "Scan this project for coding standards compliance. Check naming, imports, function length, type safety. Read skills/code-standards/SKILL.md first. Write progress to _aegis-output/.progress/sage.json after EVERY step. Save report to _aegis-output/standards-report.md"

**Agent 2 — Vigil** (background)
Use the `vigil` agent: "Perform 5-pass code review on files changed in the last 7 days. Read skills/code-review/SKILL.md first. Write progress to _aegis-output/.progress/vigil.json after EVERY step. Save report to _aegis-output/review-report.md"

**Agent 3 — Havoc** (background)
Use the `havoc` agent: "Run security audit + adversarial review. Read skills/security-audit/SKILL.md and skills/adversarial-review/SKILL.md. Write progress to _aegis-output/.progress/havoc.json after EVERY step. Save to _aegis-output/security-report.md"

**Agent 4 — Forge** (background)
Use the `forge` agent: "Scan TODO/FIXME, complexity, deps, git hygiene. Read skills/tech-debt-tracker/SKILL.md and skills/git-workflow/SKILL.md. Write progress to _aegis-output/.progress/forge.json after EVERY step. Save to _aegis-output/debt-report.md"

## Step 3: Monitor Progress (IMMEDIATELY after dispatching)

While agents work in background, run the inline monitor to show the user live progress:

```bash
bash aegis-monitor.sh 300 5
```

This polls every 5 seconds and prints status updates inline so the user sees:
```
  🛡️ AEGIS — Monitoring agents...
  ─────────────────────────────────────────
  🔄 sage     ████████████░░░░░░░░  60%  scanning src/services
  🔄 vigil    ██████████░░░░░░░░░░  50%  pass 3/5: performance
  ✅ havoc    ████████████████████ 100%  complete
  🔄 forge    ████████░░░░░░░░░░░░  40%  npm audit
  ─────────────────────────────────────────
```

DO NOT skip this step. The user must see progress.

## Step 4: Phase 2 Dependent Analysis

After Phase 1 monitor reports all done, dispatch Phase 2:

Reset progress for phase 2:
```bash
rm -f _aegis-output/.progress/vigil.json _aegis-output/.progress/bolt.json
```

**Agent 5 — Vigil** (Coverage): "Analyze test coverage focusing on critical findings from _aegis-output/review-report.md. Write progress to _aegis-output/.progress/vigil.json. Save to _aegis-output/coverage-report.md"

**Agent 6 — Bolt** (API Docs): "Check API doc drift. Write progress to _aegis-output/.progress/bolt.json. Save to _aegis-output/docs-report.md"

Monitor Phase 2:
```bash
bash aegis-monitor.sh 180 5
```

## Step 5: Synthesis

**Agent 7 — Navi**: "Read ALL reports in _aegis-output/. Produce unified AEGIS Pipeline Report. Save to _aegis-output/AEGIS-REPORT.md"

## Step 6: Present Results

Read `_aegis-output/AEGIS-REPORT.md` and present to the user.
