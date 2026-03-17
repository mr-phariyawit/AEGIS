# Contributing to AEGIS

Thank you for your interest in contributing to AEGIS! Every contribution makes the framework stronger for everyone.

## Ways to Contribute

### 1. Create a Skill
Build a new skill and share it via the marketplace. See `aegis-builder` skill for templates and guidelines.

### 2. Create a Domain Module
Bundle skills + personas for a specific industry. See `aegis-builder` module creation guide.

### 3. Improve Existing Skills
Found a gap in `code-review` or `security-audit`? Submit a PR with improvements.

### 4. Report Issues
Found a bug or have a feature request? Open an issue on GitHub.

### 5. Translate
Help translate skill triggers and outputs to more languages.

## Development Setup

```bash
git clone https://github.com/aeternix/aegis.git
cd aegis
```

## Skill Contribution Guidelines

### Before You Start
1. Check existing skills — does this capability already exist?
2. Check marketplace — has someone already built this?
3. Open an issue to discuss your idea before building

### Quality Standards
- SKILL.md must have valid YAML frontmatter (name + description)
- Description must include EN + TH trigger phrases
- Must specify SDLC phase (PLAN/EXECUTE/VERIFY/FEEDBACK)
- Must specify persona integration (which persona owns it)
- Must include Use/Don't-use table
- Must include concrete output format template
- Under 500 lines (use references/ for large docs)

### PR Template
```markdown
## New Skill: [skill-name]

### What it does
[One paragraph description]

### SDLC Phase
[PLAN / EXECUTE / VERIFY / FEEDBACK / MARKETING]

### Persona
[Which persona owns this skill]

### Testing
- [ ] Tested with 3+ realistic prompts
- [ ] Triggers correctly from EN phrases
- [ ] Triggers correctly from TH phrases
- [ ] Does not overlap with existing skills
- [ ] SKILL.md passes quality checklist

### Comparison
[If similar capability exists in BMAD or other frameworks, explain how yours is different/better]
```

## Code of Conduct

Be respectful. Be constructive. Build things that help others build things.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
