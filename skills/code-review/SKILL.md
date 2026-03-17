---
name: code-review
description: "AI-powered code review with structured findings, severity ranking, security flags, and SDD compliance checks. Use this skill whenever the user asks for code review, PR review, diff review, 'review this code', 'check my code', 'find bugs', 'what's wrong with this code', 'review my PR', 'look at this diff', or any request to evaluate code quality, find issues, suggest improvements, or validate implementation against specs. Also triggers on 'รีวิวโค้ด', 'เช็คโค้ด', 'หาบั๊ก'. Even if the user just pastes code and asks 'what do you think?' — trigger this skill. Works on single files, multiple files, git diffs, and full PRs."
---

# AI-Powered Code Review

Structured, severity-ranked code review that catches bugs, security issues, performance problems, and maintainability concerns before they reach production.

## Review Philosophy

> "Review the intent, not just the syntax."

A great code review answers three questions:
1. **Does it work?** — Logic correctness, edge cases, error handling
2. **Is it safe?** — Security vulnerabilities, data exposure, injection risks
3. **Will it last?** — Maintainability, readability, scalability

## Review Process

### Step 1: Understand Context

Before reviewing code, establish:
- What is this code supposed to do? (check spec if available)
- What changed? (if reviewing a diff/PR)
- What's the risk level? (auth code > UI tweaks)

Ask the user if context is unclear. Don't review in a vacuum.

### Step 2: Multi-Pass Review

Perform the review in ordered passes — each pass has a specific focus:

**Pass 1 — Correctness (Critical)**
- Logic errors, off-by-one, null/undefined handling
- Race conditions, async/await misuse
- Missing error handling, unhandled promise rejections
- Edge cases: empty arrays, null inputs, boundary values
- Type safety: any casts, type assertions, generic misuse

**Pass 2 — Security (Critical)**
- SQL/NoSQL injection vectors
- XSS: unsanitized user input in DOM/templates
- Auth/authz: missing checks, privilege escalation paths
- Secrets: hardcoded keys, tokens, connection strings
- SSRF: unvalidated URLs in server-side requests
- Data exposure: sensitive fields in logs, responses, errors

**Pass 3 — Performance (Warning)**
- N+1 queries, missing indexes, unbounded queries
- Memory leaks: event listeners not cleaned, closures holding refs
- Unnecessary re-renders (React: missing memo, unstable refs)
- Synchronous operations that should be async
- Missing pagination, unbounded list operations

**Pass 4 — Maintainability (Suggestion)**
- Code duplication (DRY violations)
- Complex conditionals that need extraction
- Poor naming that obscures intent
- Missing or misleading comments/docs
- Tight coupling between modules

**Pass 5 — SDD Compliance (if spec exists)**
- Does implementation match the spec?
- Are all spec requirements covered?
- Any undocumented behavior added?
- Test coverage for spec'd scenarios?

### Step 3: Generate Review Report

**Output format:**

```markdown
# Code Review Report
**Reviewer:** AI Code Review Skill
**Date:** [date]
**Files Reviewed:** [count]
**Risk Level:** 🔴 High | 🟡 Medium | 🟢 Low

## Summary
| Severity | Count | Auto-fixable |
|----------|-------|-------------|
| 🔴 Critical | 2 | 0 |
| 🟡 Warning  | 5 | 3 |
| 🔵 Suggestion | 8 | 4 |

## Critical Findings

### [CR-001] SQL Injection in user search
**File:** `src/services/user-service.ts:45`
**Severity:** 🔴 Critical — Security
**Code:**
```typescript
// ❌ Current
const users = await db.query(`SELECT * FROM users WHERE name = '${input}'`);

// ✅ Fix
const users = await db.query('SELECT * FROM users WHERE name = $1', [input]);
```
**Why:** Direct string interpolation in SQL queries allows attackers to execute arbitrary SQL. This is OWASP A03:2021 (Injection).

### [CR-002] Unhandled async rejection
**File:** `src/controllers/payment.ts:78`
**Severity:** 🔴 Critical — Correctness
**Code:**
```typescript
// ❌ Current
async function processPayment(data: PaymentData) {
  const result = await gateway.charge(data); // No try-catch
  return result;
}

// ✅ Fix
async function processPayment(data: PaymentData): Promise<PaymentResult> {
  try {
    const result = await gateway.charge(data);
    return { success: true, data: result };
  } catch (error) {
    logger.error('Payment processing failed', { error, data: sanitize(data) });
    throw new PaymentError('CHARGE_FAILED', error);
  }
}
```
**Why:** Payment operations without error handling can leave transactions in inconsistent states and expose sensitive data in unhandled rejection logs.

## Warnings
[... similar format with 🟡 ...]

## Suggestions
[... similar format with 🔵 ...]

## Positive Observations
- Good use of TypeScript generics in the repository pattern
- Consistent error class hierarchy
- Clean separation of concerns between controller and service layers

## Recommended Actions
1. **Immediate:** Fix CR-001 and CR-002 before merge
2. **This sprint:** Address all warnings
3. **Backlog:** Consider suggestions for next refactor cycle
```

## Review Modes

### Quick Review (Single file / snippet)
- Focus on Pass 1 (correctness) and Pass 2 (security)
- Skip maintainability deep-dive
- Output: inline comments format

### Full Review (PR / Multiple files)
- All 5 passes
- Cross-file analysis (are imports consistent? shared patterns?)
- Output: full report format

### Security-Focused Review
- Deep Pass 2 with OWASP Top 10 checklist
- Dependency analysis (`package.json` / `requirements.txt`)
- Output: security-specific report with CVE references

### Spec Compliance Review
- Requires spec document as input
- Maps each spec requirement to implementation
- Identifies gaps and undocumented behavior
- Output: compliance matrix

## Diff Review Format

When reviewing git diffs, use this format for inline comments:

```
📁 src/services/auth.ts

  L23  + const token = jwt.sign(payload, SECRET);
       │ 🟡 WARNING: Ensure SECRET is loaded from env vars, not hardcoded.
       │ Consider adding token expiration: jwt.sign(payload, SECRET, { expiresIn: '1h' })

  L45  + } catch (e) {}
       │ 🔴 CRITICAL: Empty catch block silently swallows auth errors.
       │ At minimum: logger.error('Auth failed', { error: e });

  L67  + if (user.role == 'admin')
       │ 🔵 SUGGESTION: Use strict equality (===) for type-safe comparison.
```

## Language-Specific Checks

### TypeScript
- `any` type usage (flag and suggest proper typing)
- Non-null assertions (`!`) — each one needs justification
- Enum vs union type choice
- Proper use of `unknown` vs `any` for external data

### Python
- Mutable default arguments
- Missing `__init__` type hints
- Bare `except:` clauses
- f-string vs `.format()` consistency

### React / Next.js
- useEffect dependency array completeness
- Missing cleanup in effects
- Prop drilling depth (suggest context/store at >3 levels)
- Server vs client component boundary violations (Next.js App Router)

### Firebase / GCP
- Security rules review (Firestore, Storage)
- Missing index definitions
- Unoptimized queries (composite indexes needed)

## Integration with Other Skills

- **After `code-standards`**: Standards violations pre-filtered, review focuses on logic
- **Before `code-coverage`**: Review identifies untested critical paths
- **With `security-audit`**: Deep security review escalates to full audit
- **With `spec-kit`**: Spec compliance review validates implementation

## Review Etiquette

Even though this is AI review, maintain constructive tone:
- Start with what's good (positive observations)
- Explain WHY something is a problem, not just WHAT
- Provide concrete fix examples, not just "fix this"
- Distinguish between "must fix" and "nice to have"
- Acknowledge trade-offs ("this is slower but more readable — your call")
