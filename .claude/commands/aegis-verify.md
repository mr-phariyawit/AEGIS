---
description: "Run AEGIS verify gate — parallel code review + security audit + git check before merge"
argument-hint: "[optional: file or PR to review]"
---

# AEGIS Verify Gate

Pre-merge quality check using parallel subagents.

## Setup
```bash
mkdir -p _aegis-output/.progress
```

## Execution: Dispatch 3 agents in parallel

**Agent 1 — Vigil (Review + Coverage)**
Use the `vigil` agent. Task: "Perform 5-pass code review on staged/changed files. Then analyze test coverage on critical paths. Read skills/code-review/SKILL.md and skills/code-coverage/SKILL.md. Save review to _aegis-output/review-report.md and coverage to _aegis-output/coverage-report.md"

**Agent 2 — Havoc (Security)**
Use the `havoc` agent. Task: "Run security audit on changed files. Check for secrets, injection patterns, auth bypasses. Read skills/security-audit/SKILL.md. Save to _aegis-output/security-report.md"

**Agent 3 — Forge (Git Hygiene)**
Use the `forge` agent. Task: "Validate commit messages follow conventional commits format. Check branch naming. Verify PR template is filled. Read skills/git-workflow/SKILL.md. Save to _aegis-output/git-report.md"

## After Completion

Synthesize results and report: PASS (no critical) / WARN (warnings only) / FAIL (critical findings).
