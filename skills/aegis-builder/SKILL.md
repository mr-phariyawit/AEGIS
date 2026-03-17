---
name: aegis-builder
description: "Create, customize, and extend AEGIS — build custom skills, personas, modules, and domain-specific extensions. Use this skill whenever the user wants to create a new skill, add a persona, build a module, customize AEGIS for a specific domain, 'make a skill for', 'add a persona for', 'extend AEGIS', 'build a module', 'create a custom workflow', or any request to extend the AEGIS framework beyond its defaults. Also triggers on 'สร้าง skill ใหม่', 'เพิ่ม persona', 'ขยาย AEGIS', 'สร้างโมดูล'. This is the meta-builder — it knows how all AEGIS skills and personas work and can create new ones that integrate seamlessly."
---

# AEGIS Builder

> **"AEGIS is not a product. It's a platform. Build on it."**

The meta-builder for creating custom skills, personas, modules, and domain-specific extensions that integrate seamlessly into the AEGIS ecosystem.

## What You Can Build

| Extension Type | What It Is | Example |
|---------------|-----------|---------|
| **Custom Skill** | New capability with SKILL.md | `database-architect` for DB schema design |
| **Custom Persona** | New AI character with owned skills | `🏥 Healer` for healthcare compliance |
| **Domain Module** | Bundle of skills + personas for an industry | `aegis-fintech` module |
| **Workflow Template** | Pre-configured skill chain for common tasks | `launch-checklist` workflow |
| **Track Override** | Modified Quick/Standard/Enterprise track | Custom gates for regulated industries |

## Creating a Custom Skill

### Skill Template

Every AEGIS skill follows this structure:

```markdown
---
name: your-skill-name
description: "Comprehensive trigger description. Include: what the skill does,
when to trigger it, specific phrases (EN + TH), and edge cases. Make it
slightly 'pushy' — better to over-trigger than under-trigger."
---

# Skill Title

> **"One-line philosophy of this skill"**

## What This Skill Does
[Clear explanation of purpose and scope]

## When to Use vs When Not to Use
| Use This Skill When | Don't Use When |
|---------------------|---------------|
| [specific scenario] | [different skill handles it] |

## Process
### Step 1: [First action]
### Step 2: [Second action]
### Step 3: [Third action]

## Output Format
[Exact template the skill produces]

## Integration with Personas
| Persona | Role with This Skill |
|---------|---------------------|

## Integration with Other Skills
- **From [skill]**: [what feeds in]
- **To [skill]**: [what feeds out]
```

### Skill Quality Checklist

Before packaging, verify:

- [ ] **Name** — kebab-case, descriptive, unique within AEGIS
- [ ] **Description** — includes EN and TH trigger phrases, slightly pushy
- [ ] **Philosophy quote** — one-liner that captures the skill's soul
- [ ] **Use/Don't use table** — prevents overlap with existing skills
- [ ] **Output format** — concrete template, not vague "generate a report"
- [ ] **Persona integration** — which persona owns this skill?
- [ ] **Skill chain** — what feeds in, what feeds out?
- [ ] **SDLC phase** — where does this fit in PLAN/EXECUTE/VERIFY/FEEDBACK?
- [ ] **Thai triggers** — at least 3 Thai phrase triggers
- [ ] **Under 500 lines** — if longer, split into SKILL.md + references/

### Packaging

```bash
# Using skill-creator (if available)
cd /mnt/skills/examples/skill-creator
python -m scripts.package_skill /path/to/your-skill /output/dir

# Manual packaging (ZIP-based)
cd /path/to/your-skill
zip -r your-skill.skill your-skill/SKILL.md your-skill/scripts/ your-skill/references/
```

## Creating a Custom Persona

### Persona Template

```markdown
### [ICON] [Name] — The [Title]
**Role:** [One-line role description]
**Owns:** `skill-1`, `skill-2`
**Phase:** [PLAN / EXECUTE / VERIFY / FEEDBACK / domain-specific]

**Personality:** [2-3 sentences describing character, communication style,
and what makes this persona unique. Include what they care about most
and what they refuse to compromise on.]

**Communication style:**
- [Specific behavior 1]
- [Specific behavior 2]
- [Specific behavior 3]
- [Catchphrase or recurring pattern]
- Uses phrases like "[example 1]" / "[example 2]"

**When to invoke:**
- [Scenario 1]
- [Scenario 2]
- [Scenario 3]

**Invoke:** `[Name]` / `เรียก [Name]` / `[keyword]` / `[Thai keyword]`
```

### Persona Design Rules

1. **Distinct voice** — if you remove the name, can you still tell which persona is speaking?
2. **Clear boundaries** — persona MUST decline tasks outside their domain
3. **Owned skills** — every persona owns at least 1 skill (except conversational personas like Pixel)
4. **No overlap** — two personas should never own the same skill
5. **Handoff protocol** — persona knows who to hand off to next
6. **Bilingual** — supports both EN and TH invocation

### Adding a Persona to AEGIS

1. Write the persona definition (use template above)
2. Add to `ai-personas/SKILL.md` under the appropriate SDLC phase
3. Update the persona ↔ skill mapping table
4. Update the handoff flow chain
5. Add to party mode roster
6. Update README.md persona table

## Creating a Domain Module

A module is a bundle of skills + personas designed for a specific industry or use case.

### Module Structure

```
aegis-module-[domain]/
├── README.md              # Module overview, install guide
├── MANIFEST.yaml          # Module metadata
├── personas/
│   └── personas.md        # Domain-specific personas
├── skills/
│   ├── skill-1/
│   │   └── SKILL.md
│   ├── skill-2/
│   │   └── SKILL.md
│   └── skill-3/
│       └── SKILL.md
└── tracks/
    └── custom-track.md    # Modified AEGIS tracks for this domain
```

### MANIFEST.yaml

```yaml
name: aegis-fintech
version: 1.0.0
description: "AEGIS extension for fintech and digital banking"
author: "Aeternix"
requires:
  aegis: ">=4.0.0"
  skills:
    - security-audit      # depends on core AEGIS skill
    - code-review

provides:
  skills:
    - pci-compliance      # new skill
    - fraud-detection     # new skill
    - regulatory-report   # new skill
  personas:
    - name: Shield
      icon: "🏦"
      role: Compliance Officer
      owns: [pci-compliance, regulatory-report]
    - name: Sentinel
      icon: "🔍"
      role: Fraud Analyst
      owns: [fraud-detection]

tracks:
  enterprise:
    additional_gates:
      - pci-compliance-check
      - regulatory-review
```

### Example Modules

| Module | Domain | Skills Added | Personas Added |
|--------|--------|-------------|---------------|
| `aegis-fintech` | Banking, payments, EWA | pci-compliance, fraud-detection, regulatory-report | 🏦 Shield, 🔍 Sentinel |
| `aegis-healthtech` | Healthcare, HIPAA | hipaa-audit, phi-scanner, clinical-workflow | 🏥 Healer |
| `aegis-gamedev` | Game development | game-design-doc, play-test, balance-review | 🎮 Arcade |
| `aegis-saas` | SaaS platforms | tenant-isolation, usage-billing, onboarding-flow | 📊 Metric |
| `aegis-data` | Data engineering | pipeline-design, data-quality, schema-evolution | 📈 Flow |

### Module Installation

```bash
# Unpack module into skills directory
unzip aegis-fintech-v1.0.0.zip -d $SKILLS_DIR/../

# Module auto-registers:
# 1. Skills → $SKILLS_DIR/pci-compliance/, fraud-detection/, etc.
# 2. Personas → appended to ai-personas/SKILL.md
# 3. Tracks → merged into project-navigator track definitions
```

## Creating a Workflow Template

Pre-configured skill chains for common tasks:

```markdown
## Launch Readiness Workflow

### Prerequisites
- [ ] SPEC.md exists and is up to date
- [ ] Source code compiles without errors

### Automated Chain
1. `project-navigator` → assess current state
2. `code-standards` → validate all conventions
3. `code-review` → full 5-pass review
4. `adversarial-review` → challenge architecture decisions
5. `security-audit` → OWASP + dependency + secrets scan
6. `code-coverage` → verify thresholds met
7. `test-architect` → validate quality gates pass
8. `api-docs` → verify docs match implementation
9. `tech-debt-tracker` → debt score acceptable?
10. `project-navigator` → final readiness report

### Pass Criteria
- Zero 🔴 Critical findings across all skills
- Coverage ≥ 80% overall, ≥ 90% on auth/payment
- Debt score ≥ 70
- All API docs current (zero drift)
- Security audit: no critical/high CVEs
```

## Skill Marketplace Integration

Skills created with aegis-builder are marketplace-ready:

```yaml
# marketplace-metadata.yaml (auto-generated during build)
skill:
  name: your-skill
  version: 1.0.0
  author: "Your Name"
  category: verify          # plan / execute / verify / feedback / marketing / domain
  tags: [security, compliance, pci]
  requires_aegis: ">=4.0.0"
  depends_on: [security-audit]
  tested_on: [claude-code, claude-ai, cowork]
  language: [en, th]
  downloads: 0
  rating: null
```

## vs BMad Builder

| Feature | AEGIS Builder | BMad Builder |
|---------|--------------|-------------|
| Custom skills | ✅ Full template + checklist | ✅ Custom agents/workflows |
| Custom personas | ✅ With personality design rules | ❌ Agents only, no persona guidelines |
| Domain modules | ✅ MANIFEST.yaml with dependency resolution | ✅ Module system |
| Workflow templates | ✅ Pre-configured skill chains | ❌ Not formalized |
| Marketplace metadata | ✅ Auto-generated, ready for registry | ❌ No marketplace format |
| Bilingual support | ✅ EN + TH trigger requirement | ❌ No bilingual enforcement |
| Quality checklist | ✅ 10-point verification before packaging | ❌ No formal checklist |
| Track customization | ✅ Custom gates per domain/industry | ❌ Fixed tracks |
