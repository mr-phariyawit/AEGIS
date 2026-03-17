---
name: git-workflow
description: "Git strategy enforcer — branching models, PR templates, commit conventions, changelog generation, and pre-commit hooks. Use this skill whenever the user mentions git workflow, branching strategy, PR template, pull request template, commit message format, conventional commits, changelog, release notes, git hooks, pre-commit, 'set up git', 'branching model', trunk-based development, gitflow, 'merge strategy', or any request related to git process and conventions. Also triggers on 'จัดการ git', 'สร้าง PR template', 'git flow', 'release process'. This skill keeps team git hygiene consistent and automates repetitive git tasks."
---

# Git Workflow & Strategy Enforcer

Enforce consistent git practices: branching strategy, commit conventions, PR templates, changelog generation, and pre-commit hooks.

## Branching Strategies

### Strategy Selection

Ask the user about team size and release cadence to recommend the right strategy:

| Factor | Trunk-Based | GitHub Flow | GitFlow |
|--------|------------|-------------|---------|
| Team size | Any | Small-Medium | Medium-Large |
| Release cadence | Continuous | Frequent | Scheduled |
| Complexity | Low | Low-Medium | High |
| Best for | SaaS, microservices | Web apps, APIs | Mobile, enterprise |

### Trunk-Based Development (Recommended for most teams)

```
main ─────●────●────●────●────●────── (always deployable)
           \  /      \  /      \  /
            ──        ──        ──     (short-lived feature branches, <1 day)
```

Rules:
- `main` is always deployable
- Feature branches live max 1-2 days
- Use feature flags for incomplete work
- All changes go through PR, even small ones
- No long-lived branches

Branch naming: `{type}/{ticket-id}-{short-description}`
Examples: `feat/AET-123-user-auth`, `fix/AET-456-payment-timeout`, `chore/AET-789-update-deps`

### GitHub Flow

```
main ─────●────────●────────●──────
           \      /  \      /
            ●──●──    ●──●──        (feature branches, merged via PR)
```

Same as trunk-based but allows slightly longer feature branches (up to a week).

### GitFlow (when needed)

```
main ────────●──────────────────●──── (releases only)
              \                /
develop ──●────●──●──●──●────●────── (integration)
           \  /    \      /
            ──      ●──●──           (feature branches)
```

Use only when you need: parallel release maintenance, hotfix branches, or strict release gates.

## Commit Convention: Conventional Commits

Format:
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | When to use | Bumps |
|------|-------------|-------|
| `feat` | New feature | MINOR |
| `fix` | Bug fix | PATCH |
| `docs` | Documentation only | — |
| `style` | Formatting, no logic change | — |
| `refactor` | Code change, no feature/fix | — |
| `perf` | Performance improvement | PATCH |
| `test` | Adding/fixing tests | — |
| `chore` | Build, CI, tooling | — |
| `ci` | CI/CD changes | — |
| `revert` | Revert a previous commit | — |

### Scopes (project-specific)

Define scopes matching project structure:
```
auth, api, ui, db, config, deps, payment, user, admin
```

### Examples

```
feat(auth): implement JWT refresh token rotation

Add automatic token refresh when access token expires within 5 minutes.
Refresh tokens are single-use with 7-day expiry.

Closes AET-123

---

fix(payment): handle gateway timeout with retry

Gateway timeouts now retry once before failing.
Added exponential backoff with jitter.

Fixes AET-456

---

feat(api)!: change user endpoint response shape

BREAKING CHANGE: GET /api/users now returns paginated response
instead of flat array. All clients must update.
```

### Commit Message Validation

Generate a git hook that validates commit messages:

```bash
#!/bin/sh
# .git/hooks/commit-msg
commit_msg=$(cat "$1")
pattern="^(feat|fix|docs|style|refactor|perf|test|chore|ci|revert)(\([a-z0-9-]+\))?!?: .{1,72}"

if ! echo "$commit_msg" | grep -qE "$pattern"; then
  echo "❌ Invalid commit message format."
  echo "Expected: <type>(<scope>): <description>"
  echo "Example:  feat(auth): add JWT refresh token"
  echo ""
  echo "Types: feat, fix, docs, style, refactor, perf, test, chore, ci, revert"
  exit 1
fi
```

## PR Templates

### Standard PR Template

Generate `.github/pull_request_template.md`:

```markdown
## What

<!-- Brief description of changes -->

## Why

<!-- Why is this change needed? Link to ticket/issue -->

Closes #

## Type of Change

- [ ] feat: New feature
- [ ] fix: Bug fix  
- [ ] refactor: Code refactor (no feature/fix)
- [ ] docs: Documentation
- [ ] test: Tests
- [ ] chore: Build/CI/tooling

## Changes Made

<!-- List key changes -->

-
-
-

## Testing

- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing done

### Test Evidence

<!-- Screenshots, terminal output, or test results -->

## Security Checklist

- [ ] No hardcoded secrets
- [ ] Input validation on new endpoints
- [ ] Auth/authz checked for new routes
- [ ] Sensitive data not logged

## Deployment Notes

<!-- Any special deployment steps? DB migrations? Feature flags? -->

- [ ] No special deployment needed
- [ ] Requires migration: <!-- describe -->
- [ ] Feature flag: <!-- flag name -->

## Reviewer Notes

<!-- Anything specific you want reviewers to focus on? -->
```

## Changelog Generation

Auto-generate changelog from conventional commits:

```markdown
# Changelog

## [1.3.0] - 2026-03-17

### Features
- **auth:** implement JWT refresh token rotation (AET-123)
- **api:** add batch user import endpoint (AET-130)

### Bug Fixes
- **payment:** handle gateway timeout with retry (AET-456)
- **ui:** fix date picker timezone offset (AET-462)

### Performance
- **db:** optimize user search query with composite index (AET-470)

### Breaking Changes
- **api:** change user endpoint response shape — paginated response required
```

Script to generate:
```bash
# Generate changelog from git log
git log --pretty=format:"%s|%h|%an|%ad" --date=short v1.2.0..HEAD | \
  awk -F'|' '{
    if ($1 ~ /^feat/) print "### Features\n- " $1 " (" $2 ")"
    if ($1 ~ /^fix/) print "### Bug Fixes\n- " $1 " (" $2 ")"
    if ($1 ~ /^perf/) print "### Performance\n- " $1 " (" $2 ")"
  }'
```

## Pre-commit Hook Setup

Generate `.husky/pre-commit` (or `.pre-commit-config.yaml` for Python):

### Node.js (Husky + lint-staged)

```json
// package.json additions
{
  "scripts": {
    "prepare": "husky"
  },
  "lint-staged": {
    "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,md}": ["prettier --write"]
  }
}
```

### Python (pre-commit framework)

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.4.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
```

## Release Process

### Semantic Versioning

```
MAJOR.MINOR.PATCH

MAJOR: Breaking changes (feat! or BREAKING CHANGE footer)
MINOR: New features (feat)
PATCH: Bug fixes (fix, perf)
```

### Release Checklist

```markdown
## Release v[X.Y.Z] Checklist

- [ ] All PRs merged to main
- [ ] Tests passing on CI
- [ ] Coverage meets targets
- [ ] Security audit clean
- [ ] Changelog updated
- [ ] Version bumped in package.json/pyproject.toml
- [ ] Git tag created: `git tag -a v[X.Y.Z] -m "Release v[X.Y.Z]"`
- [ ] Release notes published
- [ ] Deployment triggered
- [ ] Smoke tests passed in production
- [ ] Team notified
```

## Integration with Other Skills

- **With `code-standards`**: Pre-commit hooks enforce standards before commit
- **With `code-review`**: PR template ensures reviewers have context
- **With `security-audit`**: Security checklist in PR template
- **With `code-coverage`**: Coverage check in CI before merge allowed
