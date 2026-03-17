---
name: project-navigator
description: "Intelligent project guide that scans your project state, detects complexity, recommends the next action, and chains skills together. Use this skill whenever the user says 'what should I do next', 'where do I start', 'project status', 'what's missing', 'next step', 'guide me', 'help me plan', 'navigator', 'nav', or asks any question about which skill to run, what order to follow, or what artifacts are missing. Also triggers on 'ทำอะไรต่อดี', 'ขั้นตอนถัดไป', 'สถานะโปรเจค', 'เริ่มยังไง', 'ช่วยนำทาง'. This is the META skill — it knows about ALL other skills and orchestrates the full SDLC+AI workflow. If the user seems lost, confused about the process, or asks a general question about the development workflow, trigger this skill. Always trigger this skill at the START of a new project."
---

# Project Navigator

> **"You don't need to memorize the workflow. Just ask."**

The meta-orchestrator skill that knows your entire SDLC+AI ecosystem. It scans project state, detects complexity, recommends the next skill to run, and guides you through the full development lifecycle.

## How It Works

1. **Scan** — Inspect the project directory for existing artifacts
2. **Detect** — Determine project complexity and recommend a track
3. **Recommend** — Tell the user exactly what to do next
4. **Guide** — Answer questions about the workflow, skills, and process

## Step 1: Scan Project State

When triggered, immediately scan the project directory structure to build a state map.

### Artifact Detection

Scan for these artifacts and classify their status:

```bash
echo "=== Project Navigator — Scanning ==="
echo ""

# Core project files
for f in package.json pyproject.toml requirements.txt tsconfig.json Dockerfile docker-compose.yml; do
  [ -f "$f" ] && echo "✅ $f" || echo "⬜ $f"
done

echo ""
echo "--- Planning Artifacts ---"

# Spec-driven artifacts (from spec-kit)
for f in SPEC.md PRD.md REQUIREMENTS.md ARCHITECTURE.md IMPLEMENTATION_PLAN.md TASK_BREAKDOWN.md; do
  found=$(find . -maxdepth 3 -name "$f" -not -path "*/node_modules/*" 2>/dev/null | head -1)
  [ -n "$found" ] && echo "✅ $f → $found" || echo "⬜ $f"
done

echo ""
echo "--- Quality Artifacts ---"

# Standards and configs
for f in STANDARDS.md .eslintrc.json .prettierrc ruff.toml .pre-commit-config.yaml; do
  found=$(find . -maxdepth 3 -name "$f" -not -path "*/node_modules/*" 2>/dev/null | head -1)
  [ -n "$found" ] && echo "✅ $f → $found" || echo "⬜ $f"
done

echo ""
echo "--- Git & CI ---"
[ -d ".git" ] && echo "✅ Git initialized" || echo "⬜ Git not initialized"
[ -f ".github/pull_request_template.md" ] && echo "✅ PR template" || echo "⬜ PR template"
[ -f ".github/workflows/ci.yml" ] || [ -f ".github/workflows/ci.yaml" ] && echo "✅ CI pipeline" || echo "⬜ CI pipeline"

echo ""
echo "--- Test Coverage ---"
for d in tests test __tests__ spec; do
  [ -d "$d" ] && echo "✅ Test directory: $d/" && break
done
[ -f "jest.config.ts" ] || [ -f "jest.config.js" ] || [ -f "vitest.config.ts" ] || [ -f "pytest.ini" ] && echo "✅ Test framework configured"

echo ""
echo "--- Source Code ---"
src_files=$(find . -maxdepth 4 \( -name "*.ts" -o -name "*.tsx" -o -name "*.py" -o -name "*.js" -o -name "*.jsx" \) -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/dist/*" 2>/dev/null | wc -l)
echo "Source files: $src_files"

echo ""
echo "--- API Documentation ---"
for f in openapi.yaml openapi.json swagger.yaml swagger.json API.md; do
  found=$(find . -maxdepth 3 -name "$f" -not -path "*/node_modules/*" 2>/dev/null | head -1)
  [ -n "$found" ] && echo "✅ $f → $found"
done
```

### State Classification

Based on scan results, classify the project into one of these states:

| State | Indicators | What It Means |
|-------|-----------|---------------|
| **Empty** | No source files, no specs | Brand new project — start from scratch |
| **Idea** | Has README or brief, no specs | Concept exists, needs specification |
| **Specced** | Has SPEC.md or PRD.md, no/little code | Planning done, ready to build |
| **Building** | Has specs AND source code | Implementation in progress |
| **Mature** | Has specs, code, tests, CI | Established project — maintenance mode |
| **Legacy** | Has code but no specs, no tests | Existing codebase needing modernization |

## Step 2: Detect Complexity & Recommend Track

### Scale-Adaptive Tracks

Based on the project scan, recommend one of three tracks:

#### 🟢 Quick Track (1–15 stories)
**Best for:** Bug fixes, small features, clear scope, solo developer

**Workflow:**
```
spec-kit (quick spec) → autonomous-coding → code-review → done
```

**Indicators:**
- Single module/service
- < 20 source files
- No multi-team coordination needed
- Clear, bounded requirements

**Skip:** Full PRD, architecture doc, sprint planning, api-docs

#### 🟡 Standard Track (10–50 stories)
**Best for:** Products, platforms, APIs, team of 2-5

**Workflow:**
```
PLAN:     spec-kit (full spec) → code-standards
EXECUTE:  autonomous-coding → api-docs
VERIFY:   code-review → security-audit → code-coverage
FEEDBACK: tech-debt-tracker → git-workflow
```

**Indicators:**
- Multiple modules/services
- 20–200 source files
- Has API endpoints
- Needs documentation for other developers

#### 🔴 Enterprise Track (30+ stories)
**Best for:** Multi-team systems, compliance requirements, high-stakes

**Workflow:**
```
PLAN:     spec-kit (full SDD) → code-standards → git-workflow (strategy)
EXECUTE:  autonomous-coding → api-docs
VERIFY:   code-review → adversarial-review → security-audit → code-coverage
FEEDBACK: tech-debt-tracker → retrospective
REPEAT:   Navigator re-scan → next cycle
```

**Indicators:**
- Multiple services/microservices
- 200+ source files
- Has auth/payments/PII
- Multiple teams or external integrations
- Compliance requirements (PDPA, SOC2, etc.)

### Track Selection Logic

```
IF source_files == 0 AND no specs:
  → "You're starting fresh. What's your project idea?"
  → Recommend Quick or Standard based on description

IF source_files > 0 AND no specs:
  → "Legacy project detected. Want to spec what exists or start improving?"
  → Offer: spec-kit (document existing) OR code-standards (start enforcing)

IF has_spec AND source_files < 20:
  → Quick Track

IF has_spec AND source_files 20-200:
  → Standard Track

IF source_files > 200 OR has_auth_code OR has_payment_code:
  → Enterprise Track
```

## Step 3: Recommend Next Action

Based on state + track, generate a clear recommendation:

### Output Format — Navigator Report

```markdown
# 🧭 Project Navigator

## Project State
**Status:** [Building] | **Track:** [Standard] | **Health:** [72/100]

## What You Have
✅ SPEC.md — last updated 3 days ago
✅ package.json — TypeScript/React project
✅ 47 source files
✅ .eslintrc.json — linting configured
⬜ No test coverage data
⬜ No API documentation
⬜ No PR template
⬜ No security audit done

## What To Do Next

### 1. 🔴 Now: Run `code-coverage`
Your project has 47 source files but no test directory. Critical paths
in `src/services/auth.ts` and `src/services/payment.ts` are untested.

**Run:** "Analyze test coverage and generate missing tests for auth and payment services"

### 2. 🟡 This Sprint: Run `security-audit`
You have auth code (`src/services/auth.ts`) and payment code
(`src/services/payment.ts`) but no security audit has been done.

**Run:** "Run security audit on this project"

### 3. 🔵 Backlog: Set up `git-workflow`
No PR template or commit hooks. Set up before team grows.

**Run:** "Set up git workflow with PR template and conventional commits"

## Full Roadmap

| Phase | Skill | Status | Priority |
|-------|-------|--------|----------|
| PLAN | spec-kit | ✅ Done | — |
| PLAN | code-standards | ✅ Done | — |
| EXECUTE | autonomous-coding | 🔄 In progress | — |
| EXECUTE | api-docs | ⬜ Not started | Medium |
| VERIFY | code-review | ⬜ Not started | High |
| VERIFY | security-audit | ⬜ Not started | High |
| VERIFY | code-coverage | ⬜ Not started | 🔴 Critical |
| FEEDBACK | tech-debt-tracker | ⬜ Not started | Medium |
| FEEDBACK | git-workflow | ⬜ Not started | Medium |
```

## Step 4: Answer Questions

When the user asks questions, respond with contextual awareness:

### Common Questions & Responses

**"Where do I start?"**
→ Scan project → Recommend first skill based on state

**"What skills do I have?"**
→ List all installed skills with one-line descriptions + their trigger phrases

**"I just finished [X], what's next?"**
→ Map to SDLC+AI loop position → Recommend next skill in sequence

**"Is my project ready for production?"**
→ Run a readiness checklist:
  - [ ] Specs documented (spec-kit)
  - [ ] Standards enforced (code-standards)
  - [ ] Code reviewed (code-review)
  - [ ] Security audited (security-audit)
  - [ ] Tests covering critical paths (code-coverage)
  - [ ] API documented (api-docs)
  - [ ] Tech debt manageable (tech-debt-tracker)
  - [ ] Git workflow set up (git-workflow)

**"What's the difference between Quick and Standard track?"**
→ Explain tracks with the table above + recommend based on their project

**"How do I onboard a new team member?"**
→ Point to: STANDARDS.md → git-workflow PR template → code-review process

## Skill Ecosystem Map

The navigator knows about ALL skills and their relationships:

### Development Skills (SDLC)
```
spec-kit              → PLAN phase entry point
autonomous-coding     → EXECUTE phase implementation
code-standards        → PLAN/VERIFY — define + enforce conventions
code-review           → VERIFY — structured multi-pass review
adversarial-review    → VERIFY — devil's advocate challenge
security-audit        → VERIFY — OWASP + dependency + infra audit
code-coverage         → VERIFY — test analysis + generation
api-docs              → EXECUTE — documentation generation
git-workflow          → PLAN/FEEDBACK — git strategy + PR process
tech-debt-tracker     → FEEDBACK — debt radar + backlog
openrouter-api        → UTILITY — multi-model LLM access
```

### Marketing Skills (Content Pipeline)
```
trend-scout           → Research trends
content-factory       → Create content calendar + copy
imagegen-gemini       → Generate visual assets
marketing-blast       → Orchestrate full pipeline
gdrive-upload         → Deliver outputs to Google Drive
```

### Skill Chaining Rules

**SDLC Chain (per feature/sprint):**
```
spec-kit → code-standards → autonomous-coding → code-review
  → security-audit → code-coverage → api-docs → tech-debt-tracker
  → git-workflow → [loop back to spec-kit for next feature]
```

**Marketing Chain (per campaign):**
```
trend-scout → content-factory → imagegen-gemini → gdrive-upload
```

**Full Pipeline (orchestrated):**
```
marketing-blast (calls trend-scout + content-factory + imagegen + gdrive-upload)
```

## Re-scan Trigger

After any skill completes, suggest running navigator again:

> "✅ [skill-name] complete. Run `navigator` to see what's next, or continue to [suggested-next-skill]."

This creates the infinite loop: every skill completion feeds back into the navigator, which recommends the next action.

## Established Project Mode

When navigating a legacy/mature project without specs:

1. **Don't force spec-first.** Instead, recommend:
   - `code-standards` — establish conventions first
   - `tech-debt-tracker` — understand current state
   - `code-coverage` — identify risk areas
   - THEN `spec-kit` — document what exists

2. **Generate a project-context.md** — scan the codebase to auto-generate:
   - Tech stack detected
   - Directory structure conventions
   - Naming patterns observed
   - Dependencies and their versions
   - Entry points and main modules

This mirrors BMAD's `bmad-generate-project-context` but is integrated into the navigator flow.

## Tone & Communication

- Be direct: "Do X" not "You might want to consider X"
- Be specific: "Run security-audit on src/services/auth.ts" not "Consider running security"
- Be honest: "Your auth code has zero test coverage — this is a risk" not "Coverage could be improved"
- Celebrate progress: "✅ 6/9 skills complete — you're 67% through the quality gate"
- Use Thai naturally when the user communicates in Thai
