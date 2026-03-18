---
name: aegis-orchestrator
description: "Autonomous multi-agent orchestrator that dispatches AEGIS personas as parallel subagents. Use this skill whenever the user mentions 'run all checks', 'full pipeline', 'parallel review', 'autonomous mode', 'dispatch agents', 'team build', 'orchestrate', 'run AEGIS pipeline', 'auto mode', or any request that requires multiple personas working together on a codebase. Also triggers on 'รันทั้งหมด', 'โหมดอัตโนมัติ', 'ส่งทีมทำงาน', 'dispatch ทีม', 'ออเคสตร้า'. This is the AGENTIC layer of AEGIS — it transforms personas from conversational characters into real subagents that run in parallel with their own context windows. Works best on Claude Code (native subagents), gracefully degrades to sequential on Claude.ai."
---

# AEGIS Orchestrator — Subagent Dispatch System

> **"One command. Eight agents. Zero waiting."**

The orchestrator transforms AEGIS from a sequential skill system into a **parallel agentic framework**. Instead of invoking personas one-by-one, the orchestrator dispatches them as independent subagents — each with their own context window, focused scope, and specialized tools.

## Platform Capabilities

| Platform | Subagent Support | Parallelism | How |
|----------|-----------------|-------------|-----|
| **Claude Code** | ✅ Native | Up to 10 parallel | `.claude/agents/` + Task tool |
| **Claude Agent SDK** | ✅ Native | Unlimited | Programmatic `agents` parameter |
| **Cowork** | ✅ Partial | Sequential with background | Subagent spawning via tasks |
| **Claude.ai** | ⚠️ Simulated | Sequential only | Persona switching (no true parallel) |

The orchestrator auto-detects the platform and adapts execution strategy.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  AEGIS Orchestrator                       │
│              (dispatch + coordinate + synthesize)         │
└──────────────────────┬──────────────────────────────────┘
                       │ dispatches
          ┌────────────┼────────────┬────────────┐
          ▼            ▼            ▼            ▼
    ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
    │ Sage     │ │ Vigil    │ │ Havoc    │ │ Forge    │
    │ Agent    │ │ Agent    │ │ Agent    │ │ Agent    │
    │          │ │          │ │          │ │          │
    │ Own      │ │ Own      │ │ Own      │ │ Own      │
    │ context  │ │ context  │ │ context  │ │ context  │
    │ window   │ │ window   │ │ window   │ │ window   │
    └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘
         │            │            │            │
         ▼            ▼            ▼            ▼
    [spec report] [review]    [security]   [debt report]
         │            │            │            │
         └────────────┴────────────┴────────────┘
                       │
                       ▼
              ┌──────────────┐
              │  Synthesized  │
              │    Report     │
              └──────────────┘
```

## Orchestration Modes

### Mode 1: Full Pipeline (`/aegis-pipeline`)

Run the complete SDLC+AI loop for a codebase:

```
"Run the full AEGIS pipeline on this project"
"รันไปป์ไลน์เต็มรูปแบบ"
```

**Dispatch plan:**

```
Phase 1 — PARALLEL (independent research)
├── Sage Agent      → scan specs, check standards compliance
├── Vigil Agent     → run code review on changed files
├── Havoc Agent     → security audit + adversarial review
└── Forge Agent     → scan tech debt + check git hygiene

Phase 2 — PARALLEL (depends on Phase 1 findings)
├── Vigil Agent     → run test coverage analysis
└── Bolt Agent      → check API docs drift

Phase 3 — SEQUENTIAL (synthesis)
└── Navi Agent      → synthesize all reports → produce unified status
```

**Claude Code implementation:**

```markdown
## Orchestration Rules for Claude Code

When the user requests a full pipeline, dispatch agents using the Task tool:

### Phase 1: Parallel Research (4 agents)
Spawn these tasks simultaneously:

Task 1 — Sage Analysis:
"You are Sage, the AEGIS Spec Architect. Read skills/code-standards/SKILL.md.
Scan the project for standards compliance. Check: naming conventions, import
order, function length, type safety. Output a Standards Compliance Report
in Markdown. Save to _aegis-output/standards-report.md"

Task 2 — Vigil Review:
"You are Vigil, the AEGIS Code Guardian. Read skills/code-review/SKILL.md.
Perform a 5-pass code review on all files changed in the last 7 days
(use git diff HEAD~7). Output a Code Review Report with severity-ranked
findings. Save to _aegis-output/review-report.md"

Task 3 — Havoc Audit:
"You are Havoc, the AEGIS Red Team. Read skills/security-audit/SKILL.md
and skills/adversarial-review/SKILL.md. Run security audit: check for
hardcoded secrets, dependency vulnerabilities (npm audit), OWASP Top 10
patterns. Also challenge top 3 architecture decisions. Output Security
& Adversarial Report. Save to _aegis-output/security-report.md"

Task 4 — Forge Scan:
"You are Forge, the AEGIS DevOps Engineer. Read skills/tech-debt-tracker/SKILL.md
and skills/git-workflow/SKILL.md. Scan for TODO/FIXME markers, complexity
hotspots, outdated dependencies. Check git hygiene: commit message format,
branch naming. Output Tech Debt & Git Report. Save to _aegis-output/debt-report.md"

### Phase 2: Dependent Analysis (wait for Phase 1)
After Phase 1 completes:

Task 5 — Vigil Coverage:
"You are Vigil. Read skills/code-coverage/SKILL.md. Based on the code
review findings in _aegis-output/review-report.md, analyze test coverage
focusing on the files with critical findings. Suggest missing test cases.
Save to _aegis-output/coverage-report.md"

Task 6 — Bolt Docs:
"You are Bolt. Read skills/api-docs/SKILL.md. Check if API documentation
matches actual endpoints. Report any drift. Save to _aegis-output/docs-report.md"

### Phase 3: Synthesis (wait for Phase 2)
Task 7 — Navi Synthesis:
"You are Navi, the AEGIS Navigator. Read all reports in _aegis-output/.
Produce a unified Project Health Report with: overall score, top blockers,
recommended actions (prioritized), and suggested next persona to invoke.
Save to _aegis-output/AEGIS-REPORT.md"
```

### Mode 2: Verify Gate (`/aegis-verify`)

Run only VERIFY phase agents in parallel:

```
"Run all verify checks before I merge"
"เช็คทุกอย่างก่อน merge"
```

**Dispatch:**
```
PARALLEL
├── Vigil  → code-review + code-coverage
├── Havoc  → security-audit + adversarial-review (Enterprise only)
└── Forge  → git-workflow validation (commit messages, PR template)
```

### Mode 3: Sprint Kickoff (`/aegis-sprint`)

Initialize a new sprint with parallel research:

```
"Start sprint planning for EP-003"
"เริ่มแพลนสปรินท์"
```

**Dispatch:**
```
PARALLEL
├── Sage   → review spec for EP-003, identify stories
├── Pixel  → identify UX needs for EP-003 stories
└── Forge  → carry-over items from last sprint, debt allocation

SEQUENTIAL (after parallel)
└── Forge  → generate sprint-status.yaml with stories from all agents
```

### Mode 4: Launch Readiness (`/aegis-launch`)

Full pre-production checklist:

```
"Run launch readiness check"
"เช็คพร้อม launch"
```

**Dispatch (all parallel):**
```
PARALLEL (max agents)
├── Sage   → spec coverage (all requirements implemented?)
├── Vigil  → code review + coverage (meets thresholds?)
├── Havoc  → security audit + adversarial (no critical issues?)
├── Forge  → tech debt acceptable? git hygiene? sprint complete?
├── Bolt   → API docs current? no drift?
└── Navi   → 9-criteria readiness checklist

SEQUENTIAL
└── Navi   → LAUNCH DECISION: GO / NO-GO with evidence
```

## Agent Definition Files

For Claude Code, place these in `.claude/agents/`:

### File structure
```
.claude/
├── agents/
│   ├── sage.md           # Sage subagent definition
│   ├── pixel.md          # Pixel subagent definition
│   ├── bolt.md           # Bolt subagent definition
│   ├── vigil.md          # Vigil subagent definition
│   ├── havoc.md          # Havoc subagent definition
│   ├── forge.md          # Forge subagent definition
│   ├── muse.md           # Muse subagent definition
│   └── navi.md           # Navi subagent definition
├── commands/
│   ├── aegis-pipeline.md # Full pipeline command
│   ├── aegis-verify.md   # Verify gate command
│   ├── aegis-sprint.md   # Sprint kickoff command
│   └── aegis-launch.md   # Launch readiness command
└── CLAUDE.md             # Project rules (references AEGIS skills)
```

### Agent Definition Template

Each `.claude/agents/*.md` file follows this pattern:

```markdown
---
name: [persona-name]
description: [when to auto-dispatch this agent]
tools: [allowed tools]
---

# System Prompt

You are [Persona Name], an AEGIS persona with the following role:
[personality + communication style from ai-personas SKILL.md]

## Your Skills
Read and follow these skill files:
- skills/[skill-1]/SKILL.md
- skills/[skill-2]/SKILL.md

## Rules
1. Stay in character as [Persona]
2. Only use your assigned skills — redirect others to the right persona
3. Output reports in Markdown to _aegis-output/
4. Include severity levels and actionable recommendations
5. Be direct and specific — no hand-waving

## Output Location
Save all outputs to: _aegis-output/[report-name].md
```

## Orchestrator Dispatch Rules

### Dependency Graph

```
                    ┌─────┐
              ┌────►│Sage │────┐
              │     └─────┘    │
              │     ┌─────┐    │    ┌──────┐
 ┌─────┐      ├────►│Vigil│────┼───►│ Navi │
 │Start│──────┤     └─────┘    │    │Synth │
 └─────┘      │     ┌─────┐    │    └──────┘
              ├────►│Havoc│────┤
              │     └─────┘    │
              │     ┌─────┐    │
              └────►│Forge│────┘
                    └─────┘

Phase 1: Parallel    Phase 2: Synthesis
(independent)        (depends on all)
```

### Conflict Prevention Rules

1. **File isolation** — each agent only reads/writes within its scope:
   - Sage: `*.md` specs, `STANDARDS.md`, lint configs
   - Vigil: test files, coverage reports
   - Havoc: security reports (read-only on source)
   - Forge: `.git/`, sprint YAML, debt reports
   - Bolt: API docs, source code (when implementing)

2. **No cross-agent writes** — agents never modify another agent's output files

3. **Output directory** — all agent outputs go to `_aegis-output/`:
   ```
   _aegis-output/
   ├── standards-report.md    (Sage)
   ├── review-report.md       (Vigil)
   ├── coverage-report.md     (Vigil)
   ├── security-report.md     (Havoc)
   ├── adversarial-report.md  (Havoc)
   ├── debt-report.md         (Forge)
   ├── git-report.md          (Forge)
   ├── docs-report.md         (Bolt)
   └── AEGIS-REPORT.md        (Navi — synthesis)
   ```

4. **Read-only source** — during VERIFY mode, agents only READ source code, never modify it

## Progress Reporting (Heartbeat System)

Every AEGIS subagent MUST report progress to the filesystem after each major step. This solves the "silent agent" problem — where agents appear stuck because there's no visible feedback.

### How It Works

```
Agent starts → writes progress JSON → does step 1 → updates JSON → step 2 → updates → ... → done

Main agent or user can poll:  cat _aegis-output/.progress/sage.json
Watch script auto-refreshes:  ./aegis-watch.sh
Command shortcut:             /aegis-status
```

### Progress File Format

Each agent writes to `_aegis-output/.progress/{agent-name}.json`:

```json
{
  "agent": "sage",
  "status": "running",
  "step": "scanning src/services/",
  "progress": 65,
  "detail": "12 of 18 files checked",
  "findings_so_far": 3,
  "started_at": "09:14:30",
  "last_active": "09:15:03",
  "estimated_remaining": "~45s"
}
```

### Status Values

| Status | Meaning | Display |
|--------|---------|---------|
| `starting` | Agent spawned, loading skill | 🔵 Initializing |
| `running` | Actively working | 🟢 Running |
| `done` | Completed successfully | ✅ Done |
| `error` | Failed with error | 🔴 Error |

### Stall Detection

If `last_active` timestamp is older than 30 seconds from current time, the watch script displays:

```
⚠️  sage: possibly stalled (last active 45s ago)
```

This prevents false confidence from a progress bar that stopped updating.

### Agent Progress Instructions

Every agent definition MUST include this instruction block:

```markdown
## Progress Reporting
After EVERY major step, update your progress file:

mkdir -p _aegis-output/.progress
cat > _aegis-output/.progress/{your-name}.json << 'EOF'
{
  "agent": "{your-name}",
  "status": "running",
  "step": "{what you just did}",
  "progress": {0-100},
  "detail": "{specifics}",
  "findings_so_far": {count},
  "started_at": "{HH:MM:SS when you started}",
  "last_active": "{HH:MM:SS now}"
}
EOF

Write progress at these checkpoints:
1. Agent started (progress: 0, status: starting)
2. After reading skill files (progress: 10)
3. After each major scan/analysis step (progress: 20-90)
4. On completion (progress: 100, status: done)
5. On error (status: error, step: error description)
```

### Completion Summary

When all agents finish, Navi reads all progress files and generates a timing summary:

```markdown
## Pipeline Timing

| Agent | Duration | Steps | Findings |
|-------|----------|-------|----------|
| Sage  | 1m 12s   | 8     | 3        |
| Vigil | 2m 05s   | 12    | 5        |
| Havoc | 1m 45s   | 6     | 2        |
| Forge | 0m 55s   | 5     | 1        |

Total wall time: 2m 05s (parallel)
Sequential equivalent: 5m 57s
Speedup: 2.8x
```

## Claude.ai Fallback (Sequential Mode)

When subagents are unavailable, the orchestrator runs personas sequentially:

```
"Run AEGIS pipeline" (on Claude.ai)

Step 1: [Sage mode] → scan standards → save findings
Step 2: [Vigil mode] → code review → save findings
Step 3: [Havoc mode] → security audit → save findings
Step 4: [Forge mode] → tech debt scan → save findings
Step 5: [Navi mode] → synthesize all findings → final report

Note: Sequential mode takes ~5x longer but produces the same output.
The orchestrator clearly communicates this to the user.
```

## SDK Integration

For applications built with the Claude Agent SDK:

```typescript
import { Agent } from '@anthropic/agent-sdk';

const sageAgent = new Agent({
  name: 'sage',
  description: 'AEGIS Spec Architect — standards and spec analysis',
  systemPrompt: fs.readFileSync('.claude/agents/sage.md', 'utf-8'),
  tools: ['read', 'write', 'bash'],
});

const vigilAgent = new Agent({
  name: 'vigil',
  description: 'AEGIS Code Guardian — review and coverage',
  systemPrompt: fs.readFileSync('.claude/agents/vigil.md', 'utf-8'),
  tools: ['read', 'bash'],
});

// Dispatch in parallel
const results = await Promise.all([
  mainAgent.delegateTo(sageAgent, 'Analyze standards compliance'),
  mainAgent.delegateTo(vigilAgent, 'Review changed files'),
  mainAgent.delegateTo(havocAgent, 'Run security audit'),
  mainAgent.delegateTo(forgeAgent, 'Scan tech debt'),
]);
```

## Output: Unified AEGIS Report

After all agents complete, Navi synthesizes:

```markdown
# 🛡️ AEGIS Pipeline Report
**Project:** [name]
**Date:** [date]
**Mode:** Full Pipeline | Agents: 7 | Duration: 2m 34s

## Overall Health Score: 74/100

## Agent Reports Summary

| Agent | Phase | Findings | Critical | Status |
|-------|-------|----------|----------|--------|
| 📐 Sage | PLAN | Standards: 87% compliant | 0 | ✅ |
| 🛡️ Vigil | VERIFY | 3 issues (1 critical) | 1 | ⚠️ |
| 🔴 Havoc | VERIFY | 2 security findings | 1 | ⚠️ |
| 🔧 Forge | FEEDBACK | Debt score: 68 ↓ | 0 | 🟡 |
| ⚡ Bolt | EXECUTE | 2 API docs drifted | 0 | 🟡 |

## Top Blockers (Must Fix)
1. 🔴 [CR-001] Unhandled promise rejection in payment service (Vigil)
2. 🔴 [SEC-003] JWT secret in source code (Havoc)

## Recommended Actions
1. Fix CR-001 and SEC-003 immediately
2. Update 2 drifted API docs (Bolt)
3. Allocate 20% next sprint to tech debt (Forge)

## Next Persona: 🛡️ Vigil
Reason: Critical code review finding needs re-review after fix
```

## Integration with AEGIS Ecosystem

| Component | Orchestrator's Role |
|-----------|-------------------|
| `project-navigator` | Navi uses pipeline results for recommendations |
| `ai-personas` | Personas become real subagent definitions |
| `sprint-tracker` | Pipeline results feed into sprint status |
| `retrospective` | Pipeline history provides retro data |
| `aegis-builder` | Custom agents follow the same dispatch pattern |

## Commands Quick Reference

| Command | Agents Dispatched | Parallelism |
|---------|------------------|-------------|
| `/aegis-pipeline` | All 7 | Phase 1: 4 parallel → Phase 2: 2 → Phase 3: 1 |
| `/aegis-verify` | Vigil + Havoc + Forge | 3 parallel |
| `/aegis-sprint` | Sage + Pixel + Forge | 3 parallel → 1 sequential |
| `/aegis-launch` | All 6 + Navi | 6 parallel → 1 sequential |
| `/aegis-review [file]` | Vigil + Havoc | 2 parallel |
| `/aegis-debt` | Forge only | 1 (focused scan) |
