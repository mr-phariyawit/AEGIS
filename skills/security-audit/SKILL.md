---
name: security-audit
description: "Security vulnerability scanner and audit tool for web applications, APIs, and cloud infrastructure. Use this skill whenever the user mentions security audit, vulnerability scan, OWASP, penetration testing review, dependency audit, secrets detection, security review, 'check for vulnerabilities', 'is this secure', 'security scan', 'npm audit', 'pip audit', Firebase security rules, GCP IAM review, AWS security, or any request involving security assessment of code, infrastructure, or dependencies. Also triggers on 'ตรวจสอบความปลอดภัย', 'สแกนช่องโหว่', 'security เช็ค'. Produces prioritized remediation reports with severity scores and fix guidance."
---

# Security Vulnerability Scanner & Audit

Comprehensive security assessment for applications, APIs, dependencies, and cloud infrastructure. Produces actionable remediation reports prioritized by risk.

## Audit Scope

### What This Skill Covers

1. **Application Security** — OWASP Top 10 2021 assessment
2. **Dependency Vulnerabilities** — Known CVEs in npm/pip packages
3. **Secrets Detection** — Hardcoded credentials, API keys, tokens
4. **Infrastructure Security** — Firebase rules, GCP IAM, AWS policies
5. **API Security** — Auth flows, rate limiting, data exposure
6. **Configuration Security** — Headers, CORS, CSP, cookie settings

### What This Skill Does NOT Cover
- Active penetration testing (this is static/config analysis only)
- Network-level scanning (ports, protocols)
- Physical security
- Social engineering assessment

## Audit Process

### Phase 1: Reconnaissance

Gather project context:
- Tech stack (read `package.json`, `requirements.txt`, `docker-compose.yml`)
- Architecture (monolith, microservices, serverless)
- Auth mechanism (JWT, session, OAuth, Firebase Auth)
- Data sensitivity level (PII, financial, healthcare)
- Deployment target (GCP, AWS, Firebase, Vercel)

### Phase 2: OWASP Top 10 2021 Assessment

Systematically check each category:

| ID | Category | Check |
|----|----------|-------|
| A01 | Broken Access Control | Missing auth middleware, IDOR, path traversal, CORS misconfiguration |
| A02 | Cryptographic Failures | Weak hashing, plaintext storage, missing TLS, weak JWT secrets |
| A03 | Injection | SQL/NoSQL injection, command injection, LDAP, XPath, template injection |
| A04 | Insecure Design | Missing rate limits, no account lockout, predictable resource IDs |
| A05 | Security Misconfiguration | Default creds, unnecessary features enabled, verbose errors in prod |
| A06 | Vulnerable Components | Known CVEs in dependencies, outdated packages |
| A07 | Auth Failures | Weak passwords allowed, missing MFA, session fixation |
| A08 | Data Integrity Failures | Missing integrity checks, insecure deserialization, unsigned updates |
| A09 | Logging Failures | Missing audit logs, sensitive data in logs, no alerting |
| A10 | SSRF | Unvalidated URLs in server requests, cloud metadata access |

### Phase 3: Dependency Audit

Run and analyze:

```bash
# Node.js
npm audit --json 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'vulnerabilities' in data:
    for name, info in data['vulnerabilities'].items():
        print(f'{info.get(\"severity\",\"unknown\").upper()}: {name} - {info.get(\"title\",\"N/A\")}')
"

# Python
pip audit --format=json 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
for vuln in data.get('vulnerabilities', []):
    print(f'{vuln[\"id\"]}: {vuln[\"name\"]} {vuln[\"installed_version\"]} -> {vuln.get(\"fix_versions\",\"N/A\")}')
"
```

### Phase 4: Secrets Detection

Scan for patterns that indicate exposed secrets:

**High-confidence patterns:**
- AWS keys: `AKIA[0-9A-Z]{16}`
- Firebase config with `apiKey` in committed code
- JWT secrets in source: `jwt.sign(*, 'hardcoded')`
- Database connection strings with credentials
- `.env` files committed to git
- Private keys (RSA, SSH) in repo

**Check locations:**
- Source code files
- Configuration files
- Docker files and compose configs
- CI/CD pipeline configs
- Test files (often contain real tokens by mistake)

```bash
# Quick secret scan
grep -rn --include="*.ts" --include="*.js" --include="*.py" --include="*.env*" --include="*.yml" --include="*.yaml" \
  -E "(AKIA[0-9A-Z]{16}|password\s*=\s*['\"][^'\"]+['\"]|apiKey['\"]?\s*[:=]\s*['\"][^'\"]{20,})" \
  . 2>/dev/null | grep -v node_modules | grep -v .git
```

### Phase 5: Infrastructure Security

#### Firebase
```
# Check Firestore rules
- Are rules restrictive by default? (deny all, allow specific)
- Do reads/writes require authentication?
- Are there wildcard allows on sensitive collections?
- Is data validation enforced in rules?
- Are admin operations properly restricted?

# Check Storage rules
- Are uploads restricted by type and size?
- Is public read actually needed?
- Are deletion rules properly scoped?
```

#### GCP
```
# IAM review
- Are service accounts using least privilege?
- Any allUsers or allAuthenticatedUsers grants?
- Are there overly permissive roles (Editor, Owner) on service accounts?
- Is Cloud Audit Logging enabled?
- Are API keys restricted by IP/referrer?
```

#### AWS
```
# Security checks
- S3 buckets: public access blocked?
- IAM: no wildcard (*) actions on sensitive resources?
- Security groups: no 0.0.0.0/0 inbound on sensitive ports?
- CloudTrail enabled?
- RDS: encryption at rest enabled?
```

### Phase 6: API Security

Check API endpoints for:
- **Authentication**: Every endpoint that should require auth actually does
- **Authorization**: Role-based access properly enforced
- **Input validation**: Request bodies validated with schemas (Zod, Joi, Pydantic)
- **Rate limiting**: Applied to auth endpoints and expensive operations
- **Data exposure**: Responses don't leak internal IDs, timestamps, or user data
- **Error handling**: Errors don't expose stack traces or internal paths in production

## Output: Security Audit Report

```markdown
# Security Audit Report
**Project:** [name]
**Date:** [date]
**Auditor:** AI Security Audit Skill
**Scope:** Application + Dependencies + Infrastructure

## Executive Summary

**Overall Risk Level:** 🔴 HIGH / 🟡 MEDIUM / 🟢 LOW

| Severity | Count | Must Fix Before Deploy |
|----------|-------|----------------------|
| 🔴 Critical | X | Yes |
| 🟠 High     | X | Yes |
| 🟡 Medium   | X | Recommended |
| 🔵 Low      | X | Backlog |
| ℹ️ Info      | X | Awareness |

## Critical & High Findings

### [SEC-001] Hardcoded JWT Secret
**Severity:** 🔴 Critical | **OWASP:** A02 Cryptographic Failures
**Location:** `src/auth/jwt.ts:12`
**Description:** JWT signing secret is hardcoded in source code. Anyone with repo access can forge tokens.
**Evidence:**
```typescript
const SECRET = 'my-super-secret-key-12345'; // ❌
```
**Remediation:**
```typescript
const SECRET = process.env.JWT_SECRET; // ✅
if (!SECRET) throw new Error('JWT_SECRET not configured');
```
**Effort:** 15 minutes | **Priority:** Immediate

### [SEC-002] Missing Rate Limiting on Login
**Severity:** 🟠 High | **OWASP:** A04 Insecure Design
**Location:** `src/routes/auth.ts:34`
**Description:** Login endpoint has no rate limiting, enabling brute force attacks.
**Remediation:** Add rate limiter middleware (e.g., `express-rate-limit`):
```typescript
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts per window
  message: 'Too many login attempts, please try again later'
});
app.post('/auth/login', loginLimiter, loginHandler);
```
**Effort:** 30 minutes | **Priority:** Before launch

## Dependency Vulnerabilities

| Package | Installed | Severity | CVE | Fix Version |
|---------|-----------|----------|-----|-------------|
| lodash  | 4.17.19   | 🔴 Critical | CVE-2021-23337 | 4.17.21 |
| axios   | 0.21.0    | 🟡 Medium | CVE-2021-3749 | 0.21.2 |

**Quick fix:** `npm audit fix` resolves 3 of 5 vulnerabilities.

## Secrets Detected

| Type | File | Line | Status |
|------|------|------|--------|
| AWS Key | .env.example | 5 | ⚠️ Example file but real format |
| Firebase apiKey | src/config/firebase.ts | 8 | ℹ️ Client-side key (expected) |

## Infrastructure Findings
[... Firebase/GCP/AWS findings ...]

## Remediation Roadmap

### Immediate (before deploy)
1. Fix SEC-001: Move secrets to environment variables
2. Fix SEC-002: Add rate limiting to auth endpoints
3. Run `npm audit fix`

### This Sprint
4. Review and tighten Firebase security rules
5. Add input validation schemas to all API endpoints
6. Enable Cloud Audit Logging

### Next Sprint
7. Implement CSP headers
8. Add security response headers (HSTS, X-Frame-Options)
9. Set up dependency auto-update (Dependabot/Renovate)

## Compliance Notes
- PDPA (Thailand): Ensure PII handling meets requirements
- SOC 2: Logging and access control gaps identified
```

## Severity Definitions

| Level | Meaning | Action |
|-------|---------|--------|
| 🔴 Critical | Exploitable now, data at risk | Fix immediately, consider hotfix |
| 🟠 High | Likely exploitable, significant impact | Fix before deploy |
| 🟡 Medium | Exploitable with effort, limited impact | Fix this sprint |
| 🔵 Low | Minor risk, defense-in-depth | Add to backlog |
| ℹ️ Info | Best practice suggestion | Awareness only |

## Integration with Other Skills

- **After `code-review`**: Escalate security findings from review to full audit
- **With `code-standards`**: Security standards become part of the standards doc
- **With `tech-debt-tracker`**: Security debt tracked as highest-priority debt
- **With `git-workflow`**: Security checks in pre-merge hooks
