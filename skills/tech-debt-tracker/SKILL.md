---
name: tech-debt-tracker
description: "Technical debt radar — scans codebases for TODO/FIXME markers, complexity hotspots, outdated dependencies, architectural smells, and code quality degradation. Use this skill whenever the user mentions tech debt, technical debt, code smell, 'find TODOs', 'check for FIXMEs', dependency updates, outdated packages, complexity analysis, cyclomatic complexity, 'what needs refactoring', 'cleanup backlog', 'code health', 'refactor list', 'maintenance tasks', dead code detection, or any request to assess and prioritize code maintenance work. Also triggers on 'หนี้เทคนิค', 'โค้ดที่ต้องแก้', 'เช็คความสะอาดโค้ด', 'หา TODO'. Produces a prioritized debt backlog with effort estimates."
---

# Technical Debt Radar

Scan, categorize, and prioritize technical debt to keep it visible and manageable. Produces an actionable debt backlog that integrates with sprint planning.

## Philosophy

> "Tech debt is not bad code. Tech debt is the distance between what you have and what you need."

Track debt intentionally. Every team accumulates debt — the difference is whether you manage it or let it manage you.

## Debt Categories

### 1. Code Markers (TODO/FIXME/HACK)

Scan for developer-left markers:

```bash
# Comprehensive marker scan
echo "=== Code Markers Report ==="
echo ""

for marker in TODO FIXME HACK XXX WORKAROUND TEMP DEPRECATED; do
  count=$(grep -rn --include="*.ts" --include="*.tsx" --include="*.js" --include="*.py" \
    "$marker" . 2>/dev/null | grep -v node_modules | grep -v .git | grep -v dist | wc -l)
  if [ "$count" -gt 0 ]; then
    echo "--- $marker ($count occurrences) ---"
    grep -rn --include="*.ts" --include="*.tsx" --include="*.js" --include="*.py" \
      "$marker" . 2>/dev/null | grep -v node_modules | grep -v .git | grep -v dist | head -20
    echo ""
  fi
done
```

Classify markers by age (git blame) and severity:
- `FIXME` — Known bug, needs fixing (High)
- `HACK` / `WORKAROUND` — Intentional shortcut (Medium)
- `TODO` — Planned improvement (Low-Medium, depends on context)
- `XXX` — Danger area, needs attention (High)
- `DEPRECATED` — Removal candidate (Medium)
- `TEMP` — Should have been removed already (High)

### 2. Complexity Hotspots

Identify functions/files with excessive complexity:

**Metrics to check:**
- **Cyclomatic complexity**: >10 = warning, >20 = critical
- **File length**: >300 lines = warning, >500 lines = critical
- **Function length**: >50 lines = warning, >100 lines = critical
- **Parameter count**: >4 = warning, >6 = critical
- **Nesting depth**: >4 = warning, >6 = critical

```bash
# Quick complexity scan (TypeScript)
echo "=== Files over 300 lines ==="
find . -name "*.ts" -o -name "*.tsx" | grep -v node_modules | grep -v dist | while read f; do
  lines=$(wc -l < "$f")
  if [ "$lines" -gt 300 ]; then
    echo "  $f: $lines lines"
  fi
done

echo ""
echo "=== Functions over 50 lines ==="
# Detect long functions by counting lines between function signatures
grep -rn --include="*.ts" --include="*.tsx" -E "^(export )?(async )?(function |const \w+ = )" . 2>/dev/null | \
  grep -v node_modules | grep -v dist | head -30
```

### 3. Dependency Health

Check for outdated, vulnerable, or unused dependencies:

```bash
# Node.js outdated check
echo "=== Outdated Dependencies ==="
npm outdated --json 2>/dev/null | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    for name, info in data.items():
        current = info.get('current', '?')
        wanted = info.get('wanted', '?')
        latest = info.get('latest', '?')
        if current != latest:
            severity = '🔴' if current.split('.')[0] != latest.split('.')[0] else '🟡'
            print(f'{severity} {name}: {current} → {latest} (wanted: {wanted})')
except: pass
" 2>/dev/null

echo ""
echo "=== Vulnerability Check ==="
npm audit --json 2>/dev/null | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    meta = data.get('metadata', {}).get('vulnerabilities', {})
    for sev in ['critical', 'high', 'moderate', 'low']:
        count = meta.get(sev, 0)
        if count > 0:
            print(f'  {sev}: {count}')
except: pass
" 2>/dev/null
```

**Classify dependency debt:**
- 🔴 Major version behind with known CVEs
- 🟠 Major version behind, no CVEs
- 🟡 Minor versions behind
- 🔵 Patch versions behind (auto-update candidate)

### 4. Architectural Smells

Detect patterns that indicate structural problems:

| Smell | Detection | Why It Matters |
|-------|-----------|----------------|
| **God file** | File >500 lines with >10 exports | Single point of failure, merge conflicts |
| **Circular deps** | A imports B imports A | Build issues, testing difficulties |
| **Deep nesting** | Component tree >5 levels of props | Prop drilling, refactor to context/store |
| **Shotgun surgery** | 1 feature change touches >5 files | High coupling, poor cohesion |
| **Dead code** | Exported functions with 0 importers | Maintenance burden, confusion |
| **Copy-paste** | Near-identical code blocks in 2+ files | DRY violation, divergent bug fixes |
| **Mixed concerns** | Business logic in UI components | Untestable, non-reusable |
| **Env coupling** | Hardcoded URLs, feature flags inline | Deployment inflexibility |

```bash
# Detect potential circular dependencies (simplified)
echo "=== Potential Circular Dependencies ==="
grep -rn --include="*.ts" "from '\.\." . 2>/dev/null | grep -v node_modules | \
  awk -F: '{print $1}' | sort | uniq -c | sort -rn | head -10

echo ""
echo "=== Dead exports (potential) ==="
# Find exports and check if they're imported anywhere
grep -rn --include="*.ts" --include="*.tsx" "^export " . 2>/dev/null | \
  grep -v node_modules | grep -v dist | grep -v "index.ts" | head -20
```

### 5. Dead Code Detection

Find code that's no longer used:

- **Unreachable code**: after `return`, `throw`, `process.exit`
- **Unused exports**: functions/types exported but never imported
- **Unused files**: files not imported by anything
- **Unused dependencies**: packages in `package.json` never imported
- **Commented-out code**: blocks >5 lines of commented code

## Output: Tech Debt Report

```markdown
# Technical Debt Report
**Project:** [name]
**Date:** [date]
**Scanned:** [X] files | [Y] lines of code

## Debt Score: 72/100

**Interpretation:**
- 90-100: Excellent — minimal debt
- 75-89: Good — manageable debt
- 60-74: Attention needed — debt accumulating
- <60: Critical — debt blocking velocity

## Summary Dashboard

| Category | Items | Critical | Estimated Effort |
|----------|-------|----------|-----------------|
| Code Markers | 47 | 8 FIXME | 3 days |
| Complexity | 12 hotspots | 3 files | 5 days |
| Dependencies | 15 outdated | 2 with CVEs | 1 day |
| Architecture | 5 smells | 1 circular dep | 8 days |
| Dead Code | 23 items | — | 2 days |
| **Total** | **102 items** | **14 critical** | **~19 days** |

## Critical Items (Fix This Sprint)

### 🔴 [TD-001] CVE in `jsonwebtoken` v8.5.1
**Category:** Dependency
**Severity:** Critical — known exploit
**Fix:** `npm install jsonwebtoken@9.0.2`
**Effort:** 30 minutes (test auth flows after update)

### 🔴 [TD-002] FIXME: Race condition in payment queue
**File:** `src/services/payment-queue.ts:89`
**Marker:** `// FIXME: concurrent dequeue can process same item twice`
**Age:** 45 days (committed by @dev on Feb 1)
**Effort:** 4 hours (add distributed lock)

### 🔴 [TD-003] God file: `utils.ts` (847 lines, 34 exports)
**Category:** Architecture
**Impact:** 12 files import from utils — any change risks cascade failures
**Fix:** Split into domain-specific utility modules
**Effort:** 1 day

## High Priority (Fix This Month)

### 🟠 [TD-004] 8 functions exceed complexity threshold
**Files:**
- `user-service.ts:processRegistration` — CC: 24 (threshold: 10)
- `report-generator.ts:buildReport` — CC: 18
- `data-import.ts:parseCSV` — CC: 15
**Fix:** Extract conditional logic into named helper functions
**Effort:** 3 days

### 🟠 [TD-005] 15 outdated dependencies (3 major versions behind)
**Packages:** react (17→18), next (13→14), firebase-admin (11→12)
**Fix:** Incremental upgrade with test passes between each
**Effort:** 2 days

## Medium Priority (Backlog)

### 🟡 [TD-006] 23 TODO markers (oldest: 6 months)
**Breakdown:** 15 enhancements, 5 cleanups, 3 investigate
**Action:** Triage — convert to tickets or remove stale ones

### 🟡 [TD-007] 450 lines of commented-out code
**Files:** Spread across 12 files
**Action:** Remove — git history preserves everything

## Debt Trend

| Month | Score | Items | Critical | New | Resolved |
|-------|-------|-------|----------|-----|----------|
| Jan   | 68    | 95    | 18       | —   | —        |
| Feb   | 70    | 89    | 15       | 12  | 18       |
| Mar   | 72    | 102   | 14       | 22  | 9        |

**⚠️ Trend Warning:** New debt (22) outpacing resolution (9) this month.
**Recommendation:** Allocate 20% of sprint capacity to debt reduction.

## Prioritized Action Plan

### Week 1: Critical fixes
1. Update `jsonwebtoken` (30 min)
2. Fix payment queue race condition (4 hours)
3. Run `npm audit fix` (30 min)

### Week 2: Architecture
4. Split `utils.ts` into domain modules (1 day)
5. Resolve circular dependency in services/ (4 hours)

### Week 3: Complexity reduction
6. Refactor top 3 complex functions (2 days)
7. Triage and clean TODO markers (2 hours)

### Week 4: Housekeeping
8. Remove commented-out code (1 hour)
9. Update major dependencies (2 days)
10. Remove dead exports (2 hours)
```

## Effort Estimation Guidelines

| Task Type | Small | Medium | Large |
|-----------|-------|--------|-------|
| Dependency update (patch) | 15 min | — | — |
| Dependency update (major) | — | 2 hours | 1 day |
| Extract function | 30 min | 1 hour | — |
| Split god file | — | 4 hours | 2 days |
| Fix race condition | — | 4 hours | 2 days |
| Remove dead code | 15 min | 1 hour | — |
| Resolve circular dep | — | 2 hours | 1 day |

## Integration with Other Skills

- **With `code-standards`**: Standards violations classified as debt if not auto-fixable
- **With `code-review`**: New debt flagged during review with TD ticket suggestion
- **With `security-audit`**: Security debt gets highest priority classification
- **With `code-coverage`**: Low-coverage critical code flagged as testing debt
- **With `git-workflow`**: Debt items become tickets with conventional commit tracking
