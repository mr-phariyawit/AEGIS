---
name: course-correction
description: "Mid-sprint scope change management — assess impact, re-plan, and adjust sprint when requirements change. Use this skill whenever the user mentions scope change, 'requirements changed', 'client wants something different', 'pivot', 'change of plans', 'new priority', 'drop this feature', 'add this feature', 're-scope', 'course correct', or any situation where the current plan needs to change mid-execution. Also triggers on 'เปลี่ยนสโคป', 'ปรับแผน', 'เปลี่ยนแผน', 'งานด่วนเข้ามา', 'priority เปลี่ยน'. This skill prevents chaotic mid-sprint changes by providing a structured impact assessment and re-planning workflow."
---

# Course Correction

> **"Plans change. The question is whether you change them deliberately or let them drift."**

Structured workflow for handling mid-sprint scope changes, new priorities, and requirement pivots — without derailing the entire sprint.

## When to Trigger

- Client/stakeholder requests a feature change mid-sprint
- Critical bug or incident requires immediate resource reallocation
- New business requirement makes current stories obsolete
- Technical discovery reveals the current approach won't work
- Priority shift from leadership (urgent feature, competitor response)

## Course Correction Process

### Step 1: Capture the Change Request

Document the change clearly before acting:

```markdown
## Change Request

**Requested by:** [person/stakeholder]
**Date:** [date]
**Urgency:** 🔴 Critical / 🟠 High / 🟡 Medium

### What changed?
[Clear description of the new requirement, priority shift, or discovery]

### Why now?
[Business reason — why can't this wait until next sprint?]

### What was the original plan?
[Reference to current sprint stories that are affected]
```

### Step 2: Impact Assessment

Analyze the ripple effect before committing:

```markdown
## Impact Assessment

### Scope Impact
| Aspect | Before | After | Delta |
|--------|--------|-------|-------|
| Sprint stories | 7 | 6 (+1 new, -2 deferred) | -1 net |
| Sprint points | 26 | 22 | -4 points |
| Remaining capacity | 18 pts | 14 pts available | tighter |

### Stories Affected
| Story | Current Status | Proposed Action | Risk |
|-------|---------------|-----------------|------|
| ST-004 Stripe checkout | Not started | ⏸️ Defer to Sprint 4 | Low — no dependencies |
| ST-005 Webhook handler | Not started | ⏸️ Defer to Sprint 4 | Low — depends on ST-004 |
| ST-NEW Emergency feature | N/A | ➕ Add at 5 points | Medium — unknown complexity |

### Dependency Check
- Does the new work depend on anything not yet done? → [yes/no]
- Does deferring stories break dependencies for other stories? → [yes/no]
- Does this change affect the architecture doc? → [yes/no]

### Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| New feature underestimated | Medium | High | Time-box to 3 days max |
| Deferred stories create debt | Low | Medium | Prioritize in Sprint 4 |
| Team context-switching cost | High | Medium | One person handles change, rest continue |

### Estimated Cost of Change
- **Direct:** [X] points of new work
- **Indirect:** [Y] points of rework on existing stories
- **Opportunity cost:** [Z] points of deferred work
- **Total disruption:** [X+Y] points, [N] stories affected
```

### Step 3: Decision Gate

Present options to the decision maker:

```markdown
## Options

### Option A: Accept Change — Defer Other Work
**Do:** Add new feature, defer ST-004 and ST-005 to Sprint 4
**Sprint impact:** -4 points capacity, 1 new story added
**Risk:** Payment integration delayed by 1 sprint
**Recommendation:** ✅ Best option if the new feature is truly urgent

### Option B: Accept Change — Extend Sprint
**Do:** Add new feature, keep all current stories, extend sprint by 3 days
**Sprint impact:** Sprint becomes 17 days instead of 14
**Risk:** Sets precedent for scope creep, team fatigue
**Recommendation:** ⚠️ Only if deadline is truly flexible

### Option C: Reject Change — Queue for Next Sprint
**Do:** Add to Sprint 4 backlog, continue current plan
**Sprint impact:** None
**Risk:** Stakeholder dissatisfaction if truly urgent
**Recommendation:** ✅ Best option if urgency is overstated

### Option D: Partial Change — Minimal Viable Version
**Do:** Implement minimal version now (2 points), full version in Sprint 4
**Sprint impact:** -2 points, defer only ST-005
**Risk:** Minimal version may not satisfy stakeholder
**Recommendation:** ✅ Good compromise for most situations
```

### Step 4: Execute the Correction

Once a decision is made, update all artifacts:

```bash
# 1. Update sprint-status.yaml
#    - Add new stories
#    - Mark deferred stories with status: deferred, deferred_to: "Sprint 4"
#    - Recalculate summary

# 2. Update spec (if requirements changed)
#    - Sage reviews and updates SPEC.md
#    - New story file created for the new work

# 3. Notify the team (personas)
#    - Navi: Update project status
#    - Bolt: New story assignment
#    - Vigil: Adjust review queue

# 4. Log the change for retrospective
#    - Add to change-log.md for retro analysis
```

### Step 5: Change Log Entry

Document every course correction for retrospective analysis:

```markdown
## Change Log

### CC-003: Add emergency analytics dashboard
**Date:** 2026-03-15 | **Sprint:** 3 | **Urgency:** 🟠 High
**Decision:** Option D — Minimal viable version (2 pts now, full in Sprint 4)
**Stories deferred:** ST-005 (Webhook handler)
**Stories added:** ST-NEW-01 (Basic analytics view, 2 pts)
**Impact:** Sprint velocity reduced by ~2 points
**Outcome:** [filled in during retrospective]
```

## Change Types & Response

| Change Type | Response | Typical Impact |
|------------|----------|----------------|
| **New feature request** | Full impact assessment → decision gate | Medium-High |
| **Bug/incident** | Immediate triage → timebox fix → defer if needed | Variable |
| **Requirement clarification** | Update spec → adjust story → continue | Low |
| **Tech discovery** | Spike/investigation → re-estimate → possibly re-architect | High |
| **Priority shift** | Reorder backlog → swap stories → continue sprint | Low-Medium |
| **Scope reduction** | Remove stories → redistribute capacity to quality | Positive |

## Anti-Patterns

### ❌ Things to Avoid

1. **Silent scope creep** — "Just add this small thing" without tracking
2. **Panic-driven changes** — Reacting to every request as "urgent"
3. **No impact assessment** — Accepting changes without understanding cost
4. **Skipping the log** — Not recording changes → retro has no data
5. **Changing everything** — If >50% of sprint changes, it's a new sprint

### ✅ Healthy Change Management

1. Every change goes through the 5-step process
2. Urgency is validated: "Will revenue/users be affected THIS sprint?"
3. Deferral is the default — prove urgency to override
4. Changes are logged and reviewed in retrospective
5. Patterns of frequent changes → trigger architecture review

## Integration with Personas

| Persona | Course Correction Role |
|---------|----------------------|
| 🧭 Navi | Detects sprint is off-track, triggers course-correction |
| 📐 Sage | Updates specs if requirements changed |
| ⚡ Bolt | Receives new/modified story assignments |
| 🛡️ Vigil | Adjusts review queue for changed priorities |
| 🔧 Forge | Updates sprint-status.yaml, logs change for retro |

## Integration with Other Skills

- **From `sprint-tracker`**: Sprint data shows capacity for impact assessment
- **To `spec-kit`**: Requirement changes flow back to update specs
- **To `retrospective`**: Change log analyzed during retro for patterns
- **To `project-navigator`**: Navi incorporates corrections into recommendations
