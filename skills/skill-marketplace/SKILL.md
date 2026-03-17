---
name: skill-marketplace
description: "Discover, share, install, and rate community-built AEGIS skills and modules. Use this skill whenever the user mentions marketplace, 'find a skill for', 'is there a skill for', 'share my skill', 'publish skill', 'skill registry', 'community skills', 'browse skills', 'install module', or any request to discover, distribute, or manage AEGIS extensions. Also triggers on 'ค้นหา skill', 'มี skill สำหรับ', 'แชร์ skill', 'ตลาด skill', 'หา module'. This skill is the package manager and app store for AEGIS — like npm but for AI development skills."
---

# Skill Marketplace

> **"One team's best practice is another team's superpower. Share it."**

The community registry for discovering, sharing, installing, and rating AEGIS skills and modules. Think npm/pip but for AI development workflows.

## Marketplace Architecture

### Registry Structure

```
aegis-marketplace/
├── registry/
│   ├── index.json           # Master catalog of all published skills
│   ├── categories/
│   │   ├── plan.json        # Skills for PLAN phase
│   │   ├── execute.json     # Skills for EXECUTE phase
│   │   ├── verify.json      # Skills for VERIFY phase
│   │   ├── feedback.json    # Skills for FEEDBACK phase
│   │   ├── marketing.json   # Marketing pipeline skills
│   │   └── domain/          # Domain-specific modules
│   │       ├── fintech.json
│   │       ├── healthtech.json
│   │       └── gamedev.json
│   └── authors/
│       └── [author-id].json # Per-author catalog
├── packages/
│   └── [skill-name]/
│       ├── latest.skill     # Latest version
│       └── versions/
│           ├── 1.0.0.skill
│           └── 1.1.0.skill
└── reviews/
    └── [skill-name].json    # Community ratings and reviews
```

### Registry Entry (index.json)

```json
{
  "skills": [
    {
      "name": "pci-compliance",
      "version": "1.2.0",
      "author": "aeternix",
      "description": "PCI-DSS compliance checker for payment systems",
      "category": "verify",
      "tags": ["security", "compliance", "pci", "fintech"],
      "phase": "VERIFY",
      "persona_compatible": ["Havoc", "Vigil"],
      "depends_on": ["security-audit"],
      "requires_aegis": ">=4.0.0",
      "downloads": 342,
      "rating": 4.7,
      "reviews": 28,
      "languages": ["en", "th"],
      "size_kb": 12,
      "published": "2026-03-10",
      "updated": "2026-03-15",
      "verified": true
    }
  ]
}
```

## User Workflows

### 1. Browse & Discover

```markdown
## Browse skills

### By SDLC phase
> "Show me VERIFY phase skills"
→ Lists all skills tagged for VERIFY: security scanners, test tools, review extensions

### By domain
> "Are there fintech skills?"
→ Lists aegis-fintech module with pci-compliance, fraud-detection, regulatory-report

### By problem
> "I need something for database schema design"
→ Searches tags and descriptions, recommends best matches

### By popularity
> "What are the most popular community skills?"
→ Sorted by downloads + rating
```

**Discovery output:**

```markdown
## Marketplace Results: "security"

| # | Skill | Author | Rating | Downloads | Phase |
|---|-------|--------|--------|-----------|-------|
| 1 | pci-compliance | @aeternix | ⭐ 4.7 (28) | 342 | VERIFY |
| 2 | gdpr-scanner | @eudev | ⭐ 4.5 (15) | 189 | VERIFY |
| 3 | soc2-checklist | @cloudteam | ⭐ 4.3 (9) | 97 | VERIFY |
| 4 | pentest-guide | @secops | ⭐ 4.8 (42) | 567 | VERIFY |
| 5 | container-security | @devops-th | ⭐ 4.1 (6) | 45 | VERIFY |

Install: "install pci-compliance" or "ติดตั้ง pci-compliance"
```

### 2. Install Skills

```markdown
## Install a skill

> "install pci-compliance"

### Process:
1. Download pci-compliance.skill from registry
2. Validate AEGIS version compatibility (requires >=4.0.0 ✅)
3. Check dependencies (needs security-audit ✅ — already installed)
4. Unpack to skills directory
5. Update project-navigator skill registry
6. Assign to recommended persona (Havoc)

### Output:
✅ Installed pci-compliance v1.2.0
   Author: @aeternix (verified)
   Phase: VERIFY
   Persona: Assigned to 🔴 Havoc
   Triggers: "PCI check", "PCI compliance", "เช็ค PCI"
   
   Try: "Havoc, run PCI compliance check on the payment module"
```

### 3. Publish Skills

```markdown
## Publish a skill

> "publish my-custom-skill to marketplace"

### Pre-publish checklist (auto-verified):
- [ ] SKILL.md has valid YAML frontmatter (name + description)
- [ ] Description includes trigger phrases (EN + TH)
- [ ] Skill has been tested (at least 1 eval run)
- [ ] No hardcoded secrets or API keys in SKILL.md
- [ ] Version follows semver (1.0.0)
- [ ] Author info provided
- [ ] Category assigned (plan/execute/verify/feedback/marketing/domain)
- [ ] README with usage examples

### Publishing:
1. Run quality check: `aegis-builder validate my-custom-skill/`
2. Package: `aegis-builder package my-custom-skill/ --marketplace`
3. Generate marketplace metadata (auto)
4. Submit to registry

### Output:
✅ Published my-custom-skill v1.0.0 to AEGIS Marketplace
   Category: verify
   Tags: [custom, review]
   URL: aegis-marketplace/packages/my-custom-skill/
   
   Share this with your team or community!
```

### 4. Rate & Review

```markdown
## Rate a skill

> "rate pci-compliance 5 stars — caught 3 real PCI issues in our codebase"

### Review format:
{
  "skill": "pci-compliance",
  "version": "1.2.0",
  "rating": 5,
  "review": "Caught 3 real PCI issues in our payment module that manual review missed.",
  "author": "@jiab",
  "date": "2026-03-17",
  "aegis_version": "4.0.0",
  "verified_user": true
}
```

### 5. Update Skills

```markdown
## Update installed skills

> "update all skills" / "อัปเดต skill ทั้งหมด"

### Output:
Checking 15 installed skills...

| Skill | Current | Latest | Status |
|-------|---------|--------|--------|
| code-review | 1.0.0 | 1.0.0 | ✅ Up to date |
| pci-compliance | 1.1.0 | 1.2.0 | ⬆️ Update available |
| security-audit | 1.0.0 | 1.0.0 | ✅ Up to date |

Update pci-compliance? (y/n)
```

## Curated Collections

Pre-built bundles for common setups:

| Collection | Skills Included | For |
|-----------|----------------|-----|
| **AEGIS Core** | All 16 default skills | Everyone |
| **Startup Pack** | Core + Quick track only | Solo devs, MVPs |
| **Enterprise Pack** | Core + test-architect + all verify skills | Large teams |
| **Fintech Pack** | Core + pci-compliance + fraud-detection + regulatory | Financial products |
| **Thai Market Pack** | Core + pdpa-compliance + promptpay-integration | Thai market products |
| **DevOps Pack** | Core + container-security + infra-as-code + monitoring | Platform teams |

## Marketplace Governance

### Verified Authors
- Published ≥ 3 skills with ≥ 4.0 average rating
- Badge: ✓ Verified on all their skills
- Priority placement in search results

### Quality Tiers
| Tier | Criteria | Badge |
|------|----------|-------|
| 🥇 Gold | ≥ 4.5 rating, ≥ 100 downloads, verified author | Featured |
| 🥈 Silver | ≥ 4.0 rating, ≥ 50 downloads | Recommended |
| 🥉 Bronze | ≥ 3.5 rating, ≥ 10 downloads | Listed |
| ⬜ New | < 10 downloads | New |

### Automated Quality Checks
- SKILL.md validation (frontmatter, structure)
- No hardcoded secrets scan
- Dependency resolution check
- Trigger phrase uniqueness (don't conflict with existing skills)
- Size limit: < 500KB per skill, < 5MB per module

## vs BMAD Module System

| Feature | AEGIS Marketplace | BMAD Modules |
|---------|------------------|-------------|
| Discovery | ✅ Search by phase, domain, problem, popularity | ❌ Manual — read GitHub repos |
| Installation | ✅ One-command install with dependency check | ✅ npx bmad-method install |
| Rating system | ✅ Stars + reviews + download count | ❌ GitHub stars only |
| Curated collections | ✅ Pre-built bundles per use case | ❌ Not available |
| Quality tiers | ✅ Gold/Silver/Bronze with auto-verification | ❌ No quality tiers |
| Publish workflow | ✅ validate → package → submit with auto-checks | ❌ Submit PR to repo |
| Dependency resolution | ✅ Auto-check AEGIS version + skill dependencies | ❌ Manual check |
| Update management | ✅ Check and update installed skills | ❌ Re-run installer |
| Domain bundles | ✅ Fintech, healthtech, gamedev, Thai market | Partial — Game Dev module only |
| Author verification | ✅ Verified author program | ❌ Not available |
