---
name: bug-lifecycle
description: "Complete bug lifecycle management — triage, reproduce, root cause analysis, fix, retest, verify, and post-mortem. Use this skill whenever the user mentions bug, debug, 'fix this', error, crash, 'not working', reproduce, root cause, regression, hotfix, incident, 'something broke', stack trace, exception, 500 error, failed test, flaky test, or any request to investigate, diagnose, fix, and verify a software defect. Also triggers on 'แก้บั๊ก', 'debug', 'หาสาเหตุ', 'มีปัญหา', 'พัง', 'ทำไมไม่ทำงาน', 'เทสต์ไม่ผ่าน', 'error', 'แก้ไข'. This skill provides a structured 7-stage workflow that prevents the common mistake of jumping straight to 'fix' without understanding the problem. Trigger this even for seemingly simple bugs — the structured approach catches hidden issues."
---

# Bug Lifecycle — Debug, Reproduce, Fix, Retest

> **"Don't fix the symptom. Fix the cause. Then prove it's fixed."**

A structured 7-stage workflow for handling software defects — from initial report to verified fix to prevention. This skill prevents the most common debugging mistakes: jumping to conclusions, fixing symptoms instead of causes, and shipping fixes without regression testing.

## Why a Structured Approach?

Most developers jump straight from "it's broken" to writing a fix. This causes:
- **Wrong fix** — addressing a symptom, not the root cause
- **New bugs** — fix breaks something else (no regression test)
- **Recurring bugs** — same root cause manifests differently later
- **Time waste** — 3 hours debugging → 5-minute fix → 2 hours debugging the fix

The 7-stage workflow ensures: **understand → reproduce → diagnose → fix → verify → prevent**

## The 7 Stages

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│ 1.REPORT │──▶│2.REPRO   │──▶│3.ROOT    │──▶│ 4.FIX    │
│ & TRIAGE │   │  DUCE    │   │ CAUSE    │   │          │
└──────────┘   └──────────┘   └──────────┘   └──────────┘
                                                   │
┌──────────┐   ┌──────────┐   ┌──────────┐        │
│7.PREVENT │◀──│6.VERIFY  │◀──│5.RETEST  │◀───────┘
│          │   │ STAGING  │   │          │
└──────────┘   └──────────┘   └──────────┘
```

---

## Stage 1: Report & Triage

**Goal:** Capture enough information to reproduce the bug. Assess severity and priority.

### Bug Report Template

```markdown
## Bug Report: [BUG-NNN] [Short descriptive title]

### Summary
[One sentence: what's wrong, where, and impact]

### Environment
- **App version:** [version/commit]
- **Platform:** [browser/OS/device]
- **User role:** [admin/member/guest]
- **Environment:** [production/staging/local]
- **Timestamp:** [when first observed]

### Steps to Reproduce
1. [Exact step 1]
2. [Exact step 2]
3. [Exact step 3]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens — include exact error message]

### Evidence
- [ ] Screenshot/screen recording
- [ ] Browser console log
- [ ] Server error log / stack trace
- [ ] Network tab (request/response)
- [ ] Affected user count / frequency

### Severity & Priority
- **Severity:** 🔴 Critical / 🟠 High / 🟡 Medium / 🔵 Low
- **Priority:** P0 (now) / P1 (today) / P2 (this sprint) / P3 (backlog)
- **Affected users:** [count or percentage]
- **Workaround available:** [yes/no — describe if yes]
```

### Triage Decision Matrix

| Severity | Affected Users | Data Loss? | Priority | Action |
|----------|---------------|-----------|----------|--------|
| 🔴 Critical | Many | Yes | **P0** | Drop everything. Hotfix now. |
| 🔴 Critical | Few | No | **P1** | Fix today. Apply workaround. |
| 🟠 High | Many | No | **P1** | Fix today or tomorrow. |
| 🟠 High | Few | No | **P2** | Fix this sprint. |
| 🟡 Medium | Any | No | **P2** | Fix this sprint. |
| 🔵 Low | Any | No | **P3** | Backlog. Fix when convenient. |

### Triage Checklist
- [ ] Can you reproduce it? (if no → need more info, don't proceed)
- [ ] Is it a regression? (worked before, broken now → check recent commits)
- [ ] Is there a workaround? (document it for affected users)
- [ ] Who should fix it? (assign based on code ownership)
- [ ] Does it affect other areas? (blast radius assessment)

---

## Stage 2: Reproduce

**Goal:** Create a reliable, minimal reproduction that triggers the bug every time.

### Reproduction Strategy

```markdown
## Reproduction Attempt: [BUG-NNN]

### Reproduction Status: ✅ Reproduced / ❌ Cannot reproduce / ⚠️ Intermittent

### Environment Used
- Local / Staging / Production
- DB state: [fresh seed / copy of production / specific data]
- Feature flags: [list relevant flags and their states]

### Minimal Reproduction Steps
1. [Simplest possible step 1]
2. [Simplest possible step 2]
3. [Bug appears]

### What I Stripped Away (not needed to reproduce)
- [Not related to user role — happens for all roles]
- [Not related to browser — happens on Chrome and Firefox]
- [Not related to data size — happens with 1 record]

### Reproduction Rate
- [X] out of [Y] attempts → [percentage]%

### Automated Reproduction (failing test)
```typescript
describe('BUG-NNN: [descriptive name]', () => {
  it('should [expected behavior] but currently [actual behavior]', () => {
    // Arrange: set up the exact condition
    // Act: perform the action that triggers the bug
    // Assert: verify the bug is present (this test SHOULD FAIL)
  });
});
```
```

### Reproduction Techniques

**For reproducible bugs:**
1. Start with the reported steps
2. Strip away variables one by one until you find the minimal reproduction
3. Write it as a failing test (this becomes your regression test later)

**For intermittent bugs:**
1. Increase sample size (run 100 times, not 3)
2. Check timing dependencies (race conditions, async order)
3. Check data dependencies (specific values, edge cases, null/empty)
4. Check state dependencies (previous operations affecting current)
5. Add logging at suspected points to capture the failing state
6. Try stress testing: parallel requests, rapid clicking, slow network

**For production-only bugs:**
1. Compare environment configs (env vars, feature flags, DB version)
2. Check production data patterns (sizes, characters, null fields)
3. Check traffic patterns (concurrent requests, request order)
4. Check infrastructure (memory pressure, disk space, connection pool)

### Cannot Reproduce?

If you truly cannot reproduce after exhaustive attempts:
- Add defensive logging around the suspected area
- Add monitoring/alerting for the error condition
- Ask the reporter for screen recording or network logs
- Check if the bug has already been fixed by another change
- Mark as "Cannot Reproduce" with detailed notes on what you tried

---

## Stage 3: Root Cause Analysis

**Goal:** Understand WHY the bug happens, not just WHERE.

### The 5 Whys Technique

```markdown
## Root Cause Analysis: [BUG-NNN]

### The 5 Whys

1. **Why** does the payment fail?
   → Because the API returns 500 when amount is 0.01

2. **Why** does the API return 500 for 0.01?
   → Because the amount is multiplied by 100 to convert to cents, giving 0.999... 
   which fails integer validation

3. **Why** does 0.01 × 100 give 0.999...?
   → Floating point arithmetic: 0.01 * 100 = 0.9999999999999999 in JavaScript

4. **Why** is floating point used for money?
   → The amount field is typed as `number` instead of using integer cents

5. **Why** is it typed as `number`?
   → Original implementation didn't consider sub-unit precision

### Root Cause
**Floating point arithmetic for monetary values.** The system stores and
calculates money as floating-point numbers instead of integer cents (satang).
This causes rounding errors at specific amounts.

### Root Cause Category
- [ ] Logic error (wrong algorithm/condition)
- [x] Data type error (wrong type for the domain)
- [ ] Race condition (timing/concurrency)
- [ ] Missing validation (input not checked)
- [ ] Missing error handling (error not caught)
- [ ] Configuration error (wrong env/setting)
- [ ] Integration error (API contract mismatch)
- [ ] State management error (stale/corrupted state)

### Blast Radius
- **Direct:** Payment amounts with fractional satang (0.01, 0.03, etc.)
- **Indirect:** Any calculation using the amount field (totals, fees, splits)
- **Files affected:** payment-service.ts, fee-calculator.ts, receipt-generator.ts

### Is This a Systemic Issue?
[Yes — every money calculation in the system uses float. This is one
manifestation of a broader architectural issue.]
```

### RCA Techniques by Bug Type

| Bug Type | Technique | Tools |
|----------|-----------|-------|
| **Logic error** | Trace execution with breakpoints / log | Debugger, console.log, test with known values |
| **Race condition** | Add delays, change execution order, stress test | Artillery, k6, artificial delays |
| **Memory leak** | Heap snapshots over time, GC analysis | Chrome DevTools, `--inspect`, heapdump |
| **Performance** | Profile CPU, identify hot paths | Flame graphs, clinic.js, py-spy |
| **Data corruption** | Trace data lineage, find mutation point | DB audit log, event replay |
| **Integration** | Compare expected vs actual API contract | Request/response logging, contract tests |
| **Flaky test** | Run 50x, check for timing/state/data deps | `--repeat`, `jest --bail`, seed analysis |

---

## Stage 4: Fix

**Goal:** Fix the root cause (not the symptom), with minimal blast radius.

### Fix Strategy Document

```markdown
## Fix Plan: [BUG-NNN]

### Approach
**Option A (Recommended):** Migrate all monetary values to integer cents
- Scope: payment-service, fee-calculator, receipt-generator, DB migration
- Risk: Medium — touches financial logic
- Effort: 4 hours
- Prevents recurrence: ✅ Yes — eliminates the category of bug

**Option B (Quick):** Add rounding at the conversion point
- Scope: payment-service only (1 line)
- Risk: Low — minimal change
- Effort: 15 minutes
- Prevents recurrence: ❌ No — other calculations still use float

### Decision: [Option A / Option B]
Rationale: [Why this option — consider urgency vs completeness]

### Implementation Checklist
- [ ] Write failing test FIRST (from Stage 2 reproduction)
- [ ] Implement the fix
- [ ] Run failing test → should now PASS
- [ ] Run full test suite → no regressions
- [ ] Check blast radius files (listed in RCA)
- [ ] Update related documentation if behavior changes
- [ ] Self-review: does this fix the root cause, not just the symptom?
```

### Fix Rules

1. **Write the failing test BEFORE fixing** — if you can't write a test that fails, you don't understand the bug yet
2. **Fix the root cause** — if the root cause is "float for money," fix ALL money calculations, not just this one
3. **Minimize blast radius** — smallest change that fixes the root cause
4. **One fix per commit** — isolate the fix from unrelated changes
5. **Commit message format:** `fix(scope): [BUG-NNN] short description`

### Fix Anti-Patterns

| Anti-Pattern | Why It's Bad | Do This Instead |
|-------------|-------------|----------------|
| Fix without reproduction | You might fix the wrong thing | Reproduce first, always |
| Fix the symptom | Bug returns in different form | Fix the root cause |
| Fix + refactor in one PR | Can't isolate if something breaks | Separate PRs |
| Fix without test | No proof it's fixed, no regression guard | Write test first |
| Hotfix bypass review | Risky code goes to production | Even hotfixes get review |

---

## Stage 5: Retest

**Goal:** Prove the fix works AND nothing else broke.

### Retest Checklist

```markdown
## Retest Report: [BUG-NNN]

### Fix Verification
- [ ] Reproduction test now PASSES (the test from Stage 2)
- [ ] Tried the original reproduction steps manually → bug is gone
- [ ] Tested with the specific data/conditions from the original report

### Regression Testing
- [ ] Full unit test suite passes
- [ ] Integration tests pass for affected modules
- [ ] Related features tested (blast radius from RCA):
  - [ ] [Related feature 1] → works
  - [ ] [Related feature 2] → works
  - [ ] [Related feature 3] → works

### Edge Case Testing
- [ ] Original edge case that caused the bug
- [ ] Adjacent edge cases:
  - [ ] Zero value
  - [ ] Maximum value
  - [ ] Negative value (if applicable)
  - [ ] Null/undefined input
  - [ ] Concurrent operations (if race condition was involved)

### Test Results
| Test Suite | Before Fix | After Fix | Status |
|-----------|-----------|----------|--------|
| Unit (payment) | 45/46 ❌ | 46/46 ✅ | Fixed |
| Unit (all) | 340/342 ❌ | 342/342 ✅ | Fixed |
| Integration | 85/87 ❌ | 87/87 ✅ | Fixed |
| E2E | 14/15 ❌ | 15/15 ✅ | Fixed |
```

### Regression Test Creation

Every bug fix MUST add at least one permanent regression test:

```typescript
// This test MUST exist in the codebase permanently
describe('BUG-123: Payment with fractional amounts', () => {
  it('should handle 0.01 THB without floating point error', () => {
    const result = processPayment({ amount: 0.01, currency: 'THB' });
    expect(result.amountInSatang).toBe(1); // Not 0.999...
    expect(result.status).toBe('success');
  });

  it('should handle amounts that cause float rounding', () => {
    // These specific values are known to cause float issues
    const problematicAmounts = [0.01, 0.02, 0.03, 0.06, 0.07, 0.08, 0.1 + 0.2];
    for (const amount of problematicAmounts) {
      const result = processPayment({ amount, currency: 'THB' });
      expect(result.amountInSatang).toBe(Math.round(amount * 100));
    }
  });
});
```

---

## Stage 6: Verify in Staging

**Goal:** Confirm the fix works in a production-like environment.

### Staging Verification

```markdown
## Staging Verification: [BUG-NNN]

### Deployment
- [ ] Fix deployed to staging environment
- [ ] Staging environment matches production config
- [ ] Staging has representative data

### Verification Steps
1. [ ] Reproduced original bug on staging BEFORE deploying fix
2. [ ] Deployed fix to staging
3. [ ] Ran original reproduction steps → bug no longer present
4. [ ] Ran smoke tests for affected features
5. [ ] Checked logs for unexpected errors
6. [ ] Monitored for 15 minutes — no anomalies

### Production Deployment Plan
- **Strategy:** [Normal deploy / Canary / Blue-green / Feature flag]
- **Rollback trigger:** [What metric/error would trigger rollback?]
- **Rollback procedure:** [Revert commit / Toggle flag / Restore DB]
- **Monitoring:** [What dashboards/alerts to watch after deploy?]
- **Watch period:** [How long to monitor after production deploy?]
```

### Production Verification (after deploy)

```markdown
### Post-Deploy Check
- [ ] Fix verified in production with real conditions
- [ ] Error rate: [before] → [after] (should decrease)
- [ ] No new error types in logs
- [ ] Performance metrics stable (latency, throughput)
- [ ] User-reported issue resolved (close ticket / notify reporter)
- [ ] Watch period complete — no regressions detected
```

---

## Stage 7: Prevent

**Goal:** Learn from this bug so it never happens again.

### Bug Post-Mortem (for P0/P1 bugs)

```markdown
## Post-Mortem: [BUG-NNN]

### Timeline
| Time | Event |
|------|-------|
| Mon 09:15 | User reports payment failure |
| Mon 09:30 | Bug triaged as P1 |
| Mon 10:00 | Reproduced locally |
| Mon 10:30 | Root cause identified (floating point) |
| Mon 11:00 | Fix implemented + tests |
| Mon 11:30 | PR reviewed and merged |
| Mon 12:00 | Deployed to staging → verified |
| Mon 13:00 | Deployed to production → verified |
| Mon 13:15 | Ticket closed, reporter notified |

### Duration
- **Detection → Fix:** 1h 45m
- **Fix → Production:** 1h 15m
- **Total:** 3h

### What Caught It?
- [x] User report
- [ ] Automated monitoring
- [ ] Test suite
- [ ] Code review

### Why Wasn't It Caught Earlier?
1. No unit test for fractional amounts (gap in test coverage)
2. Code review didn't flag float usage for money (missing standard)
3. No static analysis rule for float-as-money anti-pattern

### Prevention Actions
| Action | Owner | Status |
|--------|-------|--------|
| Add "no float for money" to STANDARDS.md | 📐 Sage | ⬜ |
| Add ESLint custom rule for float-money detection | 🔧 Forge | ⬜ |
| Add fractional amount tests to all payment paths | 🛡️ Vigil | ⬜ |
| Add monitoring alert for payment 500 errors | 🔧 Forge | ⬜ |
| Review all money-related code for same pattern | 🔴 Havoc | ⬜ |

### Systemic Improvements
- [ ] Add to code-review checklist: "Are monetary values stored as integers?"
- [ ] Add to code-standards: "Money MUST use integer smallest-unit (satang/cents)"
- [ ] Add to test-architect quality gate: "Payment paths require edge case coverage"
```

### Bug Pattern Library

Track recurring patterns so the team learns to spot them:

```markdown
## Known Bug Patterns

### PAT-001: Floating Point Money
**Pattern:** Using float/double for monetary calculations
**Symptom:** Rounding errors at specific amounts (0.01, 0.1+0.2)
**Fix:** Store as integer cents/satang, convert only for display
**Detection:** ESLint rule, code-review checklist item

### PAT-002: Async Race Condition
**Pattern:** Multiple async operations on shared state without locking
**Symptom:** Intermittent data corruption, duplicate operations
**Fix:** Distributed lock (Redis), optimistic concurrency, idempotency key
**Detection:** Stress test with concurrent requests

### PAT-003: Missing Null Check
**Pattern:** Accessing property of potentially null object
**Symptom:** TypeError: Cannot read property 'X' of null/undefined
**Fix:** Optional chaining, explicit null guards, stricter TypeScript config
**Detection:** tsconfig strict mode, ESLint no-unsafe-member-access

### PAT-004: N+1 Query
**Pattern:** Loading related data in a loop instead of batch query
**Symptom:** Page load time increases linearly with data size
**Fix:** Eager loading, JOIN query, dataloader pattern
**Detection:** DB query logging, slow query alerts
```

---

## Severity Workflows

### P0 Hotfix Flow (production down)

```
DETECT → TRIAGE (5 min) → REPRODUCE (15 min) → QUICK FIX → RETEST → DEPLOY
    │                                                            │
    └── NOTIFY stakeholders                                      └── POST-MORTEM (next day)
         assign on-call
         apply workaround if available
```

Rules:
- Maximum 2 hours from detect to production fix
- Skip full RCA — do quick RCA, full post-mortem next day
- Even hotfixes need: 1 reviewer, 1 regression test, staging verify
- Commit message: `hotfix(scope): [BUG-NNN] description`

### P1 Same-Day Fix Flow

```
REPORT → TRIAGE → REPRODUCE → ROOT CAUSE → FIX → RETEST → STAGING → DEPLOY
```

Rules:
- Full 7-stage workflow, compressed to same day
- Full RCA required before fixing
- Standard code review process
- Post-mortem for bugs that affected >10 users

### P2/P3 Sprint Fix Flow

```
REPORT → TRIAGE → ADD TO SPRINT → REPRODUCE → ROOT CAUSE → FIX → RETEST → NORMAL RELEASE
```

Rules:
- Full 7-stage workflow at normal pace
- Treated as a sprint story with acceptance criteria
- Goes through standard review and release cycle
- Post-mortem optional, add to Bug Pattern Library if systemic

---

## Bug Tracking Integration

### Bug → Sprint Tracker

When a bug is triaged, create a sprint tracker story:

```yaml
# In sprint-status.yaml
stories:
  - id: BUG-123
    title: "Fix: Payment fails for fractional amounts"
    type: bug
    severity: P1
    points: 3
    status: in_progress
    stages_completed: [report, reproduce, root_cause]
    stages_remaining: [fix, retest, verify]
    assignee: Bolt
    root_cause: "Floating point arithmetic for money"
    regression_test: "tests/payment/fractional-amounts.test.ts"
```

### Bug → Retrospective Feed

All P0/P1 bugs with post-mortems feed into sprint retrospective:

```markdown
## Sprint Retro — Bug Analysis

### Bugs This Sprint
| Bug | Severity | Time to Fix | Caught By | Category |
|-----|----------|-------------|-----------|----------|
| BUG-123 | P1 | 3h | User report | Data type |
| BUG-124 | P2 | 1h | QA testing | Logic error |
| BUG-125 | P2 | 2h | Monitoring | Race condition |

### Patterns
- 2 of 3 bugs were caught by users, not automated testing
- Action: Improve monitoring (Forge) + test coverage (Vigil)

### Prevention Actions from Post-Mortems
[Aggregate all prevention actions from individual post-mortems]
```

---

## Integration with AEGIS Personas

| Stage | Primary Persona | Supporting Persona |
|-------|----------------|-------------------|
| 1. Report & Triage | 🔧 Forge (triage) | 🧭 Navi (priority guidance) |
| 2. Reproduce | ⚡ Bolt (reproduction) | 🛡️ Vigil (write failing test) |
| 3. Root Cause | ⚡ Bolt (debug) | 🔴 Havoc (systemic analysis) |
| 4. Fix | ⚡ Bolt (implement) | 📐 Sage (spec update if needed) |
| 5. Retest | 🛡️ Vigil (regression test) | ⚡ Bolt (fix verification) |
| 6. Verify Staging | 🔧 Forge (deploy + monitor) | 🛡️ Vigil (staging test) |
| 7. Prevent | 🔴 Havoc (systemic review) | 🔧 Forge (retro + monitoring) |

### Persona Invocation

```
"Bolt, debug this error: [paste stack trace]"
→ Bolt enters debug mode: reproduce → root cause → fix → hand off to Vigil

"Vigil, retest BUG-123"
→ Vigil runs regression tests + blast radius check

"Havoc, is this bug systemic?"
→ Havoc searches for the same pattern across the codebase

"Forge, deploy the hotfix"
→ Forge handles staging verify → production deploy → monitoring
```

## Integration with Other Skills

- **From sprint-tracker**: Bug stories tracked alongside feature stories
- **From code-review**: Bugs found during review enter Stage 1 directly
- **From security-audit**: Security vulnerabilities enter as P0/P1 bugs
- **From test-architect**: Quality gates catch regression before release
- **To code-standards**: Prevention actions update the standards doc
- **To retrospective**: Bug metrics feed sprint retro analysis
- **To tech-debt-tracker**: Systemic bugs flagged as architectural debt
