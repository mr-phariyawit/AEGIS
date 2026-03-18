---
description: "Run the full AEGIS pipeline — dispatches all agents in parallel for comprehensive project analysis"
argument-hint: "[optional: specific directory or scope]"
---

# AEGIS Full Pipeline

Run a comprehensive project analysis using parallel subagents.

## Setup
Create the output directory:
```bash
mkdir -p _aegis-output
```

## Execution Plan

### Phase 1: Parallel Research (dispatch all 4 simultaneously)

Spawn these agents in parallel using the Task tool:

**Agent 1 — Sage (Standards)**
Use the `sage` agent. Task: "Scan this project for coding standards compliance. Check naming conventions, import order, function length, type safety. Read skills/code-standards/SKILL.md first. Save report to _aegis-output/standards-report.md"

**Agent 2 — Vigil (Code Review)**
Use the `vigil` agent. Task: "Perform a 5-pass code review on files changed in the last 7 days (git diff HEAD~7). Read skills/code-review/SKILL.md first. Save report to _aegis-output/review-report.md"

**Agent 3 — Havoc (Security + Adversarial)**
Use the `havoc` agent. Task: "Run security audit: check for hardcoded secrets, run npm audit or pip audit, check OWASP Top 10 patterns. Also challenge the top 3 architecture decisions using the BREAK framework. Read skills/security-audit/SKILL.md and skills/adversarial-review/SKILL.md first. Save to _aegis-output/security-report.md"

**Agent 4 — Forge (Tech Debt + Git)**
Use the `forge` agent. Task: "Scan for TODO/FIXME markers, complexity hotspots, outdated dependencies. Check git commit message format and branch naming. Read skills/tech-debt-tracker/SKILL.md and skills/git-workflow/SKILL.md first. Save to _aegis-output/debt-report.md"

### Phase 2: Dependent Analysis (after Phase 1 completes)

**Agent 5 — Vigil (Coverage)**
Use the `vigil` agent. Task: "Analyze test coverage focusing on files with critical findings from _aegis-output/review-report.md. Suggest missing test cases. Read skills/code-coverage/SKILL.md. Save to _aegis-output/coverage-report.md"

**Agent 6 — Bolt (API Docs)**
Use the `bolt` agent. Task: "Check if API documentation matches actual endpoints. Report any drift. Read skills/api-docs/SKILL.md. Save to _aegis-output/docs-report.md"

### Phase 3: Synthesis (after Phase 2 completes)

**Agent 7 — Navi (Final Report)**
Use the `navi` agent. Task: "Read ALL reports in _aegis-output/. Produce a unified AEGIS Pipeline Report with: overall health score (0-100), top blockers, recommended actions prioritized by impact, and the next persona to invoke. Save to _aegis-output/AEGIS-REPORT.md"

## After Completion

Read `_aegis-output/AEGIS-REPORT.md` and present the results to the user.
