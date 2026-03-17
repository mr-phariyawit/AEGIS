---
name: code-coverage
description: "Test coverage analyzer that runs test suites, identifies uncovered code, generates coverage reports, and auto-suggests missing test cases. Use this skill whenever the user mentions test coverage, code coverage, 'run tests', 'coverage report', 'untested code', 'missing tests', 'generate tests', 'write tests for', 'what's not tested', Jest coverage, pytest coverage, Istanbul, nyc, 'increase coverage', or any request to analyze, improve, or report on test coverage. Also triggers on 'เช็ค coverage', 'เขียนเทสต์', 'ทดสอบโค้ด', 'สร้างเทสต์'. Works with Jest (TypeScript/React), pytest (Python), and Vitest."
---

# Test Coverage Analyzer

Analyze test coverage, identify gaps, generate coverage reports, and auto-suggest missing test cases to hit coverage targets.

## Core Philosophy

> "100% coverage is not the goal. Meaningful coverage of critical paths is."

Focus coverage on:
1. Business logic and domain rules (highest priority)
2. Error handling and edge cases
3. API endpoints and integrations
4. Security-sensitive code (auth, payments, data access)

De-prioritize:
- Simple getters/setters
- Framework boilerplate
- Type definitions
- Configuration files

## Capabilities

### 1. Run Coverage Analysis

Detect the test framework and run coverage:

```bash
# Detect framework
if [ -f "jest.config.ts" ] || [ -f "jest.config.js" ] || grep -q '"jest"' package.json 2>/dev/null; then
  echo "FRAMEWORK=jest"
  npx jest --coverage --coverageReporters=json-summary --coverageReporters=text 2>&1
elif [ -f "vitest.config.ts" ] || [ -f "vitest.config.js" ]; then
  echo "FRAMEWORK=vitest"
  npx vitest run --coverage 2>&1
elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "setup.cfg" ]; then
  echo "FRAMEWORK=pytest"
  python -m pytest --cov --cov-report=json --cov-report=term-missing 2>&1
fi
```

### 2. Generate Coverage Report

**Output format:**

```markdown
# Test Coverage Report
**Project:** [name]
**Date:** [date]
**Framework:** Jest | pytest | Vitest

## Summary
| Metric | Coverage | Target | Status |
|--------|----------|--------|--------|
| Statements | 78.4% | 80% | 🟡 Near |
| Branches   | 65.2% | 75% | 🔴 Below |
| Functions  | 82.1% | 80% | ✅ Met |
| Lines      | 79.0% | 80% | 🟡 Near |

## Coverage by Module

| Module | Stmts | Branch | Funcs | Lines | Risk |
|--------|-------|--------|-------|-------|------|
| src/services/auth.ts | 45% | 30% | 50% | 45% | 🔴 HIGH |
| src/services/payment.ts | 52% | 40% | 60% | 55% | 🔴 HIGH |
| src/controllers/user.ts | 88% | 75% | 90% | 85% | ✅ OK |
| src/lib/validators.ts | 95% | 90% | 100% | 95% | ✅ OK |
| src/hooks/useAuth.ts | 40% | 25% | 50% | 42% | 🔴 HIGH |

## Uncovered Critical Paths

### 🔴 auth.ts — Token refresh flow (Lines 45-78)
**Why critical:** Auth token refresh failures silently log users out. No tests verify refresh token expiry, invalid refresh tokens, or concurrent refresh requests.

### 🔴 payment.ts — Error recovery (Lines 102-145)
**Why critical:** Payment failure scenarios (timeout, duplicate charge, partial refund) have zero test coverage. These are the paths most likely to cause financial issues.

### 🟡 useAuth.ts — Edge cases (Lines 23-35)
**Why important:** Hook behavior when localStorage is unavailable or corrupted is untested. Affects SSR and private browsing scenarios.

## Suggested Test Cases

See "Auto-Generated Test Suggestions" section below.
```

### 3. Auto-Suggest Missing Tests

Analyze uncovered code and generate test suggestions:

```markdown
## Auto-Generated Test Suggestions

### auth.ts — Token Refresh (Priority: 🔴 Critical)

**Test 1: Successful token refresh**
```typescript
describe('refreshToken', () => {
  it('should return new access token when refresh token is valid', async () => {
    const refreshToken = createValidRefreshToken({ userId: 'user-1' });
    const result = await authService.refreshToken(refreshToken);
    
    expect(result.accessToken).toBeDefined();
    expect(result.expiresIn).toBeGreaterThan(0);
    expect(decodeToken(result.accessToken).userId).toBe('user-1');
  });
});
```

**Test 2: Expired refresh token**
```typescript
it('should throw AuthError when refresh token is expired', async () => {
  const expiredToken = createExpiredRefreshToken({ userId: 'user-1' });
  
  await expect(authService.refreshToken(expiredToken))
    .rejects.toThrow(AuthError);
  await expect(authService.refreshToken(expiredToken))
    .rejects.toMatchObject({ code: 'REFRESH_TOKEN_EXPIRED' });
});
```

**Test 3: Concurrent refresh requests**
```typescript
it('should handle concurrent refresh requests without issuing duplicate tokens', async () => {
  const refreshToken = createValidRefreshToken({ userId: 'user-1' });
  
  const [result1, result2] = await Promise.all([
    authService.refreshToken(refreshToken),
    authService.refreshToken(refreshToken),
  ]);
  
  // One should succeed, the other should fail or return same token
  expect(result1.accessToken).toBeDefined();
});
```

### payment.ts — Error Recovery (Priority: 🔴 Critical)

**Test 4: Payment timeout handling**
```typescript
describe('processPayment — error scenarios', () => {
  it('should retry once on gateway timeout then throw', async () => {
    gateway.charge.mockRejectedValueOnce(new TimeoutError())
                   .mockRejectedValueOnce(new TimeoutError());
    
    await expect(paymentService.processPayment(validPaymentData))
      .rejects.toThrow(PaymentError);
    expect(gateway.charge).toHaveBeenCalledTimes(2);
  });
});
```
```

### 4. Coverage Trend Tracking

When run repeatedly, track coverage over time:

```markdown
## Coverage Trend
| Date | Statements | Branches | Functions | Delta |
|------|-----------|----------|-----------|-------|
| Mar 10 | 72.1% | 58.3% | 75.0% | baseline |
| Mar 14 | 76.5% | 63.1% | 79.2% | +4.4% / +4.8% / +4.2% |
| Mar 17 | 78.4% | 65.2% | 82.1% | +1.9% / +2.1% / +2.9% |

**Trajectory:** On track to hit 80% statement coverage by Mar 24
```

## Risk-Based Coverage Targets

Not all code needs the same coverage level:

| Code Category | Target | Rationale |
|--------------|--------|-----------|
| Auth / Security | 90%+ | Failures = breach |
| Payment / Financial | 90%+ | Failures = money loss |
| Business Logic / Domain | 80%+ | Core value delivery |
| API Controllers | 75%+ | Integration surface |
| UI Components | 60%+ | Visual testing supplements |
| Config / Setup | 30%+ | Rarely changes |

## Test Generation Strategy

When generating test suggestions, follow this order:
1. **Happy path** — Does the basic flow work?
2. **Input boundaries** — Empty, null, max length, special characters
3. **Error paths** — Network failure, invalid data, permission denied
4. **Concurrency** — Race conditions, parallel operations
5. **State transitions** — Valid and invalid state changes

For each test, provide:
- Descriptive test name (reads like documentation)
- Arrange / Act / Assert structure
- Relevant mocks/stubs
- Why this test matters (risk justification)

## Integration with Other Skills

- **After `code-review`**: Review identifies untested critical paths → coverage skill generates tests
- **With `code-standards`**: Test file naming and structure follows standards
- **With `security-audit`**: Security-sensitive uncovered code escalated to audit
- **With `spec-kit`**: Spec requirements mapped to test coverage
