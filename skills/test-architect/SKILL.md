---
name: test-architect
description: "Enterprise-grade test strategy, architecture, and automation framework. Use this skill whenever the user mentions test strategy, test architecture, test plan, testing pyramid, E2E testing, integration testing, 'how should I test this', risk-based testing, quality gates, release gates, regression strategy, test automation framework, contract testing, load testing, chaos testing, or any request involving designing a comprehensive testing approach beyond individual test cases. Also triggers on 'วางแผนเทสต์', 'กลยุทธ์การทดสอบ', 'test strategy', 'ออกแบบ test architecture'. This goes beyond code-coverage (which analyzes existing tests) — test-architect DESIGNS the testing strategy from scratch. Use for Enterprise track projects or any system where testing failures have significant business impact."
---

# Test Architect

> **"Don't test everything. Test the right things, in the right order, at the right level."**

Enterprise-grade test strategy design that goes beyond "write unit tests." This skill designs the full testing architecture: what to test, at which level, with what tools, gated by what quality criteria.

## What This Skill Does (vs code-coverage)

| Skill | Focus | When |
|-------|-------|------|
| `code-coverage` | Analyze EXISTING tests, find gaps, suggest missing tests | After code is written |
| `test-architect` | DESIGN the testing strategy, pyramid, frameworks, gates | Before or early in development |

## Test Strategy Document

### Step 1: Risk-Based Test Analysis

Not all code deserves equal testing. Prioritize by risk:

```markdown
## Risk-Based Test Matrix

| Module | Business Impact | Change Frequency | Complexity | Risk Score | Test Priority |
|--------|----------------|-----------------|------------|------------|--------------|
| auth/ | 🔴 Critical — breach | Medium | High | 9.0 | P0 — max coverage |
| payment/ | 🔴 Critical — money | Low | High | 8.5 | P0 — max coverage |
| api/users | 🟠 High — core CRUD | High | Medium | 7.0 | P1 — thorough |
| api/reports | 🟡 Medium — analytics | Low | Low | 4.0 | P2 — basic |
| ui/settings | 🟢 Low — config page | Low | Low | 2.0 | P3 — smoke only |

### Risk Score Formula
Risk = (Business Impact × 0.4) + (Change Frequency × 0.3) + (Complexity × 0.3)
Scale: 1-10 per factor
```

### Step 2: Testing Pyramid Design

Design the right ratio of test types for the project:

```markdown
## Testing Pyramid

                    ╱╲
                   ╱E2E╲          5% — Critical user journeys only
                  ╱──────╲
                 ╱Contract╲       10% — API contracts between services
                ╱──────────╲
               ╱Integration ╲    25% — DB, external APIs, message queues
              ╱──────────────╲
             ╱  Unit Tests    ╲  60% — Business logic, pure functions
            ╱──────────────────╲

### Layer Definitions

| Layer | What It Tests | Speed | Isolation | Tools |
|-------|-------------|-------|-----------|-------|
| Unit | Pure logic, transformations, validations | <10ms | Full mock | Jest / Vitest / pytest |
| Integration | DB queries, API calls, queue consumers | <2s | Partial — real DB, mocked externals | Supertest / httpx / testcontainers |
| Contract | API schema compatibility between services | <1s | Full mock | Pact / MSW / schemathesis |
| E2E | Full user journeys through real UI | <30s | None — real everything | Playwright / Cypress |
```

### Step 3: Test Framework Architecture

```markdown
## Test Architecture

### Directory Structure
```
tests/
├── unit/                    # Fast, isolated, mock everything
│   ├── services/
│   ├── utils/
│   └── validators/
├── integration/             # Real DB, mocked externals
│   ├── api/                 # HTTP endpoint tests
│   ├── db/                  # Query and migration tests
│   └── queue/               # Message consumer tests
├── contract/                # API schema compatibility
│   ├── provider/            # "I provide this API shape"
│   └── consumer/            # "I consume this API shape"
├── e2e/                     # Full browser tests
│   ├── journeys/            # Critical user paths
│   └── smoke/               # Quick health checks
├── fixtures/                # Shared test data
│   ├── factories/           # Data builders (factory pattern)
│   └── seeds/               # DB seed data
├── helpers/                 # Shared test utilities
│   ├── setup.ts             # Global test setup
│   ├── auth.ts              # Auth test helpers
│   └── db.ts                # DB test helpers
└── __mocks__/               # Manual mocks for external services
```

### Test Data Strategy
- **Factories** over fixtures — generate data with sensible defaults, override per test
- **Isolated data** — each test creates its own data, no shared state between tests
- **Realistic shape** — test data should look like production data (proper UUIDs, real-ish emails)
- **Edge case library** — maintain a collection of known tricky inputs

```typescript
// Factory pattern example
const createUser = (overrides?: Partial<User>): User => ({
  id: randomUUID(),
  email: `test-${randomUUID().slice(0, 8)}@example.com`,
  name: 'Test User',
  role: 'member',
  createdAt: new Date(),
  ...overrides,
});

// Usage in tests
const admin = createUser({ role: 'admin' });
const expired = createUser({ createdAt: subDays(new Date(), 365) });
```

### Step 4: Quality Gates

Define gates that must pass before code progresses:

```markdown
## Quality Gates

### Gate 1: Pre-commit (Developer machine)
- ✅ Unit tests pass (relevant modules only)
- ✅ Linting passes
- ✅ Type check passes
**Speed target:** < 10 seconds
**Enforced by:** pre-commit hook (Husky)

### Gate 2: PR / CI (Continuous Integration)
- ✅ All unit tests pass
- ✅ All integration tests pass
- ✅ Code coverage meets thresholds:
  - Overall: ≥ 80% lines
  - Critical modules (auth, payment): ≥ 90% branches
  - New code: ≥ 85% (diff coverage)
- ✅ No new security vulnerabilities (security-audit)
- ✅ Code review approved (Vigil)
**Speed target:** < 5 minutes
**Enforced by:** CI pipeline (GitHub Actions / Cloud Build)

### Gate 3: Staging (Pre-production)
- ✅ All contract tests pass
- ✅ E2E smoke tests pass
- ✅ Performance benchmarks within thresholds
- ✅ No critical/high dependency vulnerabilities
**Speed target:** < 15 minutes
**Enforced by:** staging deployment pipeline

### Gate 4: Release (Production)
- ✅ All Gate 1-3 passed
- ✅ E2E critical journey tests pass against staging
- ✅ Load test results within SLA
- ✅ Rollback procedure tested
- ✅ Monitoring/alerting configured for new features
**Speed target:** < 30 minutes
**Enforced by:** release pipeline + manual approval
```

### Step 5: Non-Functional Testing Strategy

```markdown
## Non-Functional Tests

### Performance Testing
| Type | What | Tool | When |
|------|------|------|------|
| Load test | Expected traffic patterns | k6 / Artillery | Pre-release |
| Stress test | 2-5x expected traffic | k6 | Monthly |
| Spike test | Sudden 10x traffic burst | k6 | Quarterly |
| Soak test | Normal traffic for 4+ hours | k6 | Pre-major-release |

### SLA Targets
| Endpoint | p50 | p95 | p99 | Max |
|----------|-----|-----|-----|-----|
| GET /api/users | 50ms | 150ms | 300ms | 1s |
| POST /api/auth/login | 100ms | 300ms | 500ms | 2s |
| POST /api/payments | 200ms | 500ms | 1s | 3s |

### Chaos Testing (Enterprise)
- **Network partition** — What happens when DB connection drops?
- **Clock skew** — Does auth break with 30-second time drift?
- **Disk full** — Graceful degradation when storage exhausted?
- **Dependency failure** — Behavior when Stripe/SMS/email down?
- **Memory pressure** — OOM behavior with proper shutdown?

### Accessibility Testing
- Automated: axe-core in E2E tests (catch 40% of issues)
- Manual: quarterly audit against WCAG 2.1 AA
- Screen reader validation for critical flows

### Security Testing
- SAST: integrated via security-audit skill
- DAST: OWASP ZAP against staging (monthly)
- Dependency scanning: npm audit / pip audit in every CI run
- Penetration test: annual external audit (Enterprise track)
```

### Step 6: Test Automation Framework

```markdown
## CI/CD Test Pipeline

```yaml
# Conceptual pipeline structure
pipeline:
  stage_1_fast:
    - lint
    - typecheck
    - unit_tests
    timeout: 3m
    
  stage_2_integration:
    needs: stage_1_fast
    - integration_tests
    - contract_tests
    - coverage_report
    - coverage_gate (fail if below threshold)
    timeout: 8m
    
  stage_3_staging:
    needs: stage_2_integration
    trigger: merge to main
    - deploy_staging
    - e2e_smoke
    - e2e_critical_journeys
    - performance_baseline
    timeout: 15m
    
  stage_4_release:
    needs: stage_3_staging
    trigger: manual approval
    - deploy_production
    - e2e_smoke_production
    - monitoring_check
    timeout: 10m
```

### Flaky Test Management
- Tag flaky tests with `@flaky` — quarantine don't delete
- Track flaky rate: > 2% flaky = stop adding E2E until fixed
- Root causes: async timing, shared state, environment deps
- Fix with: deterministic waits, test isolation, better factories

### Test Reporting
```markdown
# Test Report — Sprint 4
**Date:** 2026-03-24

## Summary
| Layer | Tests | Passed | Failed | Skipped | Duration |
|-------|-------|--------|--------|---------|----------|
| Unit | 342 | 340 | 2 | 0 | 8.2s |
| Integration | 87 | 85 | 1 | 1 | 45.3s |
| Contract | 24 | 24 | 0 | 0 | 3.1s |
| E2E | 15 | 14 | 1 | 0 | 2m 12s |
| **Total** | **468** | **463** | **4** | **1** | **3m 8s** |

## Coverage
| Module | Lines | Branches | Functions | Delta |
|--------|-------|----------|-----------|-------|
| auth/ | 94% | 88% | 96% | +2% |
| payment/ | 91% | 85% | 93% | +5% |
| api/ | 82% | 74% | 85% | +1% |
| Overall | 84% | 77% | 87% | +2% |

## Failed Tests
1. `unit/services/auth.test.ts` — Token expiry edge case (fix: PR #234)
2. `integration/api/users.test.ts` — Timeout on CI (flaky — quarantined)
3. `e2e/journeys/checkout.spec.ts` — Stripe test mode rate limited

## Quality Gate Status
- ✅ Gate 1: Pre-commit — passed
- ✅ Gate 2: CI — passed (coverage 84% > 80% threshold)
- ⚠️ Gate 3: Staging — 1 flaky E2E quarantined
- ⬜ Gate 4: Release — pending
```

## Test Architecture Patterns

### Pattern 1: Test Diamond (API-heavy systems)
```
        ╱╲
       ╱E2E╲         5%
      ╱──────╲
     ╱Contract╲      30%  ← heavy contract layer
    ╱──────────╲
   ╱Integration ╲   40%  ← heavy integration layer
  ╱──────────────╲
 ╱  Unit Tests    ╲  25%  ← less unit, more integration
╱──────────────────╲
```
Use when: Microservices, API-first, many service boundaries

### Pattern 2: Test Trophy (Frontend-heavy)
```
     ╱╲
    ╱E2E╲           10%
   ╱──────╲
  ╱Component╲       40%  ← component tests are the focus
 ╱──────────╲
╱ Integration ╲     30%
╱──────────────╲
Unit            ╲   20%
```
Use when: React/Next.js apps, design systems, UI-intensive

### Pattern 3: Ice Cream Cone (Anti-pattern — avoid)
```
╱──────────────────╲
╲   E2E (80%)      ╱  ← slow, flaky, expensive
 ╲────────────────╱
  ╲ Integration  ╱    15%
   ╲────────────╱
    ╲  Unit    ╱      5%
     ╲────────╱
```
Common in legacy systems. Migrate toward pyramid/diamond.

## Integration with AEGIS Personas

| Persona | Test Architect Role |
|---------|-------------------|
| 📐 Sage | Defines testability requirements in specs (acceptance criteria format) |
| 🖌️ Pixel | Specifies accessibility test requirements |
| ⚡ Bolt | Implements tests alongside feature code |
| 🛡️ Vigil | Validates test quality during review, runs code-coverage |
| 🔴 Havoc | Designs chaos test scenarios and security test cases |
| 🔧 Forge | Configures CI pipeline quality gates, tracks test metrics in retro |

## vs BMAD's TEA Module

| Feature | AEGIS test-architect | BMAD TEA |
|---------|---------------------|----------|
| Workflows | Single comprehensive skill | 8 separate workflows |
| Risk-based analysis | ✅ Risk matrix with scoring formula | ✅ Risk-based planning |
| Quality gates | ✅ 4-level gate system | ✅ Release gates |
| NFR testing | ✅ Performance, chaos, accessibility, security | ✅ NFR assessment |
| Test patterns | ✅ Pyramid, Diamond, Trophy with guidance | Partial |
| Chaos testing | ✅ Built-in scenarios | ❌ Not included |
| Flaky management | ✅ Quarantine + tracking strategy | ❌ Not addressed |
| Factory pattern | ✅ Data strategy with code examples | ❌ Not addressed |
| CI/CD pipeline | ✅ Full pipeline architecture | ✅ Automation workflows |
| Integration with personas | ✅ Each persona has testing role | Standalone module |
