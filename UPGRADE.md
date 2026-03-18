# AEGIS Upgrade Guide

## How Upgrading Works

AEGIS uses a **safe upgrade pipeline** that protects your customizations:

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Detect   │───▶│ Backup   │───▶│ Save     │───▶│ Install  │───▶│ Restore  │
│ Version  │    │ Current  │    │ Customs  │    │ New      │    │ Customs  │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

1. **Detect** — reads `.aegis-version` to find current version
2. **Backup** — copies all skills, agents, commands to `.aegis-backups/[timestamp]/`
3. **Save customs** — detects modified core skills + user-created skills
4. **Install** — overwrites core skills with new versions
5. **Restore** — puts back user-created skills, saves modified diffs for manual merge

## Quick Upgrade

```bash
cd AEGIS
git pull origin main        # Get latest
./install.sh                # Auto-detects and upgrades
```

That's it. The installer handles everything.

## Installer Commands

| Command | What It Does |
|---------|-------------|
| `./install.sh` | Install or upgrade (auto-detects) |
| `./install.sh --check` | Show installed vs available version |
| `./install.sh --diff` | Preview what would change (dry run) |
| `./install.sh --backup` | Backup current installation only |
| `./install.sh --restore` | List available backups |
| `./install.sh --force` | Reinstall even if same version |
| `./install.sh /custom/path` | Install to custom directory |

## What Happens to Your Customizations

### User-Created Skills (safe)

If you created your own skills (e.g., `skills/my-custom-skill/`), they are:
- Detected automatically (any skill not in the core list)
- Backed up before upgrade
- Restored after upgrade, untouched

### Modified Core Skills (preserved with merge note)

If you edited a core skill like `code-review/SKILL.md`, the installer:
1. Backs up your version
2. Installs the new version
3. Saves your version as `SKILL.md.user-backup` alongside the new file
4. Tells you to merge manually:

```
~ code-review: your changes → SKILL.md.user-backup (merge manually)
```

To merge:
```bash
cd skills/code-review/
diff SKILL.md SKILL.md.user-backup     # See what you changed
# Manually apply your changes to the new SKILL.md
rm SKILL.md.user-backup                 # Clean up after merge
```

### Custom Agent Definitions (backed up)

If you modified `.claude/agents/sage.md`, the installer:
1. Saves your version as `sage.md.bak`
2. Installs the new version
3. You can compare and merge:

```bash
diff .claude/agents/sage.md .claude/agents/sage.md.bak
```

## Version History & Migration

### From v1.0–v4.x → v5.2 (major upgrade)

**New skills added:**
- v2.0: `project-navigator`, `adversarial-review`
- v3.0: `ai-personas` (8 personas + party mode)
- v4.0: `sprint-tracker`, `retrospective`, `course-correction` + Pixel persona
- v5.0: `test-architect`, `aegis-builder`, `skill-marketplace`
- v5.1: `super-spec` (BRD+SRS+UX+PBI engine)
- v5.2: `aegis-orchestrator` + 8 subagent definitions + 3 commands
- v5.3: `bug-lifecycle` (7-stage debug/reproduce/fix/retest/prevent)
- v5.4: Heartbeat progress system + `aegis-watch.sh` + `/aegis-status` command

**Breaking changes:** None. All upgrades are additive.

**Action needed:** None for core skills. If you created custom personas in `ai-personas/SKILL.md`, compare your version with the new one.

### From legacy (no version file) → v5.2

The installer detects "legacy" installs (has SKILL.md files but no `.aegis-version`):
- Full backup created automatically
- All customizations detected and preserved
- `.aegis-version` file created for future upgrades

### From v5.x → v5.2 (minor upgrade)

Smooth upgrade — only new files added, existing skills updated in-place.

## Backup & Restore

### Backup Location

```
skills/
├── .aegis-backups/
│   ├── 20260317_091100/       # Timestamp-named backup
│   │   ├── skills/            # All skills at time of backup
│   │   ├── agents/            # Agent definitions
│   │   ├── commands/          # Command files
│   │   └── .aegis-version     # Version at time of backup
│   └── 20260318_143000/       # Another backup
└── .aegis-version             # Current version
```

### Manual Restore

```bash
# List backups
./install.sh --restore

# Restore a specific backup manually
cp -r skills/.aegis-backups/20260317_091100/skills/* skills/
```

### Rollback to Previous Version

```bash
# 1. Check what backups exist
./install.sh --restore

# 2. Restore the backup
cp -r skills/.aegis-backups/[timestamp]/skills/* skills/
cp skills/.aegis-backups/[timestamp]/.aegis-version skills/.aegis-version

# 3. Verify
./install.sh --check
```

## CI/CD Integration

For teams that deploy AEGIS as part of project scaffolding:

```yaml
# GitHub Action example
- name: Install AEGIS
  run: |
    git clone https://github.com/mr-phariyawit/AEGIS.git /tmp/aegis
    /tmp/aegis/install.sh ${{ github.workspace }}/.claude/skills

# Or in Dockerfile
RUN git clone https://github.com/mr-phariyawit/AEGIS.git /opt/aegis \
    && /opt/aegis/install.sh /app/.claude/skills
```

## Troubleshooting

### "Already on vX.Y.Z" but I want to reinstall

```bash
./install.sh --force
```

### Skills not triggering after upgrade

1. Check installation: `./install.sh --check`
2. Verify files exist: `ls skills/*/SKILL.md | wc -l` (should be 18)
3. Restart Claude Code / reload IDE
4. Try: `"Navi, what should I do next?"` to test

### Lost my customizations

1. Check backups: `./install.sh --restore`
2. Look for `.user-backup` files: `find skills/ -name "*.user-backup"`
3. Look for `.bak` files: `find .claude/ -name "*.bak"`

### Want to start completely fresh

```bash
rm -rf skills/       # Remove all skills
rm -rf .claude/      # Remove agents and commands
./install.sh         # Fresh install
```
