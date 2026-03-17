---
name: retrospective
description: "Sprint and epic retrospective — analyze what worked, what didn't, and generate actionable improvements. Use this skill whenever the user mentions retrospective, retro, 'what went well', 'what went wrong', 'lessons learned', sprint review, epic review, post-mortem, 'how did the sprint go', continuous improvement, or any request to reflect on completed work and extract process improvements. Also triggers on 'ย้อนดูสปรินท์', 'สรุปบทเรียน', 'อะไรดี อะไรแย่', 'retro', 'ทบทวน'. Run this after completing an epic or at the end of each sprint."
---

# Retrospective

> **"We don't get better by working harder. We get better by reflecting smarter."**

Structured retrospective analysis for sprints and epics. Extracts lessons, identifies patterns, and generates actionable improvements that feed back into the PLAN phase.

## When to Run

- **End of every sprint** — quick retrospective (15-min analysis)
- **End of every epic** — full retrospective (deep analysis)
- **After incidents** — post-mortem retrospective
- **Quarterly** — trend analysis across multiple sprints

## Process

### Step 1: Gather Data

Read from available artifacts:

```
sprint-status.yaml    → velocity, completion rate, blocked stories
git log               → commit frequency, PR merge times, hotfix count
code-review reports   → finding density, severity trends
code-coverage reports → coverage delta this sprint
tech-debt reports     → debt score change, new vs resolved
```

### Step 2: Generate Retrospective Report

**Output format:**

```markdown
# Retrospective — Sprint [N] / Epic [name]
**Period:** [start] – [end]
**Facilitator:** 🔧 Forge

---

## 📊 Sprint Metrics

| Metric | This Sprint | Last Sprint | Trend |
|--------|------------|-------------|-------|
| Velocity (points) | 18 | 21 | ↓ -14% |
| Stories completed | 5/7 | 6/6 | ↓ |
| Completion rate | 71% | 100% | ↓ |
| Avg cycle time | 2.3 days | 1.8 days | ↑ slower |
| Blocked time | 3 days | 0 days | ↑ worse |
| Code review findings | 12 | 8 | ↑ more issues |
| Coverage delta | +3% | +7% | ↓ less testing |
| Debt score | 68 → 65 | 72 → 68 | ↓ debt growing |

---

## ✅ What Went Well

### 1. Auth implementation was clean
ST-001 (Email login) shipped ahead of schedule with 94% test coverage.
Sage's spec was detailed enough that Bolt needed zero clarification.
**Keep doing:** Detailed specs with acceptance criteria reduce back-and-forth.

### 2. Security audit caught real issues
Havoc found the localStorage token vulnerability before launch.
Estimated cost avoided: 2-3 days of hotfix + potential data exposure.
**Keep doing:** Run security-audit on every auth-related change.

### 3. PR template reduced review friction
Forge's PR template (from git-workflow) meant Vigil had full context
for every review. Average review time dropped from 45min to 20min.
**Keep doing:** Enforce PR template via git hooks.

---

## ❌ What Didn't Go Well

### 1. ST-002 (JWT refresh) took 3x longer than estimated
**Root cause:** Spec didn't address concurrent refresh edge case.
Bolt discovered it mid-implementation, requiring Sage to re-spec.
**Action:** Sage should include concurrency analysis for all auth flows.
**Owner:** 📐 Sage | **Due:** Next sprint planning

### 2. Two stories carried over to next sprint
**Root cause:** ST-004 (8 points) was too large. Should have been split.
**Action:** No story > 5 points. Split anything larger during planning.
**Owner:** 🧭 Navi | **Due:** Enforce in sprint-tracker

### 3. Tech debt increased (68 → 65)
**Root cause:** Zero debt items addressed. All capacity went to features.
**Action:** Reserve 20% of sprint capacity for debt reduction.
**Owner:** 🔧 Forge | **Due:** Next sprint allocation

---

## 🔄 What to Change

| # | Action Item | Owner | Priority | Due |
|---|------------|-------|----------|-----|
| 1 | Add concurrency analysis to auth specs | 📐 Sage | High | Sprint 4 |
| 2 | Max story size: 5 points (split larger) | 🧭 Navi | High | Permanent |
| 3 | 20% sprint capacity for tech debt | 🔧 Forge | High | Sprint 4 |
| 4 | Run adversarial-review on all auth changes | 🔴 Havoc | Medium | Permanent |
| 5 | Add estimation calibration (actual vs estimate) | 🔧 Forge | Low | Sprint 5 |

---

## 📈 Trends (Last 3 Sprints)

| Metric | S1 | S2 | S3 | Trend |
|--------|----|----|----|----|
| Velocity | 18 | 21 | 18 | Flat |
| Completion | 90% | 100% | 71% | ↓ Declining |
| Coverage | 62% | 69% | 72% | ↑ Improving |
| Debt score | 75 | 72 | 65 | ↓ Worsening |
| Review findings/story | 1.2 | 1.5 | 2.4 | ↑ More issues |

### Pattern detected: ⚠️ Quality-velocity trade-off
Coverage improves but review findings increase — team may be writing
more tests for the wrong things. Vigil should focus coverage on
critical paths (auth, payments) not utility functions.

---

## 🎯 Sprint [N+1] Recommendations

1. **Carry over:** ST-004 (split into ST-004a + ST-004b, 3+5 pts)
2. **Debt allocation:** 4 points reserved for top tech-debt items
3. **Focus area:** Complete EP-001 (1 story left) before starting EP-003
4. **Process change:** Stories > 5 points auto-flagged for splitting
```

## Retrospective Types

### Quick Retro (End of Sprint)
- 10-minute automated analysis
- Metrics comparison vs previous sprint
- Top 3 went-well / Top 3 issues
- Action items for next sprint

### Full Retro (End of Epic)
- Deep analysis of entire epic delivery
- Architecture decision validation (did Sage's plan hold up?)
- Estimation accuracy (actual vs estimated points)
- Quality gate effectiveness (what did each VERIFY skill catch?)
- Process improvements for next epic

### Post-Mortem (After Incident)
- Timeline of events
- Root cause analysis (5 Whys)
- What early warning signs were missed
- Which skills/personas should have caught this
- Prevention measures

## Feedback Loop Integration

Retrospective outputs feed directly into the next PLAN cycle:

```
Retrospective action items
    ↓
Navi reads action items during project-navigator scan
    ↓
Sage incorporates lessons into next spec
    ↓
Sprint-tracker applies new rules (max story size, debt allocation)
    ↓
Next sprint is better
    ↓
Repeat
```

This completes the SDLC+AI infinite loop — FEEDBACK phase data directly improves the PLAN phase.

## Integration with Personas

| Persona | Retrospective Role |
|---------|-------------------|
| 🔧 Forge | Primary facilitator — runs the retro, generates report |
| 🧭 Navi | Reads retro output, incorporates into next recommendations |
| 📐 Sage | Reviews spec quality feedback, adjusts spec approach |
| 🛡️ Vigil | Reviews quality gate effectiveness data |
| 🔴 Havoc | Reviews what security/design issues were missed |
