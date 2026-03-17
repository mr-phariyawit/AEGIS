---
name: adversarial-review
description: "Devil's advocate review that challenges every design decision, assumption, and trade-off in code, architecture, and specs. Use this skill whenever the user asks for 'adversarial review', 'devil's advocate', 'challenge this', 'stress test my design', 'poke holes', 'find weaknesses', 'what could go wrong', 'red team', 'critique my architecture', 'challenge my assumptions', or any request to critically examine decisions rather than validate them. Also triggers on 'ท้าทายการออกแบบ', 'หาจุดอ่อน', 'วิจารณ์', 'devil's advocate', 'เล่นเป็นฝ่ายค้าน'. This is NOT a normal code review — this skill assumes everything might be wrong and challenges the user to defend their choices. Use after code-review when extra rigor is needed, especially for Enterprise track projects."
---

# Adversarial Review — Devil's Advocate

> **"I'm not here to validate your design. I'm here to break it."**

This skill plays devil's advocate against code, architecture, specs, and design decisions. Unlike `code-review` which finds bugs and style issues, adversarial review challenges the **WHY** behind every decision and stress-tests assumptions.

## When to Use

- **Before major releases** — challenge production readiness
- **After architecture decisions** — stress-test technical choices
- **Enterprise track projects** — extra rigor for high-stakes systems
- **When you feel "too comfortable"** — comfort means blind spots

## Adversarial Mindset

### Rules of Engagement

1. **Assume nothing is correct** — every decision needs justification
2. **Challenge trade-offs** — "You chose X over Y. What did you lose?"
3. **Push on edge cases** — "What happens when this gets 100x traffic?"
4. **Question abstractions** — "Is this abstraction earning its complexity?"
5. **Attack the happy path** — "You've only tested success. What about failure?"
6. **Follow the money** — "Where does this cost you in the long run?"
7. **Be constructive** — challenge TO improve, not to tear down

### What This Is NOT

- Not nitpicking style or formatting (that's `code-standards`)
- Not finding bugs in logic (that's `code-review`)
- Not scanning for vulnerabilities (that's `security-audit`)
- This is about challenging DECISIONS, ASSUMPTIONS, and TRADE-OFFS

## Review Process

### Phase 1: Decision Inventory

Before challenging anything, list every significant decision in the artifact:

```markdown
## Decision Inventory

| # | Decision | Type | Stated Reason |
|---|----------|------|---------------|
| D1 | Use PostgreSQL over MongoDB | Tech choice | "Relational data with complex queries" |
| D2 | Monolith architecture | Architecture | "Team of 3, ship fast" |
| D3 | JWT for auth | Security | "Stateless, scalable" |
| D4 | React + Next.js | Frontend | "SSR for SEO, React ecosystem" |
| D5 | Stripe for payments | Integration | "Industry standard, good docs" |
```

### Phase 2: Challenge Matrix

For each decision, apply the challenge framework:

#### Challenge Framework (BREAK)

**B — Better Alternative?**
Is there a clearly better option they didn't consider or dismissed too quickly?

**R — Reversibility**
How hard is it to change this decision later? Irreversible decisions need more scrutiny.

**E — Edge Cases**
What happens at the extremes? 0 users? 1M users? Network partition? Disk full?

**A — Assumptions**
What unstated assumptions does this decision rely on? What if those assumptions are wrong?

**K — Kill Scenario**
What scenario would make this decision catastrophic? How likely is that scenario?

### Phase 3: Generate Challenges

For each decision, produce structured challenges:

```markdown
## Adversarial Challenges

### D1: PostgreSQL over MongoDB — ⚠️ CHALLENGED

**Challenge:** You chose PostgreSQL for "complex queries," but your PRD
shows mostly document-style data (user profiles, content blocks, settings).
Only 2 of 12 entities have relational joins. MongoDB would give you:
- Flexible schema as requirements evolve (early stage = high uncertainty)
- Native JSON without ORM translation overhead
- Better horizontal scaling for read-heavy workloads

**Assumption attacked:** "We need complex queries" — Do you? Or do you
need them because you're thinking in SQL? Map your actual query patterns
against your access patterns.

**Reversibility:** 🔴 HIGH cost to change later. DB choice is foundational.
This decision deserves more analysis.

**Kill scenario:** Schema migrations slow down iteration speed by sprint 4.
Team spends 20% of time on Prisma migrations instead of features.

**Your defense needed:** Show me 5 specific queries that REQUIRE joins
and can't be denormalized. If you can't, reconsider.

---

### D2: Monolith Architecture — ✅ SUPPORTED (with caveat)

**Challenge:** Monolith is correct for a team of 3 shipping an MVP.
I won't challenge this.

**Caveat:** BUT — your code has no module boundaries. `src/` is flat
with 47 files. When you DO need to extract a service (and you will),
you'll have spaghetti coupling.

**Recommendation:** Keep monolith, but add module boundaries NOW:
```
src/
├── modules/
│   ├── auth/       # Self-contained
│   ├── payment/    # Self-contained
│   ├── user/       # Self-contained
│   └── shared/     # Explicit shared code
```

**Your defense needed:** None — just implement the module structure.

---

### D3: JWT for Auth — ⚠️ CHALLENGED

**Challenge:** JWT is "stateless and scalable" but your app has:
- User role changes that need immediate effect (JWT = wait for expiry)
- Session revocation requirement (PDPA compliance)
- No token refresh strategy documented

**Assumption attacked:** "Stateless is better" — for what? You have
ONE server. Statelessness only matters at scale. Right now, you're paying
the complexity cost (token refresh, blacklisting, key rotation) for a
scaling benefit you don't need yet.

**Kill scenario:** User with admin JWT gets role changed to viewer.
Their cached JWT still has admin access for 15 minutes. In fintech,
that's a compliance violation.

**Your defense needed:** How do you handle immediate session revocation?
If the answer is "blacklist," you've just re-invented sessions with
extra steps.
```

### Phase 4: Assumption Audit

List every unstated assumption found during review:

```markdown
## Unstated Assumptions Detected

| # | Assumption | Risk If Wrong | Validated? |
|---|-----------|---------------|-----------|
| A1 | Users will have stable internet | Mobile users may not — offline support? | ❌ |
| A2 | Data fits in single DB instance | Growth projections suggest 50GB/year | ⬜ Not checked |
| A3 | Third-party APIs are reliable | No retry/fallback for Stripe or SMS | ❌ |
| A4 | Team stays at 3 people | Monolith will strain at 5+ devs | ⬜ |
| A5 | Thai market only (PDPA) | What if expansion to SEA? GDPR? | ⬜ |
```

### Phase 5: Stress Test Scenarios

Generate scenarios designed to break the system:

```markdown
## Stress Test Scenarios

### Scenario 1: Flash Traffic (10x normal)
**Setup:** Product gets featured on news. 10x traffic spike in 30 minutes.
**What breaks:**
- Database connection pool exhaustion (default 20 connections)
- No caching layer — every request hits DB
- No rate limiting — bots join the party
**Your move:** Add connection pooling config, Redis cache layer, rate limiter

### Scenario 2: Dependency Failure
**Setup:** Stripe API goes down for 2 hours.
**What breaks:**
- No payment queue — transactions lost
- No retry mechanism — users get raw error
- No fallback UI — blank page on payment screen
**Your move:** Add payment queue, retry with backoff, graceful degradation UI

### Scenario 3: Data Corruption
**Setup:** Bad migration deletes production user data.
**What breaks:**
- No point-in-time recovery configured
- No migration rollback tested
- Backup restore never practiced
**Your move:** Set up automated backups, test restore procedure, add migration dry-run

### Scenario 4: Key Person Risk
**Setup:** Lead developer leaves. New dev joins.
**What breaks:**
- No STANDARDS.md → inconsistent code style
- No architecture doc → unclear system design
- No onboarding guide → 3-week ramp-up
**Your move:** Document everything with spec-kit + code-standards
```

## Output Format

```markdown
# Adversarial Review Report
**Artifact:** [name]
**Date:** [date]
**Reviewer:** Devil's Advocate

## Summary
| Decisions | Challenged | Supported | Need Defense |
|-----------|-----------|-----------|-------------|
| 8 total   | 3 (38%)   | 4 (50%)  | 1 (12%)     |

## Verdicts

| # | Decision | Verdict | Risk |
|---|----------|---------|------|
| D1 | PostgreSQL | ⚠️ Challenged | Reversibility: 🔴 High |
| D2 | Monolith | ✅ Supported (with caveat) | — |
| D3 | JWT Auth | ⚠️ Challenged | Security: 🟠 Medium |
| D4 | Next.js | ✅ Supported | — |
| D5 | Stripe | ✅ Supported | — |
| D6 | No caching | ⚠️ Challenged | Performance: 🔴 High |
| D7 | Single region | ❓ Needs defense | Availability: 🟡 |
| D8 | No feature flags | ✅ Supported (for now) | — |

## Challenges (Detail)
[... detailed challenges as shown above ...]

## Unstated Assumptions
[... assumption audit table ...]

## Stress Test Scenarios
[... scenario breakdowns ...]

## Constructive Outcome

### Must Address Before Launch
1. Define payment failure handling (D3 + Scenario 2)
2. Add module boundaries to monolith (D2 caveat)
3. Document JWT revocation strategy (D3)

### Should Address This Quarter
4. Evaluate caching layer (D6)
5. Validate DB choice against actual query patterns (D1)
6. Set up automated backups (Scenario 3)

### Think About Later
7. Multi-region strategy if expanding beyond Thailand (A5)
8. Feature flags when team grows beyond 5 (D8)
```

## Review Types

### Architecture Adversarial
Challenge: tech choices, scalability, coupling, single points of failure
Input: Architecture doc, system diagrams, ADRs

### Spec Adversarial
Challenge: scope creep, missing requirements, conflicting constraints, feasibility
Input: SPEC.md, PRD.md, requirements

### Code Adversarial
Challenge: abstraction choices, design patterns used/missing, over/under-engineering
Input: Source code (not bugs — that's code-review)

### Decision Adversarial
Challenge: any specific decision or set of decisions
Input: User describes decision and context

## Scoring System

Each challenged decision gets scored on two axes:

**Impact if wrong:** How bad is it if this decision is wrong?
- 🟢 Low — Easy to fix, minor consequences
- 🟡 Medium — Moderate effort to fix, some impact
- 🟠 High — Significant rework, user impact
- 🔴 Critical — System failure, data loss, security breach

**Confidence in challenge:** How confident is the challenge?
- 💪 Strong — Clear evidence the decision is wrong
- 🤔 Moderate — Reasonable doubt, needs investigation
- 🎯 Speculative — Edge case or future concern

Only **Strong + High/Critical** challenges should block progress.

## Integration with Other Skills

- **After `code-review`**: Code review finds bugs → adversarial review challenges design decisions
- **After `spec-kit`**: Spec written → adversarial review challenges assumptions
- **With `security-audit`**: Security audit finds vulnerabilities → adversarial review challenges the security architecture
- **In `project-navigator`**: Enterprise track includes adversarial review before major milestones

## Tone

Be direct. Be uncomfortable. Be constructive.

- ✅ "This will break under 10x traffic because there's no connection pooling."
- ✅ "Why PostgreSQL? Your data model doesn't justify it. Show me the joins."
- ❌ "Perhaps you might consider evaluating alternative database options."
- ❌ "This is a good start but maybe think about..."

The user asked for a devil's advocate. Give them one. But always end with actionable recommendations, not just criticism.
