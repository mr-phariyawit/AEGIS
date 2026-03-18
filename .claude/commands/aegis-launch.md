---
description: "Run AEGIS launch readiness check — all agents verify production readiness, Navi makes GO/NO-GO decision"
argument-hint: ""
---

# AEGIS Launch Readiness

Full pre-production check. All agents verify their domain, Navi makes the final GO/NO-GO call.

## Setup
```bash
mkdir -p _aegis-output
```

## Execution: 6 agents in parallel, then Navi synthesis

**Parallel dispatch — all 6 simultaneously:**

1. **Sage** — "Check: are all spec requirements implemented? Any undocumented features? Standards compliance score?"
2. **Vigil** — "Check: code review clean? Test coverage meets thresholds (80% overall, 90% auth/payment)? Quality gates pass?"
3. **Havoc** — "Check: security audit clean? No critical/high CVEs? No hardcoded secrets? OWASP Top 10 clear?"
4. **Forge** — "Check: tech debt score acceptable (>=70)? Git hygiene clean? Sprint complete? All stories done?"
5. **Bolt** — "Check: API docs current? No drift between docs and endpoints?"
6. **Navi (pre-scan)** — "Check: 9-criteria readiness checklist. List which criteria pass and which fail."

**After all complete — Navi synthesis:**

"Read ALL reports in _aegis-output/. Make a GO / NO-GO decision with evidence. List blockers for NO-GO. Save to _aegis-output/LAUNCH-DECISION.md"

## Launch Decision Format

```markdown
# 🛡️ AEGIS Launch Decision

## Verdict: ✅ GO / ❌ NO-GO

## Checklist
- [ ] Specs covered: X/Y requirements implemented
- [ ] Standards: X% compliant
- [ ] Code review: X critical, Y warnings
- [ ] Security: X findings (critical: Y)
- [ ] Coverage: X% (target: 80%)
- [ ] Debt score: X (target: >=70)
- [ ] API docs: X endpoints documented, Y drifted
- [ ] Sprint: X/Y stories complete
- [ ] Git: commit messages clean, PR template used

## Blockers (if NO-GO)
[list with assigned persona for each fix]

## Estimated Time to GO
[based on blocker complexity]
```
