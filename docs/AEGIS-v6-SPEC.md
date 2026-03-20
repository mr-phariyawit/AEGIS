# 🛡️ AEGIS v6.0 — Specification Document

> **Codename: "Context is King, Memory is Soul"**
>
> Hybrid Agent Teams + Context Management + Persistent Brain
>
> Inspired by: Oracle Framework (Soul-Brews-Studio), Claude Thailand Community transcript, production dogfood

**Written by:** AEGIS Team (Party Mode) — All 8 personas

**Version:** 2.0 (Rewrite — Oracle-integrated)
**Date:** 2026-03-20
**Status:** DRAFT

---

## 1. Why v6 — The Three Sources of Truth

### Source 1: Dogfood (Our own Claude Code project)
- ✅ All 19 skills trigger correctly
- ✅ Subagent dispatch works
- ⚠️ False-ready signal (fixed v5.4.1)
- ❌ Every session starts from zero — no persistent memory
- ❌ Agents can't communicate with each other

### Source 2: Claude Thailand Community (3 speakers)

| Pattern | Speaker | Insight |
|---------|---------|---------|
| Progressive disclosure | Mickey (AX Digital) | Load context lazily — AI should know only what's needed for THIS task |
| Shared reference files | Mickey | DRY — create 1 reference file, skills point to it |
| Layered orchestration | Mickey | Research → Implement → Integrate with review gates between |
| Model routing | Mickey | Leader=Opus, Implement=Sonnet, Research=Haiku |
| Agent Teams (tmux) | Mickey + Joon | Mesh communication, shared task list, 9 agents in 16 min |
| Extract learning | Mickey | `/extract-learning` saves session knowledge for next time |
| Context budget (20% rule) | New (Debox) | Start ≤20%, auto-compact at 60-70%, buffer 16.5% |

### Source 3: Oracle Framework (Soul-Brews-Studio)

| Component | What We Learned |
|-----------|----------------|
| **ψ Brain** | 5-pillar directory structure with knowledge flowing: active → logs → retros → learnings → resonance (soul) |
| **rrr Retrospective** | Forced reflection every session: AI Diary 150+ words + Honest Feedback 3 friction points |
| **Knowledge Distillation** | 948 files → 15 files (98.4% reduction) without losing knowledge. Git preserves everything. |
| **MAW (multi-agent-workflow-kit)** | tmux + git worktree: each agent = own branch + workspace. `maw hey 1 "task"` CLI |
| **Modular CLAUDE_*.md** | Hub file ~500 tokens + lazy-loaded detail files with "When to Read" priority table |
| **Skills Profiles** | minimal (8) / standard (13) / full (31) + feature stacking (`/go + soul`) |
| **Subagent Delegation** | "Opus writes, Haiku gathers. Never reverse." Main writes synthesis. |
| **Session Activity** | Per-agent focus state (working/pending/jumped) + continuous activity.log |
| **Safety Rules** | NEVER amend (breaks all agents), NEVER force push, `git -C` not `cd` |

---

## 2. Architecture Overview — 📐 Sage

### 2.1 Three New Layers

```
v5.4 (Current):                v6.0 (Target):
┌────────────┐                 ┌─────────────────────────┐
│ Skills     │                 │ Skills + Profiles       │  ← minimal/standard/full
│ Personas   │                 │ Personas + Model Route  │  ← opus/sonnet/haiku
│ Subagents  │                 │ Agent Teams (tmux+MAW)  │  ← mesh communication
│            │                 │ ψ Brain (memory layer)  │  ← NEW: persistent knowledge
│            │                 │ Session Lifecycle       │  ← NEW: start → work → retro → handoff
│            │                 │ Context Budget          │  ← NEW: 20% rule + monitoring
└────────────┘                 └─────────────────────────┘
```

### 2.2 New Directory Structure

```
project/
├── .claude/
│   ├── agents/              # 8 personas (existing) + model: field
│   ├── commands/            # 9 commands (4 existing + 5 new)
│   ├── references/          # NEW: shared reference files (DRY)
│   │   ├── progress-protocol.md
│   │   ├── output-format.md
│   │   ├── review-checklist.md
│   │   └── context-rules.md
│   └── teams/               # NEW: Agent Team configs
│       ├── aegis-review/
│       ├── aegis-build/
│       └── aegis-debate/
├── skills/                  # 21 skills (19 existing + 2 new)
├── _aegis-brain/            # NEW: persistent knowledge (ψ equivalent)
│   ├── resonance/           # Project identity + conventions
│   ├── learnings/           # Patterns discovered per session
│   ├── retrospectives/      # Session retrospectives (YYYY-MM/DD/)
│   └── logs/                # Activity log + session states
├── _aegis-output/           # Runtime output (existing)
├── CLAUDE.md                # REWRITE: ultra-lean hub (~500 tokens)
├── CLAUDE_agents.md         # NEW: agent reference (lazy-loaded)
├── CLAUDE_skills.md         # NEW: skill catalog (lazy-loaded)
├── CLAUDE_lessons.md        # NEW: patterns + anti-patterns (lazy-loaded)
└── CLAUDE_safety.md         # NEW: safety rules (always loaded)
```

---

## 3. Component Specifications

### 3.1 ψ Brain → `_aegis-brain/` — 🧭 Navi

The persistent knowledge layer. Survives across sessions. Grows with every project.

```
_aegis-brain/
├── resonance/                    # WHO THIS PROJECT IS
│   ├── project-identity.md       # Project name, stack, conventions
│   ├── team-conventions.md       # Coding standards, review norms
│   └── architecture-decisions.md # ADRs from retrospectives
│
├── learnings/                    # PATTERNS WE FOUND
│   └── YYYY-MM-DD_slug.md       # One file per learning
│
├── retrospectives/               # SESSIONS WE HAD
│   └── YYYY-MM/DD/
│       └── HH.MM_slug.md        # One file per session
│
└── logs/
    └── activity.log              # Continuous append-only log
```

**Knowledge flow** (Oracle-proven pipeline):

```
_aegis-output/ → _aegis-brain/logs/ → retrospectives/ → learnings/ → resonance/
  (raw reports)    (activity snapshots)   (session retros)    (patterns)      (identity)
```

**Distillation** (periodic):
When learnings/ exceeds 50 files → run `/aegis-distill`:
- Compress per-topic into summaries
- Promote patterns that appear 3+ times to `resonance/`
- Git history preserves originals. "Nothing is truly deleted."

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-BRN-01 | `_aegis-brain/` MUST be created by install.sh during AEGIS setup |
| FR-BRN-02 | `/aegis-retro` MUST write retrospective to `_aegis-brain/retrospectives/YYYY-MM/DD/` |
| FR-BRN-03 | `/aegis-retro` MUST extract lessons to `_aegis-brain/learnings/` |
| FR-BRN-04 | Navi MUST read `_aegis-brain/resonance/` at session start for project context |
| FR-BRN-05 | `_aegis-brain/logs/activity.log` MUST be append-only, timestamped |
| FR-BRN-06 | Git: `_aegis-brain/` SHOULD be tracked (committed to repo) — project knowledge belongs with the project |

### 3.2 Session Lifecycle — 🧭 Navi

Every session has a beginning and ending ritual.

```
SESSION START                    SESSION END
┌──────────────┐                 ┌──────────────┐
│ /aegis-start │                 │ /aegis-retro │
│              │                 │              │
│ 1. Check context budget        │ 1. Gather: git log, diff stats
│ 2. Read resonance/             │ 2. Write: session summary
│ 3. Read latest learnings       │ 3. Write: AI diary (150+ words)
│ 4. Show pending from last      │ 4. Write: honest feedback (3 points)
│ 5. Set focus state: working    │ 5. Extract: lessons learned
│                                │ 6. Set focus state: completed
└──────────────┘                 └──────────────┘
        │                                │
        ▼                                ▼
   WORK WITH AGENTS              /aegis-handoff (optional)
   (pipeline, review,            Prepare context for next session
    team, build...)              "Here's where we left off..."
```

**Short codes** (Oracle-proven pattern):

| Code | Command | Purpose |
|------|---------|---------|
| `/aegis-start` | Session start | Context check + load brain + show pending |
| `/aegis-retro` | Session end | Retrospective + lessons + diary |
| `/aegis-handoff` | Session transfer | Prepare handoff for next session |
| `/aegis-distill` | Knowledge management | Compress learnings, promote patterns to resonance |

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-SES-01 | `/aegis-start` MUST check context budget and warn if >20% |
| FR-SES-02 | `/aegis-start` MUST load `_aegis-brain/resonance/` for project identity |
| FR-SES-03 | `/aegis-retro` MUST include AI diary (150+ words, first-person reflection) |
| FR-SES-04 | `/aegis-retro` MUST include honest feedback (3 friction points minimum) |
| FR-SES-05 | `/aegis-retro` MUST be written by main agent (Opus/Navi), never by subagent |
| FR-SES-06 | `/aegis-handoff` MUST summarize: what was done, what's pending, blockers |

### 3.3 Modular CLAUDE_*.md — 📐 Sage

Ultra-lean hub + lazy-loaded details. Oracle-proven pattern.

**CLAUDE.md (hub — max 500 tokens):**

```markdown
# AEGIS — [Project Name]

## Navigation
| File | When to Read | Priority |
|------|-------------|----------|
| CLAUDE.md | Every session | 🔴 Required |
| CLAUDE_safety.md | Before git/file ops | 🔴 Required |
| CLAUDE_agents.md | Before spawning agents | 🟡 As needed |
| CLAUDE_skills.md | When choosing skills | 🟡 As needed |
| CLAUDE_lessons.md | When stuck or deciding | 🟢 Reference |

## Golden Rules
1. NEVER use --force flags
2. NEVER push to main — branch + PR always
3. NEVER end turn before agents finish (false-ready guard)
4. Run /aegis-start at session begin
5. Run /aegis-retro at session end

## Quick Reference
[4-5 lines of project-specific context]
```

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-MOD-01 | CLAUDE.md MUST be ≤500 tokens |
| FR-MOD-02 | CLAUDE_safety.md MUST be loaded before any git operation |
| FR-MOD-03 | Other CLAUDE_*.md files MUST be lazy-loaded only when relevant |
| FR-MOD-04 | Each file MUST have navigation links back to hub |

### 3.4 Shared References (DRY) — 📐 Sage

```
.claude/references/
├── progress-protocol.md     # Heartbeat reporting rules (shared by all 8 agents)
├── output-format.md         # Report format standards
├── review-checklist.md      # Common review criteria
└── context-rules.md         # Context budget rules + progressive disclosure
```

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-REF-01 | Every agent definition MUST point to references/ instead of duplicating rules |
| FR-REF-02 | References MUST be loaded only when the agent needs them (lazy) |
| FR-REF-03 | Updating a reference file MUST propagate to all agents automatically |

### 3.5 Model Routing — ⚡ Bolt

```yaml
# In each agent .md frontmatter:
---
name: sage
model: opus
description: "..."
---

# Routing table:
# opus:   navi (synthesis), sage (spec reasoning), havoc (adversarial)
# sonnet: vigil (review), bolt (implement), pixel (UX)
# haiku:  forge (scan/research), muse (content)
```

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-MRT-01 | Each agent MUST declare `model:` in YAML frontmatter |
| FR-MRT-02 | Orchestrator MUST pass model selection when spawning |
| FR-MRT-03 | Default if not specified: sonnet |
| FR-MRT-04 | User override: `--all-opus` flag forces all agents to opus |

### 3.6 Progressive Disclosure in Skills — 📐 Sage

Every SKILL.md gets a two-tier structure:

```markdown
---
name: code-review
description: "..." # ≤50 tokens — this is ALL Claude reads for matching
---

## Quick Reference (loaded by orchestrator for planning)
- 5-pass review: Correctness → Security → Performance → Maintainability → SDD
- Output: _aegis-output/review-report.md
- Severity: 🔴 Critical / 🟡 Warning / 🔵 Suggestion

## Full Instructions (loaded ONLY when skill is invoked)
[... detailed 400-line instructions ...]
```

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-PD-01 | Every SKILL.md MUST have `## Quick Reference` (max 20 lines) |
| FR-PD-02 | Orchestrator loads ONLY Quick Reference when scanning for matches |
| FR-PD-03 | Full SKILL.md loaded only when skill is actually invoked |
| FR-PD-04 | 19 skills x ~50 tokens = ~950 tokens total scan cost (vs ~10K in v5) |

### 3.7 Dual-Mode Orchestration (Subagent + Agent Teams) — ⚡ Bolt

```
Decision logic:
  IF task needs inter-agent communication  → Agent Team (tmux)
  IF task is independent scan/review       → Subagent
  IF user explicitly requests              → Honor user choice

Agent Team mode requires:
  - CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
  - tmux installed (or iTerm2)
  - Fallback: if unavailable → graceful degradation to subagent
```

**Team configurations:**

| Team | Lead | Members | Use Case |
|------|------|---------|----------|
| aegis-review | vigil | havoc, forge | Deep multi-perspective review |
| aegis-build | bolt | sage, vigil | Spec → implement → review cycle |
| aegis-debate | navi | sage, bolt, havoc | Architecture decision debate |

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-ORC-01 | Orchestrator MUST support both subagent and Agent Team dispatch |
| FR-ORC-02 | Orchestrator MUST auto-select mode based on task type |
| FR-ORC-03 | Agent Teams MUST have automatic fallback to subagent if tmux unavailable |
| FR-ORC-04 | User MUST be able to override mode (`--team` or `--subagent`) |

### 3.8 Review Gates Between Pipeline Phases — 🛡️ Vigil

```
Phase 1: Research (parallel subagent)     → GATE 1 (Navi validates)
Phase 2: Deep analysis (parallel/team)    → GATE 2 (Vigil validates)
Phase 3: Synthesis (Navi sequential)      → Present to user
```

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-GATE-01 | Each pipeline phase MUST end with a review gate |
| FR-GATE-02 | Gate MUST validate: output exists, format correct, no contradictions |
| FR-GATE-03 | Gate failure MUST halt pipeline and report to user |
| FR-GATE-04 | Gates are advisory — user can override with `--skip-gates` |

### 3.9 Context Budget Manager — 🔧 Forge

```
Pre-flight (/aegis-start):
  1. Check context: if >20% → WARN
  2. Estimate pipeline cost (~70K for full pipeline)
  3. If estimated > remaining → suggest /compact first

Runtime:
  - Agent prompts include: "Keep output concise — max 2000 tokens"
  - Monitor: if approaching 60% → warn about auto-compact

Post-run:
  - "Pipeline used 68K tokens (34%). Remaining: 132K (66%)"
```

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-CTX-01 | `/aegis-start` MUST check context usage before any work |
| FR-CTX-02 | MUST warn user if starting context >20% |
| FR-CTX-03 | Each agent prompt MUST include token budget instruction |
| FR-CTX-04 | Post-pipeline MUST report context usage delta |

### 3.10 Skill Profiles — 🖌️ Pixel

```
/aegis-mode minimal    →  7 skills: personas, orchestrator, code-review,
                          code-standards, git-workflow, bug-lifecycle, project-navigator

/aegis-mode standard   → 13 skills: minimal + super-spec, test-architect,
                          security-audit, tech-debt-tracker, sprint-tracker, api-docs

/aegis-mode full       → 21 skills: all skills including teams + brain
```

**Requirements:**

| ID | Requirement |
|----|-------------|
| FR-PRF-01 | install.sh MUST support `--profile minimal/standard/full` |
| FR-PRF-02 | `/aegis-mode` command MUST switch profiles at runtime |
| FR-PRF-03 | Minimal profile MUST fit within 20% context budget at start |

---

## 4. New Commands Summary — ⚡ Bolt

| Command | Type | Purpose |
|---------|------|---------|
| `/aegis-start` | Session | Begin session: check context, load brain, show pending |
| `/aegis-retro` | Session | End session: retrospective, lessons, diary, handoff |
| `/aegis-handoff` | Session | Prepare context transfer for next session |
| `/aegis-distill` | Knowledge | Compress learnings, promote patterns to resonance |
| `/aegis-context` | Utility | Check context budget status |
| `/aegis-team-review` | Agent Team | Spawn review team (Vigil + Havoc + Forge) |
| `/aegis-team-build` | Agent Team | Spawn build team (Bolt + Sage + Vigil) |
| `/aegis-team-debate` | Agent Team | Spawn debate team (all personas) |
| `/aegis-mode` | Config | Switch skill profile (minimal/standard/full) |

Existing commands preserved:
- `/aegis-pipeline` — full pipeline (subagent mode)
- `/aegis-verify` — verification pipeline
- `/aegis-launch` — go/no-go launch check
- `/aegis-status` — check agent progress

---

## 5. Safety Rules — 🛡️ Vigil (adapted from Oracle)

### 5.1 Git Safety (from Oracle CLAUDE_safety.md)

| Rule | Why |
|------|-----|
| NEVER use `--force` flags | Destroys history |
| NEVER push to main | Always branch + PR |
| NEVER `git commit --amend` | Breaks all agents (hash divergence) |
| NEVER `git reset --hard` on agent worktrees | Agents may have uncommitted work |
| Use `git -C` not `cd` | Respect worktree boundaries |

### 5.2 Agent Safety (from Oracle + dogfood)

| Rule | Why |
|------|-----|
| Main agent (Opus/Navi) writes synthesis | Needs full context + reflection |
| Subagent (Haiku) gathers data only | Cost efficiency + token savings |
| NEVER end turn before agents finish | False-ready signal prevention |
| NEVER let subagent write retrospective | Only main has vulnerability + nuance |

### 5.3 Context Safety (from Community)

| Rule | Why |
|------|-----|
| Start session ≤20% context | Leave room for actual work |
| Progressive disclosure always | Load only what's needed |
| Keep agent reports ≤2000 tokens | Prevent context bloat |
| Use references/ not duplication | Single source of truth |

---

## 6. Acceptance Criteria — 🛡️ Vigil

### AC-01: Brain Layer
- Given a new AEGIS installation, when install.sh runs, then `_aegis-brain/` is created with all subdirectories
- Given `/aegis-retro`, when session ends, then retrospective file exists at correct dated path
- Given 3+ sessions, when `/aegis-distill` runs, then learnings are compressed and patterns promoted

### AC-02: Session Lifecycle
- Given `/aegis-start`, when context >20%, then user sees warning
- Given `/aegis-retro`, when run, then AI diary ≥150 words and feedback has ≥3 friction points
- Given `/aegis-handoff`, when run, then next session can load pending tasks

### AC-03: Modular CLAUDE_*.md
- Given fresh session, when CLAUDE.md is loaded, then ≤500 tokens used
- Given agent spawning needed, when CLAUDE_agents.md loaded, then contains all 8 agent references

### AC-04: Model Routing
- Given `/aegis-pipeline`, when agents spawn, then each uses declared model
- Given `--all-opus` flag, then all agents use opus

### AC-05: Agent Teams
- Given `/aegis-team-debate`, when tmux available, then agents message each other directly
- Given tmux NOT available, when team command runs, then graceful fallback to subagent with warning

### AC-06: Progressive Disclosure
- Given 21 skills scanned, then total context used <1000 tokens (vs ~10K in v5)
- Given skill invoked, then full SKILL.md loaded at that point only

### AC-07: Context Budget
- Given session at 25% context, when `/aegis-start` runs, then warning is displayed
- Given pipeline completes, then context usage delta is shown

---

## 7. Risk Assessment — 🔴 Havoc

| # | Risk | P | I | Mitigation |
|---|------|---|---|-----------|
| K1 | Agent Teams flag removed | M | H | Automatic fallback to subagent mode |
| K2 | Brain directory conflicts with project structure | L | M | Use `_aegis-brain/` prefix (unlikely to conflict) |
| K3 | Retrospectives become stale/noisy | M | L | Distillation process compresses periodically |
| K4 | Progressive disclosure breaks trigger matching | M | H | Keep description in YAML (always loaded) |
| K5 | Model routing spawns wrong model | L | M | Log model per agent, validate on dispatch |
| K6 | CLAUDE.md split causes context-loading gaps | M | M | "When to Read" priority table + safety always loaded |
| K7 | tmux not available on user's system | M | H | Feature-detect at startup, fallback path tested |

---

## 8. Backward Compatibility — 🔧 Forge

| Requirement | Implementation |
|-------------|---------------|
| v5.x skills work on v6.0 | Skills without Quick Reference section still work — full file loaded |
| v5.x agent definitions work | Missing `model:` defaults to sonnet |
| v5.x commands work | Existing 4 commands unchanged |
| install.sh `--upgrade` preserves customizations | Backup → add new files → preserve user edits |
| Projects without `_aegis-brain/` work | Brain features disabled gracefully if directory missing |

---

## 9. Implementation Plan — 🧭 Navi

### Phase A: Foundation (2 hours)
1. Create `_aegis-brain/` structure + README
2. Create `.claude/references/` (4 shared files)
3. Refactor 8 agent definitions (add `model:`, point to references/)
4. Add Quick Reference section to all 19 SKILL.md files

### Phase B: Session Lifecycle (1.5 hours)
5. Create `/aegis-start` command
6. Create `/aegis-retro` command (rrr-inspired)
7. Create `/aegis-handoff` command
8. Create `/aegis-distill` skill

### Phase C: Orchestration Upgrade (2 hours)
9. Add context budget checking to orchestrator
10. Add review gates between pipeline phases
11. Create Agent Team configs (3 teams)
12. Create `/aegis-team-*` commands (3 new)
13. Add dual-mode dispatch logic (subagent vs team)

### Phase D: Polish (1.5 hours)
14. Rewrite CLAUDE.md as ultra-lean hub
15. Create CLAUDE_safety.md, CLAUDE_agents.md, CLAUDE_skills.md, CLAUDE_lessons.md
16. Create `/aegis-mode` command (profile switching)
17. Update install.sh v6.0 (profiles, brain, references, teams)
18. Update README with new architecture diagrams

### Phase E: Validate (1 hour)
19. Dogfood: run full session lifecycle on real project
20. Verify: all 19 original skills still trigger
21. Verify: Agent Teams fallback works when tmux unavailable
22. Verify: context budget stays under 20% at start
23. Commit + push + tag v6.0.0

**Total estimated: ~8 hours across 5 phases**

---

## 10. Sign-off

| Persona | Status | Notes |
|---------|--------|-------|
| 🧭 Navi | ✅ | Brain layer is the biggest upgrade — persistent memory changes everything |
| 📐 Sage | ✅ | Requirements are testable and traced to source (dogfood/community/Oracle) |
| ⚡ Bolt | ✅ | Implementation plan is realistic — phased delivery reduces risk |
| 🛡️ Vigil | ✅ | Safety rules adapted from Oracle are battle-tested at scale |
| 🔴 Havoc | ⚠️ Conditional | Agent Teams MUST have subagent fallback. Brain files MUST NOT contain secrets. |
| 🔧 Forge | ✅ | Backward compatibility path is clear — zero breaking changes |
| 🖌️ Pixel | ✅ | Session lifecycle (start → work → retro → handoff) improves DX significantly |
| 🎨 Muse | ✅ | Oracle acknowledgment in README — credit where credit is due |

**Havoc's conditions:**
1. Agent Teams MUST have automatic fallback to subagent if tmux unavailable
2. `_aegis-brain/` MUST be sanitized — never store tokens, passwords, or secrets
3. `/aegis-retro` AI diary MUST be honest, not performative

**Decision: APPROVED — begin Phase A.**

---

## Appendix: Credit & Inspiration

| Source | Creator | What We Adopted |
|--------|---------|----------------|
| Oracle Brain (ψ/) | Nat Weerawan (Soul-Brews-Studio) | Brain structure, knowledge pipeline, session lifecycle, 5 Principles |
| Multi-Agent Workflow Kit (MAW) | Soul-Brews-Studio (fork: laris-co) | tmux + git worktree pattern, `maw hey` CLI, sync protocol |
| oracle-skills-cli | Soul-Brews-Studio | Profile system, skill catalog, `/rrr` retrospective pattern |
| Claude Thailand Community | Joon, Mickey (AX Digital), New (Debox) | 7 production patterns (transcript analysis) |
| Claude Code Agent Teams | Anthropic | Native mesh communication, shared task list |

> "The Oracle Keeps the Human Human" — Oracle Philosophy
>
> "Context is King" — New (Debox)
>
> "Treat context like system design" — Mickey (AX Digital)
>
> "One command. Eight agents. Zero waiting." — AEGIS
