---
name: sprint-tracker
description: "Sprint planning, story management, and progress tracking using YAML-based sprint status files. Use this skill whenever the user mentions sprint, sprint planning, story tracking, 'create a story', 'start sprint', 'sprint status', 'what stories are left', backlog, velocity, burndown, epic progress, 'plan the sprint', or any request related to organizing, tracking, and managing work items in sprints. Also triggers on 'วางแผนสปรินท์', 'สถานะสปรินท์', 'สร้าง story', 'แพลนงาน', 'จัดลำดับงาน'. This skill bridges the gap between specs (from spec-kit) and implementation (autonomous-coding) by organizing work into trackable, prioritized units."
---

# Sprint Tracker

> **"Specs become stories. Stories become sprints. Sprints become shipped code."**

Organize work from specs into epics and stories, plan sprints, track progress, and maintain velocity — all in Markdown and YAML that AI agents can read and act on.

## Core Artifacts

### sprint-status.yaml

The single source of truth for all sprint work:

```yaml
project: "Project Name"
current_sprint: 3
sprint_duration_weeks: 2
started: "2026-03-10"
ends: "2026-03-24"

epics:
  - id: EP-001
    title: "User Authentication"
    status: in_progress  # not_started | in_progress | done
    stories:
      - id: ST-001
        title: "Email/password login"
        points: 3
        status: done
        assignee: Bolt
        completed: "2026-03-12"

      - id: ST-002
        title: "JWT refresh token rotation"
        points: 5
        status: in_progress
        assignee: Bolt
        blocked_by: null

      - id: ST-003
        title: "OAuth2 Google login"
        points: 5
        status: not_started
        assignee: null
        depends_on: ST-001

  - id: EP-002
    title: "Payment Integration"
    status: not_started
    stories:
      - id: ST-004
        title: "Stripe checkout flow"
        points: 8
        status: not_started
      - id: ST-005
        title: "Webhook handler"
        points: 5
        status: not_started

velocity:
  sprint_1: 18
  sprint_2: 21
  sprint_3: null  # current, calculated at end

summary:
  total_points: 26
  completed_points: 3
  in_progress_points: 5
  remaining_points: 18
  completion_pct: 11.5
```

## Capabilities

### 1. Initialize Sprint Planning

From a spec or task breakdown, generate the initial `sprint-status.yaml`:

**Input:** SPEC.md, IMPLEMENTATION_PLAN.md, or TASK_BREAKDOWN.md from spec-kit
**Output:** sprint-status.yaml with epics, stories, and point estimates

**Process:**
1. Read spec/plan artifacts
2. Group tasks into logical epics
3. Break epics into implementable stories (each completable in 1-2 days)
4. Estimate story points (Fibonacci: 1, 2, 3, 5, 8, 13)
5. Set dependencies between stories
6. Generate sprint-status.yaml

**Story sizing guide:**
| Points | Effort | Example |
|--------|--------|---------|
| 1 | < 2 hours | Config change, copy update |
| 2 | 2-4 hours | Simple CRUD endpoint |
| 3 | 4-8 hours | Feature with validation + tests |
| 5 | 1-2 days | Complex feature, multiple files |
| 8 | 2-3 days | Integration, architecture change |
| 13 | 3-5 days | Major feature — consider splitting |

### 2. Sprint Status Report

Generate a human-readable status from sprint-status.yaml:

```markdown
# Sprint 3 Status Report
**Period:** Mar 10 – Mar 24, 2026
**Day:** 8 of 14 (57% elapsed)

## Progress
███████░░░░░░░░░░░░░ 11.5% complete (3 of 26 points)

⚠️ **Behind pace** — expected 57% at this point

## By Epic

### EP-001: User Authentication (1/3 stories done)
| Story | Points | Status | Assignee |
|-------|--------|--------|----------|
| ST-001 Email/password login | 3 | ✅ Done | Bolt |
| ST-002 JWT refresh rotation | 5 | 🔄 In progress | Bolt |
| ST-003 OAuth2 Google login | 5 | ⬜ Not started | — |

### EP-002: Payment Integration (0/2 stories done)
| Story | Points | Status | Assignee |
|-------|--------|--------|----------|
| ST-004 Stripe checkout flow | 8 | ⬜ Not started | — |
| ST-005 Webhook handler | 5 | ⬜ Not started | — |

## Velocity Trend
| Sprint | Points | Trend |
|--------|--------|-------|
| Sprint 1 | 18 | baseline |
| Sprint 2 | 21 | +16.7% ↑ |
| Sprint 3 | 3 (so far) | projected: 16 ↓ |

## Risks
- 🔴 Behind pace — need 23 points in 6 remaining days
- 🟡 ST-003 depends on ST-001 (done) — can start immediately
- 🟡 EP-002 not started — may need to defer to Sprint 4

## Recommendations
1. **Focus:** Complete ST-002 today, start ST-003 tomorrow
2. **Defer:** Move ST-004 + ST-005 to Sprint 4 if ST-002 takes >1 more day
3. **Scope:** Consider splitting ST-004 (8 points) into smaller stories
```

### 3. Create Story

Generate a story file ready for implementation:

```markdown
# ST-002: JWT Refresh Token Rotation

## Context
**Epic:** EP-001 User Authentication
**Points:** 5
**Depends on:** ST-001 (Email/password login) — ✅ Done
**Sprint:** 3

## Requirements
From SPEC.md section 3.2:
- Access tokens expire after 15 minutes
- Refresh tokens are single-use with 7-day expiry
- Rotation: issuing a new access token invalidates the old refresh token
- Store refresh tokens in httpOnly secure cookies (not localStorage)

## Acceptance Criteria
- [ ] POST /auth/refresh returns new access + refresh token pair
- [ ] Old refresh token is invalidated after use
- [ ] Expired refresh token returns 401 with clear error
- [ ] Concurrent refresh requests don't create duplicate tokens
- [ ] Refresh tokens stored in httpOnly cookie, not response body
- [ ] Unit tests cover: valid refresh, expired token, reuse detection, concurrent use

## Technical Notes
- Use Redis for refresh token store (fast invalidation)
- Add rate limiting: max 5 refresh requests per minute per user
- Log all refresh events for security audit trail

## Definition of Done
- [ ] All acceptance criteria pass
- [ ] Code reviewed by Vigil
- [ ] Test coverage > 90% for auth refresh flow
- [ ] API docs updated
```

### 4. Update Sprint Status

After a story is completed or status changes:

```bash
# Mark story as done
# Update sprint-status.yaml: ST-002 status → done, completed date → today

# Recalculate summary
# total_points: 26, completed_points: 8, completion_pct: 30.8
```

### 5. Sprint Velocity & Forecasting

Track velocity over time and forecast completion:

```markdown
## Velocity & Forecast

**Average velocity:** 19.5 points/sprint (last 2 sprints)
**Remaining work:** 42 points across 3 epics
**Estimated sprints to complete:** 2.15 → 3 sprints (with buffer)
**Estimated completion:** Sprint 6 (Apr 21, 2026)
```

## Story Lifecycle

```
not_started → in_progress → in_review → done
                    ↓
                 blocked (with blocked_by reference)
```

## Integration with Personas

| Persona | Sprint Tracker Role |
|---------|-------------------|
| 🧭 Navi | Triggers sprint status as part of project scan |
| 📐 Sage | Creates initial epics/stories from specs |
| ⚡ Bolt | Picks up stories, marks in_progress → done |
| 🛡️ Vigil | Story moves to in_review after Bolt completes |
| 🔧 Forge | Tracks velocity trends, flags capacity issues |

## Integration with Other Skills

- **From `spec-kit`**: Specs → epics and stories (PLAN → sprint-tracker)
- **To `autonomous-coding`**: Story file → implementation input
- **From `code-review`**: Review complete → story moves to done
- **To `retrospective`**: Sprint data → retro analysis
- **To `project-navigator`**: Sprint status feeds Navi's recommendations
