# Dev Team Skills — AI-Powered SDLC Toolkit

> **"Standards defined in Markdown, enforced by AI, validated autonomously."**

A complete set of 16 Claude Skills — including 8 specialized AI personas, a test architecture framework, a skill builder, and a community marketplace — that transform a solo developer or small team into a full-stack engineering organization. Built on the SDLC+AI Framework where Markdown is the Source of Truth and AI is the Engine.

**100% free and open source.** MIT License. No paywalls. No gated content.

Built on the **SDLC+AI Framework** — Spec-Driven Development methodology where **Markdown is the Source of Truth, AI is the Engine.**

---

## Skill Inventory

| # | Skill | File | Purpose | Priority |
|---|-------|------|---------|----------|
| ⭐ | `ai-personas` | `ai-personas.skill` | **7 AI personas + party mode** — team simulation layer | P0 — Core |
| 0 | `project-navigator` | `project-navigator.skill` | **Meta-orchestrator** — scans state, recommends next action | P0 — Start Here |
| 1 | `code-standards` | `code-standards.skill` | Coding standards definition & enforcement | P1 — Quality Gate |
| 2 | `code-review` | `code-review.skill` | AI-powered structured code review | P1 — Quality Gate |
| 3 | `adversarial-review` | `adversarial-review.skill` | Devil's advocate — challenges decisions & assumptions | P1 — Quality Gate |
| 4 | `security-audit` | `security-audit.skill` | OWASP Top 10 & vulnerability scanning | P2 — Security |
| 5 | `code-coverage` | `code-coverage.skill` | Test coverage analysis & test generation | P2 — Security |
| 6 | `git-workflow` | `git-workflow.skill` | Branching, commits, PRs, changelogs | P3 — DevEx |
| 7 | `api-docs` | `api-docs.skill` | OpenAPI spec & API doc generation | P3 — DevEx |
| 8 | `tech-debt-tracker` | `tech-debt-tracker.skill` | Codebase health & debt prioritization | P3 — DevEx |
| 9 | `sprint-tracker` | `sprint-tracker.skill` | Sprint planning, story management, velocity | P3 — DevEx |
| 10 | `retrospective` | `retrospective.skill` | Sprint/epic retrospective & improvements | P3 — DevEx |
| 11 | `course-correction` | `course-correction.skill` | Mid-sprint scope change management | P3 — DevEx |
| 12 | `test-architect` | `test-architect.skill` | Enterprise test strategy, pyramid, quality gates | P2 — Security |
| 13 | `aegis-builder` | `aegis-builder.skill` | Create custom skills, personas, modules | P0 — Core |
| 14 | `skill-marketplace` | `skill-marketplace.skill` | Discover, share, install community skills | P0 — Core |

---

## Architecture — SDLC+AI Loop Mapping

These skills map directly to the 4-phase SDLC+AI infinite loop:

```
                    ┌──────────────────────────────────────────┐
                    │          SDLC+AI Infinite Loop           │
                    └──────────────────────────────────────────┘

              ┌─────────────── project-navigator ──────────────┐
              │  (scans state, recommends next, guides flow)   │
              └────────────────────────────────────────────────┘
                        │          │          │          │
    ┌─────────┐      ┌─────────┐      ┌─────────┐      ┌──────────┐
    │  PLAN   │ ──── │ EXECUTE │ ──── │ VERIFY  │ ──── │ FEEDBACK │
    └─────────┘      └─────────┘      └─────────┘      └──────────┘
         │                │                │                  │
  code-standards     api-docs        code-review       tech-debt-tracker
  git-workflow                      adversarial-review
                                    security-audit
                                    code-coverage
```

### Skill Dependency & Chaining

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│   ┌── project-navigator (meta-orchestrator, always first) ──┐   │
│   │                                                          │   │
│   │   code-standards ──→ code-review ──→ adversarial-review  │   │
│   │        │                  │               │              │   │
│   │        │                  ▼               ▼              │   │
│   │        │            code-coverage    security-audit      │   │
│   │        │                  │               │              │   │
│   │        ▼                  ▼               ▼              │   │
│   │   git-workflow ←── tech-debt-tracker ←── (all findings)  │   │
│   │        │                                                 │   │
│   │        ▼                                                 │   │
│   │   api-docs                                               │   │
│   │                                                          │   │
│   └──────────────────── loops back ─────────────────────────┘   │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Recommended execution order per PR/feature cycle:**

0. `project-navigator` — Scan state, detect track, get recommendation
1. `code-standards` — Validate conventions before review
2. `code-review` — Structured multi-pass review
3. `adversarial-review` — Challenge decisions (Enterprise track, or high-stakes changes)
4. `security-audit` — Security-focused deep scan
5. `code-coverage` — Check test coverage, generate missing tests
6. `git-workflow` — Validate commit messages, generate changelog
7. `api-docs` — Update API documentation if endpoints changed
8. `tech-debt-tracker` — Update debt backlog (run weekly/sprint)
9. `project-navigator` — Re-scan → loop to next cycle

---

## AI Personas — Your Virtual Dev Team

Instead of invoking skills directly, invoke a **persona** — a specialized AI character who owns specific skills and stays in character throughout the conversation.

| Persona | Role | Owns | Phase |
|---------|------|------|-------|
| 🧭 **Navi** | Navigator / Project Guide | `project-navigator` | META |
| 📐 **Sage** | Spec Architect / Planner | `spec-kit`, `code-standards` | PLAN |
| 🖌️ **Pixel** | UX Designer | Wireframes, user flows, UX specs | PLAN |
| ⚡ **Bolt** | Developer / Builder | `autonomous-coding`, `api-docs` | EXECUTE |
| 🛡️ **Vigil** | Code Guardian / Tester | `code-review`, `code-coverage` | VERIFY |
| 🔴 **Havoc** | Red Team / Security | `adversarial-review`, `security-audit` | VERIFY |
| 🔧 **Forge** | DevOps / Maintainer | `git-workflow`, `tech-debt-tracker`, `sprint-tracker`, `retrospective`, `course-correction` | FEEDBACK |
| 🎨 **Muse** | Creative Strategist | `trend-scout`, `content-factory`, `imagegen-gemini`, `marketing-blast`, `gdrive-upload` | MARKETING |

### Invocation

```
"Sage, create a spec for user auth"       → Sage activates, uses spec-kit
"เรียก Havoc — break my architecture"       → Havoc activates, uses adversarial-review
"Switch to Bolt"                            → Bolt takes over, uses autonomous-coding
```

### Party Mode 🎉

Bring multiple personas together for collaborative discussion:

```
"Party mode: Sage, Bolt, and Havoc — discuss the auth architecture"
"ปาร์ตี้โหมด: ทุกคนมาประชุม — review launch readiness"
```

Each persona speaks in character, can agree/disagree with each other, and action items are assigned to specific personas. See the `ai-personas` skill for full details.

### Natural SDLC Flow Through Personas

```
🧭 Navi → 📐 Sage → 🖌️ Pixel → ⚡ Bolt → 🛡️ Vigil → 🔴 Havoc → 🔧 Forge → 🧭 Navi (loop)
```

---

## Installation

### Prerequisites

- Claude Desktop App or Claude.ai with Skills support enabled
- Or any Claude-compatible environment that supports `.skill` files

### Method 1: Drag & Drop (Claude Desktop / Claude.ai)

1. Download all `.skill` files from this package
2. Open Claude → Settings → Skills
3. Drag each `.skill` file into the Skills area
4. Skills activate automatically based on trigger phrases

### Method 2: Manual Install (Claude Code / Cowork / Custom Agent)

Copy skill folders into your skills directory:

```bash
# Clone or copy the skills to your skills directory
SKILLS_DIR="/path/to/your/skills/user"

# For each skill
for skill in project-navigator code-standards code-review adversarial-review code-coverage git-workflow security-audit api-docs tech-debt-tracker; do
  cp -r "$skill/" "$SKILLS_DIR/$skill/"
done
```

Verify installation:

```bash
# Each skill directory must contain SKILL.md with valid YAML frontmatter
for skill in $SKILLS_DIR/project-navigator $SKILLS_DIR/code-standards $SKILLS_DIR/code-review \
             $SKILLS_DIR/adversarial-review $SKILLS_DIR/security-audit $SKILLS_DIR/code-coverage \
             $SKILLS_DIR/git-workflow $SKILLS_DIR/api-docs \
             $SKILLS_DIR/tech-debt-tracker; do
  if [ -f "$skill/SKILL.md" ]; then
    echo "✅ $(basename $skill)"
  else
    echo "❌ $(basename $skill) — SKILL.md not found"
  fi
done
```

### Method 3: Unpack `.skill` Files Manually

`.skill` files are ZIP archives. Unpack them:

```bash
for f in *.skill; do
  name="${f%.skill}"
  mkdir -p "$SKILLS_DIR/$name"
  unzip -o "$f" -d "$SKILLS_DIR/$name/../"
done
```

---

## Skill Reference

### 0. `project-navigator` — Intelligent Project Guide ⭐

**Triggers:** what should I do next, where do I start, project status, next step, guide me, navigator, nav, ทำอะไรต่อดี, ขั้นตอนถัดไป, สถานะโปรเจค, เริ่มยังไง

**What it does:**
- Scans project directory for existing artifacts (specs, configs, tests, code)
- Classifies project state: Empty → Idea → Specced → Building → Mature → Legacy
- Detects complexity and recommends a track (Quick / Standard / Enterprise)
- Generates a prioritized "what to do next" report with specific skill recommendations
- Answers questions about the workflow, skill ordering, and process
- Tracks progress across all 9 skills with completion percentage

**Scale-adaptive tracks:**

| Track | Stories | Planning Depth | Skills Used |
|-------|---------|---------------|-------------|
| 🟢 Quick | 1–15 | Minimal — spec → build → review | 3–4 skills |
| 🟡 Standard | 10–50 | Full PLAN→VERIFY cycle | 7–8 skills |
| 🔴 Enterprise | 30+ | Full cycle + adversarial review | All 9 skills |

**Start here:** After installing skills, run `project-navigator` first. It inspects your project and tells you exactly where to begin.

**Example prompts:**
```
"What should I do next?"
"Is my project ready for production?"
"I just finished code review, what's next?"
"ทำอะไรต่อดี"
```

---

### 1. `code-standards` — Coding Standards Enforcer

**Triggers:** coding standards, linting rules, code style, naming conventions, eslint config, prettier config, ruff config, มาตรฐานโค้ด, ตั้งค่า lint

**What it does:**
- Generates a `STANDARDS.md` document defining team conventions
- Auto-generates tool configs: `.eslintrc.json`, `.prettierrc`, `ruff.toml`, `tsconfig.json`
- Validates code against standards with severity-ranked findings
- Bulk-scans entire projects and produces compliance scores

**Output:** Standards Validation Report with rule IDs, fix suggestions, and auto-fix commands

**Supported stacks:** TypeScript, Python, React, Next.js, Node.js

**Example prompts:**
```
"Set up coding standards for our TypeScript/React project"
"Validate this file against our standards"
"Generate ESLint and Prettier configs from our STANDARDS.md"
"ตั้งค่ามาตรฐานโค้ดให้โปรเจค"
```

---

### 2. `code-review` — AI-Powered Code Review

**Triggers:** code review, PR review, review this code, find bugs, check my code, รีวิวโค้ด, หาบั๊ก

**What it does:**
- 5-pass structured review: Correctness → Security → Performance → Maintainability → SDD Compliance
- Severity-ranked findings: 🔴 Critical / 🟡 Warning / 🔵 Suggestion
- Provides concrete fix examples with before/after code
- Supports single files, multiple files, git diffs, and full PRs

**Review modes:**
| Mode | Use case |
|------|----------|
| Quick Review | Single file or snippet — correctness + security only |
| Full Review | PR with multiple files — all 5 passes |
| Security-Focused | Deep OWASP analysis + dependency check |
| Spec Compliance | Validates implementation matches spec document |

**Output:** Structured review report with actionable fixes and positive observations

**Example prompts:**
```
"Review this TypeScript file for issues"
"Do a security-focused review of our auth module"
"Review this PR diff"
"เช็คโค้ดนี้ให้หน่อย"
```

---

### 3. `adversarial-review` — Devil's Advocate

**Triggers:** adversarial review, devil's advocate, challenge this, stress test, poke holes, find weaknesses, what could go wrong, red team, ท้าทายการออกแบบ, หาจุดอ่อน, เล่นเป็นฝ่ายค้าน

**What it does:**
- Inventories every significant decision in code, architecture, or specs
- Applies the BREAK framework: Better Alternative? Reversibility? Edge Cases? Assumptions? Kill Scenario?
- Challenges trade-offs: "You chose X over Y. What did you lose?"
- Audits unstated assumptions and rates their risk
- Generates stress test scenarios designed to break the system
- Produces verdicts: ✅ Supported / ⚠️ Challenged / ❓ Needs defense

**Review types:**

| Type | Input | Challenges |
|------|-------|-----------|
| Architecture adversarial | Architecture docs, ADRs | Tech choices, scalability, coupling |
| Spec adversarial | SPEC.md, PRD | Scope creep, missing requirements, feasibility |
| Code adversarial | Source code | Abstraction choices, over/under-engineering |
| Decision adversarial | Any specific decision | Trade-offs, alternatives, consequences |

**This is NOT a normal code review.** Code review finds bugs. Adversarial review challenges the fundamental decisions that created the code in the first place.

**Example prompts:**
```
"Challenge my architecture decisions"
"Play devil's advocate on this spec"
"What could go wrong with this design?"
"หาจุดอ่อนของ architecture นี้"
```

---

### 4. `security-audit` — Security Vulnerability Scanner

**Triggers:** security audit, vulnerability scan, OWASP, secrets detection, npm audit, ตรวจสอบความปลอดภัย, สแกนช่องโหว่

**What it does:**
- OWASP Top 10 2021 systematic assessment (A01–A10)
- Dependency vulnerability scanning (`npm audit`, `pip audit`)
- Secrets detection (AWS keys, JWT secrets, Firebase configs, .env files)
- Infrastructure security review (Firebase rules, GCP IAM, AWS policies)
- API security checks (auth, rate limiting, input validation)

**Output:** Security Audit Report with:
- Executive summary with overall risk level
- Severity-ranked findings with CVE references
- Prioritized remediation roadmap (immediate → sprint → next sprint)
- Effort estimates per fix

**Severity levels:**
| Level | Meaning | Action |
|-------|---------|--------|
| 🔴 Critical | Exploitable now | Fix immediately |
| 🟠 High | Likely exploitable | Fix before deploy |
| 🟡 Medium | Exploitable with effort | Fix this sprint |
| 🔵 Low | Minor risk | Backlog |

**Example prompts:**
```
"Run a security audit on this project"
"Check for hardcoded secrets in our codebase"
"Review our Firebase security rules"
"สแกนช่องโหว่โปรเจคนี้"
```

---

### 5. `code-coverage` — Test Coverage Analyzer

**Triggers:** test coverage, code coverage, run tests, coverage report, missing tests, generate tests, เช็ค coverage, เขียนเทสต์

**What it does:**
- Runs test suites and generates coverage reports (statements, branches, functions, lines)
- Identifies uncovered critical paths with risk assessment
- Auto-generates missing test case suggestions with full code examples
- Tracks coverage trends over time

**Supported frameworks:** Jest, Vitest (TypeScript/React), pytest (Python)

**Risk-based coverage targets:**
| Code Category | Target |
|--------------|--------|
| Auth / Security | 90%+ |
| Payment / Financial | 90%+ |
| Business Logic | 80%+ |
| API Controllers | 75%+ |
| UI Components | 60%+ |

**Test generation strategy:** Happy path → Input boundaries → Error paths → Concurrency → State transitions

**Example prompts:**
```
"Analyze test coverage for this project"
"What critical paths are untested?"
"Generate test cases for the auth service"
"เช็ค coverage แล้วเขียนเทสต์ที่ขาด"
```

---

### 6. `git-workflow` — Git Strategy & PR Enforcer

**Triggers:** git workflow, branching strategy, PR template, conventional commits, changelog, pre-commit hooks, จัดการ git, สร้าง PR template

**What it does:**
- Recommends and enforces branching strategy (Trunk-Based / GitHub Flow / GitFlow)
- Validates commit messages against Conventional Commits spec
- Generates PR templates with security checklists
- Auto-generates changelogs from commit history
- Sets up pre-commit hooks (Husky + lint-staged / pre-commit framework)
- Produces release checklists

**Branch naming convention:** `{type}/{ticket-id}-{short-description}`

**Commit format:** `<type>(<scope>): <description>`

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `revert`

**Example prompts:**
```
"Set up git workflow for our team"
"Generate a PR template with security checklist"
"Create a changelog from our recent commits"
"ตั้งค่า conventional commits ให้โปรเจค"
```

---

### 7. `api-docs` — API Documentation Generator

**Triggers:** API documentation, Swagger, OpenAPI, endpoint docs, API reference, สร้าง API doc, ทำ Swagger

**What it does:**
- Auto-generates OpenAPI 3.1 specs from source code (Express, Fastify, FastAPI, Flask)
- Converts Zod/Pydantic schemas to OpenAPI component definitions
- Generates Markdown API reference with request/response examples
- Creates SDK usage examples (TypeScript, Python, cURL)
- Detects documentation drift (docs vs actual implementation)
- Maintains API changelog across versions

**Drift detection categories:**
| Type | Meaning |
|------|---------|
| Missing from Docs | Endpoint exists in code, not documented |
| Docs Outdated | Field names or types changed |
| Docs-only | Documented endpoint removed from code |

**Example prompts:**
```
"Generate OpenAPI spec from our Express routes"
"Create API documentation for the user service"
"Check if our API docs are up to date"
"สร้าง Swagger doc จากโค้ด"
```

---

### 8. `tech-debt-tracker` — Technical Debt Radar

**Triggers:** tech debt, code smell, find TODOs, outdated packages, complexity analysis, refactor list, code health, หนี้เทคนิค, หา TODO

**What it does:**
- Scans for TODO/FIXME/HACK/XXX markers with git blame age tracking
- Identifies complexity hotspots (cyclomatic complexity, file length, function length)
- Checks dependency health (outdated, vulnerable, unused packages)
- Detects architectural smells (god files, circular deps, dead code, copy-paste)
- Produces a prioritized debt backlog with effort estimates
- Tracks debt score over time (trend analysis)

**Debt Score interpretation:**
| Score | Status |
|-------|--------|
| 90–100 | Excellent — minimal debt |
| 75–89 | Good — manageable |
| 60–74 | Attention needed |
| <60 | Critical — debt blocking velocity |

**Architectural smells detected:** God files, circular dependencies, deep nesting, shotgun surgery, dead code, copy-paste, mixed concerns, environment coupling

**Example prompts:**
```
"Scan this project for tech debt"
"How much technical debt do we have?"
"Find all TODO and FIXME markers"
"เช็คหนี้เทคนิคโปรเจคนี้"
```

---

## For AI Agents — Integration Guide

If you are an AI agent reading this README to understand how to use these skills, follow these instructions:

### Skill Resolution

When a user request matches a skill's trigger phrases, read the corresponding `SKILL.md` file in full before responding. The SKILL.md contains:
- YAML frontmatter with `name` and `description` (trigger matching)
- Detailed instructions, output formats, and examples

**Start with `project-navigator`** when the user begins a new project or asks "what should I do." The navigator scans the project, detects complexity, and recommends which track and skills to use. This prevents running unnecessary skills on small projects or skipping critical ones on large projects.

### Scale-Adaptive Tracks

The navigator assigns one of three tracks. Agents should respect the track assignment:

| Track | Skip These | Always Run |
|-------|-----------|------------|
| 🟢 Quick | adversarial-review, api-docs, git-workflow, tech-debt-tracker | code-review, security-audit (light) |
| 🟡 Standard | adversarial-review | All except adversarial-review |
| 🔴 Enterprise | Nothing | All 9 skills including adversarial-review |

### Multi-Skill Chaining

For comprehensive quality checks, chain skills in this order:

```
0. project-navigator →  Scan state, detect track, recommend start point
1. code-standards    →  Pre-filter style issues
2. code-review       →  Deep logic/security review (style already clean)
3. adversarial-review → Challenge architecture/design decisions (Enterprise track)
4. security-audit    →  Escalate any security concerns from review
5. code-coverage     →  Verify tests cover reviewed critical paths
6. git-workflow      →  Validate commit/PR conventions
7. api-docs          →  Update docs if API changed
8. tech-debt-tracker →  Update debt backlog with new findings
9. project-navigator →  Re-scan → recommend next cycle
```

### Output Format Rules

All skills produce Markdown reports with:
- Severity indicators: 🔴 Critical / 🟠 High / 🟡 Medium / 🔵 Low / ℹ️ Info
- Rule IDs: `[XX-NNN]` format (e.g., `[CR-001]`, `[SEC-003]`, `[TD-012]`)
- Concrete fix examples with before/after code blocks
- Effort estimates where applicable

### Context Requirements

Each skill may need:

| Skill | Required Context | Optional Context |
|-------|-----------------|------------------|
| project-navigator | Project root access | Previous navigator reports |
| code-standards | Language/framework info | Existing configs |
| code-review | Source code (files or diff) | Spec document |
| adversarial-review | Architecture doc OR spec OR code | Business context |
| security-audit | Project root access | Architecture diagram |
| code-coverage | Test framework config | Coverage targets |
| git-workflow | Git history access | Team size |
| api-docs | Route/controller files | Existing OpenAPI spec |
| tech-debt-tracker | Project root access | Previous debt reports |

---

## Supported Tech Stacks

| Stack | Skills Coverage |
|-------|----------------|
| TypeScript / Node.js | All 9 skills |
| Python | All 9 skills |
| React / Next.js | code-standards, code-review, adversarial-review, code-coverage |
| Firebase / GCP | security-audit, api-docs |
| AWS | security-audit |
| Express / Fastify / Hono | api-docs, code-review, adversarial-review |
| FastAPI / Flask | api-docs, code-review, adversarial-review |

---

## Companion Skills (Recommended)

These skills are designed to work alongside existing skills in the SDLC+AI ecosystem:

| Existing Skill | Relationship |
|---------------|-------------|
| `spec-kit` | Standards and API docs become part of project spec |
| `autonomous-coding` | Quality gate skills validate autonomous agent output |
| `openrouter-api` | Multi-model review for cross-validation |

---

## Versioning

| Version | Date | Changes |
|---------|------|---------|
| 5.0.0 | 2026-03-17 | Added test-architect, aegis-builder, skill-marketplace. Open-sourced (MIT). All BMAD gaps closed. |
| 4.0.0 | 2026-03-17 | Added Pixel (UX), sprint-tracker, retrospective, course-correction — BMAD parity achieved |
| 3.0.0 | 2026-03-17 | Added ai-personas (8 personas + party mode), full team simulation |
| 2.0.0 | 2026-03-17 | Added project-navigator, adversarial-review, scale-adaptive tracks |
| 1.0.0 | 2026-03-17 | Initial release — 7 quality gate skills |

---

## License

MIT License — see [LICENSE](LICENSE) for details.

**AEGIS** is a trademark of Aeternix (aeternix.tech).
