# 🛡️ AEGIS v6.0 — Specification Document

> **Codename: "Context is King"**
>
> *Upgrade from subagent-only architecture to hybrid Agent Teams + Context Management*

**Written by:** AEGIS Team (Party Mode)

| Persona | Contribution |
|---------|-------------|
| 🧭 Navi | Project vision, scope, priority ranking |
| 📐 Sage | Requirements, architecture, acceptance criteria |
| ⚡ Bolt | Implementation plan, technical feasibility |
| 🛡️ Vigil | Quality gates, test strategy, regression risks |
| 🔴 Havoc | Risk assessment, adversarial review, kill scenarios |
| 🔧 Forge | Deployment, upgrade path, backward compatibility |
| 🖌️ Pixel | Developer UX, onboarding experience |
| 🎨 Muse | Documentation, marketing, community |

**Version:** 1.0
**Date:** 2026-03-20
**Status:** DRAFT — Ready for review

---

## 1. Context & Problem Statement

### 1.1 What We Learned (Dogfood + Community)

AEGIS v5.4 has been validated on a real Claude Code project. Additionally, a transcript from **Claude Thailand Community** (3 production speakers) revealed 7 critical patterns that AEGIS does not yet address.

#### From our own dogfood:
- ✅ All 19 skills trigger correctly on Claude Code
- ✅ Subagent dispatch works — agents produce reports
- ✅ Heartbeat monitoring works — user sees progress
- ⚠️ False-ready signal — Enter button enables prematurely (fixed in v5.4.1)
- ⚠️ Agents cannot communicate with each other (subagent limitation)

#### From community transcript (3 speakers):

| # | Pattern | Speaker | AEGIS Gap |
|---|---------|---------|-----------|
| 1 | Progressive disclosure — load context lazily | Mickey (AX Digital) | Skills load entire SKILL.md always |
| 2 | Shared reference files (DRY principle) | Mickey | Rules duplicated across 8 agent files |
| 3 | Layered orchestration with review gates | Mickey | No review gates between pipeline phases |
| 4 | Model routing per agent (Opus/Sonnet/Haiku) | Mickey | No `model:` field in agents |
| 5 | Agent Teams — mesh communication between agents | Mickey + Joon | Subagent-only (hub-and-spoke) |
| 6 | Extract learning / Metal Skills | Mickey | No knowledge extraction mechanism |
| 7 | Context budget awareness (20% rule) | New (Debox) | No context monitoring |

### 1.2 Core Thesis

**"Good engineer = good at managing AI agents = good at managing context"** — Mickey (AX Digital)

**"Treat context like system design — clear boundaries, single responsibility, progressive disclosure"** — Mickey

**"Context is King — เริ่ม session ไม่เกิน 20%"** — New (Debox)

These insights reshape AEGIS from a "skill collection" into a **context-aware, self-managing agent framework**.

---

## 2. Goals & Non-Goals

### 2.1 Goals

| ID | Goal | KPI | Owner |
|----|------|-----|-------|
| G-01 | Reduce context footprint per skill by 80% | Avg skill load: <50 tokens (from ~500) | 📐 Sage |
| G-02 | Enable mesh agent communication | Agents can message each other directly | ⚡ Bolt |
| G-03 | Route models per agent automatically | Cost reduction 40-60% on pipeline runs | 🔧 Forge |
| G-04 | Add review gates between pipeline phases | Zero broken output passed to next phase | 🛡️ Vigil |
| G-05 | Extract and persist learning across sessions | Knowledge files grow per project | 🧭 Navi |
| G-06 | Monitor context budget in real-time | Warning before exceeding 60% context | 🔧 Forge |
| G-07 | Maintain backward compatibility with v5.x | install.sh --upgrade works seamlessly | 🔧 Forge |

### 2.2 Non-Goals (v6.0)

- GUI / web dashboard for AEGIS (future v7)
- Custom model provider support (OpenRouter, etc.) — use existing openrouter-api skill
- Automated CI/CD integration (use existing GitHub Action patterns)
- Mobile app for AEGIS management

---

## 3. Architecture — 📐 Sage

### 3.1 Current vs Target Architecture

```
v5.4 (Current):                          v6.0 (Target):
┌──────────────┐                         ┌──────────────────┐
│ Main Agent   │                         │ AEGIS Director   │
│ (orchestrate)│                         │ (smart routing)  │
└──────┬───────┘                         └──────┬───────────┘
       │ hub-and-spoke                          │ auto-select
  ┌────┼────┐                              ┌────┼────┐
  ▼    ▼    ▼                              ▼    ▼    ▼
┌───┐┌───┐┌───┐                         Subagent │ Agent Team
│ A ││ B ││ C │ (can't talk)            (simple)  │ (complex)
└───┘└───┘└───┘                                   │
  │    │    │                              ┌──────┼──────┐
  ▼    ▼    ▼                              ▼      ▼      ▼
 Navi synthesizes                        A ←→ B ←→ C (mesh)
                                                │
                                          Shared task list
```

### 3.2 New Components

#### 3.2.1 Shared References (`references/`)

```
.claude/
├── references/                    ← NEW
│   ├── progress-protocol.md       # Heartbeat rules (shared by all agents)
│   ├── output-format.md           # Report format standards
│   ├── review-checklist.md        # Common review criteria
│   └── context-rules.md           # Context budget rules
├── agents/
│   ├── sage.md                    # Points to references/ instead of duplicating
│   └── ...
└── commands/
```

**Requirement FR-REF-01:** Every agent definition MUST reference shared files instead of duplicating rules.

**Requirement FR-REF-02:** Reference files MUST be loaded only when the agent needs them (progressive disclosure).

#### 3.2.2 Model Routing

```yaml
# In each agent .md frontmatter:
---
name: sage
model: opus          # Complex reasoning tasks
description: "..."
---

# Routing table:
# opus:   navi (synthesis), sage (spec), havoc (adversarial)
# sonnet: vigil (review), bolt (implement), pixel (UX)
# haiku:  forge (scan/research), muse (content research)
```

**Requirement FR-MOD-01:** Each agent MUST declare its preferred model in YAML frontmatter.

**Requirement FR-MOD-02:** Orchestrator MUST pass model selection when spawning agents.

**Requirement FR-MOD-03:** Model selection MUST be overridable by user (`/aegis-pipeline --all-opus`).

#### 3.2.3 Dual-Mode Orchestration

```
Decision logic:
  IF task needs inter-agent communication → Agent Team mode
  IF task is independent scan/review      → Subagent mode
  IF user explicitly requests             → Honor user choice

Agent Team triggers:
  - /aegis-team-*         → Always Agent Team
  - Party mode debate     → Agent Team
  - Cross-layer feature   → Agent Team

Subagent triggers:
  - /aegis-pipeline       → Subagent (agents don't need to talk)
  - /aegis-verify         → Subagent (independent checks)
  - /aegis-review [file]  → Subagent (single agent)
```

**Requirement FR-ORC-01:** Orchestrator MUST support both subagent and Agent Team dispatch.

**Requirement FR-ORC-02:** Orchestrator MUST auto-select mode based on task type.

**Requirement FR-ORC-03:** User MUST be able to override mode (`--team` or `--subagent` flag).

#### 3.2.4 Layered Pipeline with Review Gates

```
Phase 1: Research (parallel, subagent)
  ├── Sage: scan standards
  ├── Forge: scan tech debt
  └── Havoc: scan security
          │
    ┌─────┴─────┐
    │ GATE 1    │  ← Navi reviews: are findings consistent? any blockers?
    │ (Navi)    │     If blocker found → STOP, report to user
    └─────┬─────┘
          │
Phase 2: Deep analysis (parallel, subagent or team)
  ├── Vigil: code review (reads Phase 1 findings)
  └── Bolt: API docs check
          │
    ┌─────┴─────┐
    │ GATE 2    │  ← Vigil reviews: does Bolt's output match standards?
    │ (Vigil)   │     If conflict → flag for human decision
    └─────┬─────┘
          │
Phase 3: Synthesis (sequential)
  └── Navi: unified report with all findings
```

**Requirement FR-GATE-01:** Each pipeline phase MUST end with a review gate.

**Requirement FR-GATE-02:** Review gate MUST validate: output exists, format correct, no contradictions between agents.

**Requirement FR-GATE-03:** Gate failure MUST halt pipeline and report to user (not silently continue).

#### 3.2.5 Progressive Disclosure in Skills

```markdown
# Current (v5): Full SKILL.md loaded every time (~500 lines)

# v6: Two-tier structure
---
name: code-review
description: "..." # This is all Claude reads for matching (< 50 tokens)
---

## Quick Reference (always loaded by orchestrator)
- 5-pass review: Correctness → Security → Performance → Maintainability → SDD
- Output: _aegis-output/review-report.md
- Severity: 🔴 Critical / 🟡 Warning / 🔵 Suggestion

## Full Instructions (loaded only when skill is invoked)
[... detailed 400-line instructions ...]
```

**Requirement FR-PD-01:** Every SKILL.md MUST have a `## Quick Reference` section (max 20 lines).

**Requirement FR-PD-02:** Orchestrator MUST load only Quick Reference when scanning skills for matching.

**Requirement FR-PD-03:** Full SKILL.md MUST be loaded only when the skill is actually invoked.

#### 3.2.6 Context Budget Manager

```
Pre-flight check (before any pipeline):
  1. Read current context usage (/context)
  2. If > 20% already → WARN user: "Consider /clear before pipeline"
  3. Estimate pipeline cost:
     - Phase 1 (3 agents × ~10K tokens summary) = ~30K
     - Phase 2 (2 agents × ~15K) = ~30K
     - Phase 3 (synthesis ~10K) = ~10K
     - Total estimated: ~70K tokens (35% of 200K)
  4. If estimated > remaining budget → suggest /compact first

Runtime monitoring:
  - Each agent prompt includes: "Keep output concise — max 2000 tokens per report"
  - Monitor progress: if any agent approaching limits → early compact

Post-run summary:
  - "Pipeline used 68K tokens (34%). Remaining: 132K (66%)"
```

**Requirement FR-CTX-01:** Orchestrator MUST check context usage before dispatching agents.

**Requirement FR-CTX-02:** Orchestrator MUST warn user if starting context > 20%.

**Requirement FR-CTX-03:** Each agent prompt MUST include token budget instruction.

**Requirement FR-CTX-04:** Post-pipeline summary MUST include context usage stats.

#### 3.2.7 Extract Learning Skill

```
Trigger: /aegis-learn or "extract learning from this session"

Process:
  1. Read conversation history (current session)
  2. Extract: decisions made, patterns discovered, mistakes caught, new conventions
  3. Classify: architecture decisions, code patterns, bug patterns, process improvements
  4. Save to: .claude/learnings/{date}-{topic}.md
  5. Update: .claude/references/project-knowledge.md (append new learnings)

Output:
  ## Learning: [topic]
  **Date:** [date]
  **Session:** [session context]
  
  ### Decisions
  - [decision 1]: [rationale]
  
  ### Patterns Discovered
  - [pattern]: [where found, how to apply]
  
  ### Mistakes Caught
  - [mistake]: [how it was caught, prevention rule]
  
  ### New Conventions
  - [convention]: [add to STANDARDS.md? add to CLAUDE.md?]
```

**Requirement FR-LRN-01:** Extract learning skill MUST produce structured markdown.

**Requirement FR-LRN-02:** Learnings MUST be categorized (decisions, patterns, mistakes, conventions).

**Requirement FR-LRN-03:** Skill MUST suggest which learnings to add to CLAUDE.md or STANDARDS.md.

---

## 4. Agent Team Definitions — ⚡ Bolt

### 4.1 Pre-configured Teams

```
.claude/teams/                         ← NEW
├── aegis-review/
│   ├── config.json                    # Team: Vigil (lead) + Havoc + Forge
│   └── README.md                      # When to use, expected output
├── aegis-build/
│   ├── config.json                    # Team: Bolt (lead) + Sage + Vigil
│   └── README.md
├── aegis-debate/
│   ├── config.json                    # Team: Navi (lead) + ALL personas
│   └── README.md
└── aegis-fullstack/
    ├── config.json                    # Team: Bolt-FE + Bolt-BE + Vigil + Forge
    └── README.md
```

### 4.2 Team Configurations

#### Review Team (`/aegis-team-review`)
```json
{
  "name": "aegis-review",
  "lead": "vigil",
  "teammates": ["havoc", "forge"],
  "task_pattern": "Vigil reviews code, Havoc challenges security, Forge checks git hygiene. Share findings via mailbox. Vigil synthesizes final verdict.",
  "model_routing": {
    "vigil": "sonnet",
    "havoc": "opus",
    "forge": "haiku"
  }
}
```

#### Build Team (`/aegis-team-build`)
```json
{
  "name": "aegis-build",
  "lead": "bolt",
  "teammates": ["sage", "vigil"],
  "task_pattern": "Sage provides spec, Bolt implements, Vigil reviews each component. Bolt and Sage communicate directly when spec is unclear.",
  "model_routing": {
    "bolt": "sonnet",
    "sage": "opus",
    "vigil": "sonnet"
  }
}
```

#### Debate Team (`/aegis-team-debate`)
```json
{
  "name": "aegis-debate",
  "lead": "navi",
  "teammates": ["sage", "bolt", "havoc"],
  "task_pattern": "Navi poses the question. Sage proposes spec. Bolt evaluates feasibility. Havoc challenges everything. They debate via mailbox until consensus or deadlock. Navi synthesizes final recommendation.",
  "model_routing": {
    "navi": "opus",
    "sage": "opus",
    "bolt": "sonnet",
    "havoc": "opus"
  }
}
```

### 4.3 New Commands

| Command | Mode | Team | Use Case |
|---------|------|------|----------|
| `/aegis-team-review` | Agent Team | Vigil + Havoc + Forge | Deep multi-perspective review |
| `/aegis-team-build` | Agent Team | Bolt + Sage + Vigil | Spec → implement → review cycle |
| `/aegis-team-debate` | Agent Team | Navi + Sage + Bolt + Havoc | Architecture decision |
| `/aegis-learn` | Single | Navi | Extract session learnings |
| `/aegis-context` | Single | Navi | Check context budget |

---

## 5. Quality & Testing — 🛡️ Vigil

### 5.1 Acceptance Criteria per Upgrade

#### AC-01: Progressive Disclosure
- Given a fresh session, when AEGIS scans available skills, then only `description` from YAML frontmatter is loaded (< 50 tokens per skill)
- Given a skill is invoked, when the agent starts working, then the full SKILL.md is read
- Given 19 skills, when all are scanned, then total context used < 1000 tokens (vs ~10K in v5)

#### AC-02: Shared References
- Given agent sage.md, when it needs progress reporting rules, then it reads `.claude/references/progress-protocol.md`
- Given a rule change in progress-protocol.md, when any agent runs next, then it picks up the new rule
- Given 8 agent files, when diffed against v5, then zero duplicated instruction blocks

#### AC-03: Model Routing
- Given `/aegis-pipeline` command, when agents are spawned, then each uses its declared model
- Given `--all-opus` flag, when agents are spawned, then all agents use opus regardless of default
- Given agent running on haiku, when output quality is insufficient, then orchestrator can retry on sonnet

#### AC-04: Agent Teams
- Given `/aegis-team-debate`, when team spawns, then agents can message each other directly
- Given Havoc challenges Sage's spec, when Sage responds, then the response goes to Havoc (not through Navi)
- Given team completes, when Navi synthesizes, then synthesis includes inter-agent messages as evidence

#### AC-05: Review Gates
- Given Phase 1 agents complete, when Gate 1 runs, then it validates all expected reports exist
- Given an agent produced invalid output, when gate checks, then pipeline halts with clear error message
- Given gate passes, when Phase 2 starts, then Phase 2 agents receive Phase 1 findings as input

#### AC-06: Context Budget
- Given a new session at 25% context, when user runs `/aegis-pipeline`, then they see warning
- Given pipeline completes, when results are shown, then context usage delta is displayed
- Given context > 60%, when auto-compact triggers, then AEGIS learnings are preserved in compact summary

#### AC-07: Extract Learning
- Given a productive session, when user runs `/aegis-learn`, then learnings file is created in `.claude/learnings/`
- Given learnings file exists, when new session starts, then Navi can reference past learnings
- Given a learning suggests a CLAUDE.md update, when presented to user, then the specific addition is shown

### 5.2 Regression Risks

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Progressive disclosure breaks skill matching | Skills stop triggering | Validate all 19 triggers after refactor |
| Agent Teams experimental flag changes | Teams stop working | Feature-detect, fallback to subagent |
| Model routing spawns wrong model | Cost explosion or quality drop | Log model per agent, alert on mismatch |
| Review gates too strict | Pipeline never completes | Gates are advisory, user can override |
| Context monitoring inaccurate | False warnings | Cross-check with /context output |

---

## 6. Risk Assessment — 🔴 Havoc

### 6.1 Kill Scenarios

| # | Scenario | Probability | Impact | Mitigation |
|---|----------|-------------|--------|-----------|
| K1 | Agent Teams flag removed by Anthropic | Medium | High — team mode breaks | Fallback to subagent, detect at startup |
| K2 | Model routing breaks with CC update | Low | Medium — wrong model used | Validate model field on each dispatch |
| K3 | Progressive disclosure causes trigger miss | Medium | High — skills stop working | Keep description in YAML (always loaded) |
| K4 | Reference files create circular dependency | Low | Medium — agent hangs | Max 2 levels of file reference, no cycles |
| K5 | Context budget calculator is wrong | Medium | Low — false warnings only | Advisory only, user can ignore |
| K6 | Learning extraction captures sensitive data | Low | High — data leak | Sanitize output, never include secrets/tokens |

### 6.2 Backward Compatibility

**Requirement NFR-BC-01:** v5.x skills MUST work without modification on v6.0 orchestrator.

**Requirement NFR-BC-02:** v5.x agent definitions MUST work (model defaults to sonnet if not specified).

**Requirement NFR-BC-03:** v5.x commands MUST still function (subagent mode remains default).

**Requirement NFR-BC-04:** install.sh `--upgrade` from v5.x to v6.0 MUST preserve all user customizations.

---

## 7. Deployment & Upgrade — 🔧 Forge

### 7.1 File Changes Summary

| Action | Files |
|--------|-------|
| **NEW** | `.claude/references/` (4 files) |
| **NEW** | `.claude/teams/` (3 team configs) |
| **NEW** | `skills/extract-learning/SKILL.md` |
| **NEW** | `skills/context-budget/SKILL.md` |
| **NEW** | `.claude/commands/aegis-team-review.md` |
| **NEW** | `.claude/commands/aegis-team-build.md` |
| **NEW** | `.claude/commands/aegis-team-debate.md` |
| **NEW** | `.claude/commands/aegis-learn.md` |
| **NEW** | `.claude/commands/aegis-context.md` |
| **MODIFIED** | All 8 agent definitions (add `model:`, reference links, remove duplicates) |
| **MODIFIED** | `skills/aegis-orchestrator/SKILL.md` (dual-mode, gates, context budget) |
| **MODIFIED** | `skills/*/SKILL.md` (add Quick Reference sections) |
| **MODIFIED** | `install.sh` → v6.0 (install teams/, references/) |
| **MODIFIED** | `README.md` (new sections, updated diagrams) |

### 7.2 install.sh v6.0 Changes

```bash
# New in v6.0:
# - Install .claude/references/
# - Install .claude/teams/
# - Install new skills (extract-learning, context-budget)
# - Install new commands (5 new)
# - Migration: add model: field to existing agent definitions
# - Migration: add Quick Reference to existing SKILL.md files
```

### 7.3 Version Migration

```
v5.4 → v6.0:
  1. Backup current installation
  2. Install new directories: references/, teams/
  3. Add model: field to agent definitions (default: sonnet if not specified)
  4. Refactor agent definitions to use references/ (remove duplicates)
  5. Add Quick Reference section to all SKILL.md files
  6. Install new skills: extract-learning, context-budget
  7. Install new commands: 5 new commands
  8. Update orchestrator with dual-mode + gates + context budget
  9. Update README with new architecture diagrams
```

---

## 8. Implementation Priority — 🧭 Navi

### 8.1 Phased Delivery

```
Phase A (Quick wins — do first):
  [1] Model routing per agent          (30 min)  — immediate cost reduction
  [2] Shared reference files           (45 min)  — remove duplication
  [3] Progressive disclosure           (1 hr)    — reduce context footprint

Phase B (Core architecture):
  [4] Review gates in pipeline         (45 min)  — prevent broken output
  [5] Context budget awareness         (30 min)  — prevent context overflow
  [6] Extract learning skill           (30 min)  — build institutional knowledge

Phase C (Agent Teams):
  [7] Agent Team definitions + configs (1 hr)    — enable mesh communication
  [8] New team commands                (30 min)  — /aegis-team-review, -build, -debate
  [9] Dual-mode orchestrator           (1 hr)    — auto-select subagent vs team

Phase D (Polish):
  [10] Update README + docs            (45 min)  — new architecture diagrams
  [11] Update install.sh               (30 min)  — v6.0 upgrade path
  [12] Repackage all .skill files      (15 min)  — master zip v6.0
```

### 8.2 Estimated Total Effort

| Phase | Effort | Impact |
|-------|--------|--------|
| A (Quick wins) | 2h 15m | 40% cost reduction + 80% context reduction |
| B (Core) | 1h 45m | Quality gates + learning + budget |
| C (Agent Teams) | 2h 30m | Mesh communication + real debate |
| D (Polish) | 1h 30m | Documentation + packaging |
| **Total** | **~8 hours** | **Full v6.0** |

---

## 9. Open Questions — Team

| # | Question | Owner | Impact |
|---|---------|-------|--------|
| Q1 | Is Agent Teams flag stable enough for production? | 🔧 Forge | Determines if we ship team mode as default or opt-in |
| Q2 | What's the actual token cost difference between subagent and Agent Team? | 🔴 Havoc | Affects model routing recommendations |
| Q3 | Should Quick Reference be in YAML frontmatter or as a separate section? | 📐 Sage | Affects how orchestrator reads skills |
| Q4 | How to handle learnings when user has multiple projects? | 🧭 Navi | Affects learning file location (project vs global) |
| Q5 | Should review gates be blocking or advisory? | 🛡️ Vigil | Affects pipeline flow (strict vs flexible) |

---

## 10. Sign-off

| Persona | Status | Notes |
|---------|--------|-------|
| 🧭 Navi | ✅ Approved | Priority ranking reflects real usage patterns |
| 📐 Sage | ✅ Approved | Requirements are INVEST-compliant and testable |
| ⚡ Bolt | ✅ Approved | Implementation plan is feasible within estimates |
| 🛡️ Vigil | ✅ Approved | Acceptance criteria cover all new features + regressions |
| 🔴 Havoc | ⚠️ Conditional | Concerned about Agent Teams stability — needs fallback |
| 🔧 Forge | ✅ Approved | Upgrade path preserves backward compatibility |
| 🖌️ Pixel | ✅ Approved | Developer UX improved — fewer commands to remember |
| 🎨 Muse | ✅ Approved | README updates will showcase new capabilities |

**Havoc's condition:** Agent Teams mode MUST have automatic fallback to subagent mode if the experimental flag is unavailable. This MUST be tested before shipping.

**Decision: APPROVED for implementation — start Phase A immediately.**
