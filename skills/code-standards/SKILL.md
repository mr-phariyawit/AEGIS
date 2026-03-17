---
name: code-standards
description: "Enforce and generate coding standards for TypeScript, Python, React, and Node.js projects. Use this skill whenever the user mentions coding standards, linting rules, code style, naming conventions, project structure validation, eslint config, prettier config, ruff config, code formatting, 'set up linting', 'enforce standards', 'coding guidelines', 'code conventions', or any request related to establishing, reviewing, or enforcing code quality rules. Also triggers on Thai phrases like 'มาตรฐานโค้ด', 'ตั้งค่า lint', 'กฎการเขียนโค้ด'. This skill bridges the gap between Markdown-defined standards and automated enforcement — define rules in natural language, generate tool configs automatically."
---

# Code Standards Enforcer

Enforce coding standards across TypeScript, Python, React, and Node.js projects. Standards are defined in Markdown (source of truth) and translated into enforceable tool configurations.

## Philosophy

> "Standards defined in Markdown, enforced by tooling, validated by AI."

Teams waste hours debating style in PRs. This skill eliminates that by:
1. Defining standards in a human-readable `STANDARDS.md`
2. Auto-generating tool configs (ESLint, Prettier, Ruff, etc.)
3. Validating code against standards with actionable fix suggestions

## Capabilities

### 1. Generate Standards Document

When the user wants to establish coding standards, generate a comprehensive `STANDARDS.md`:

```markdown
# [Project Name] Coding Standards

## General Principles
- Readability over cleverness
- Explicit over implicit
- Consistency across the codebase

## TypeScript / JavaScript
### Naming Conventions
- **Variables/Functions**: camelCase
- **Classes/Types/Interfaces**: PascalCase (prefix interfaces with `I` only if team convention)
- **Constants**: UPPER_SNAKE_CASE
- **Files**: kebab-case for modules, PascalCase for components
- **Boolean variables**: prefix with is/has/can/should

### Import Order
1. Node built-ins (`fs`, `path`)
2. External packages (`react`, `express`)
3. Internal aliases (`@/lib`, `@/components`)
4. Relative imports (`./utils`, `../types`)
5. Type-only imports last

### Function Rules
- Max 30 lines per function (suggest extraction if exceeded)
- Max 3 parameters (use options object for more)
- Always type return values explicitly
- Prefer arrow functions for callbacks, named functions for exports

### Error Handling
- Never catch and swallow errors silently
- Use typed error classes, not string throws
- Always handle Promise rejections

## Python
### Style
- Follow PEP 8 with Ruff enforcement
- Max line length: 88 (Black default)
- Use type hints for all function signatures
- Docstrings: Google style

### Naming
- **Variables/Functions**: snake_case
- **Classes**: PascalCase
- **Constants**: UPPER_SNAKE_CASE
- **Private**: prefix with single underscore

## React / Next.js
### Component Rules
- Functional components only (no class components)
- One component per file
- Props interface defined above component
- Use named exports (not default) for better refactoring

### Hooks
- Custom hooks in `hooks/` directory with `use` prefix
- Never call hooks conditionally
- Extract complex logic into custom hooks when >10 lines

## Project Structure
### Enforce directory conventions
- `src/` — source code root
- `src/components/` — UI components
- `src/hooks/` — custom React hooks
- `src/lib/` — shared utilities
- `src/types/` — TypeScript type definitions
- `src/services/` — API/business logic
- `tests/` — mirrors `src/` structure
```

Adapt this template based on the team's preferences. Ask the user which rules to customize.

### 2. Generate Tool Configurations

From a `STANDARDS.md`, generate matching configs:

#### ESLint (.eslintrc.json)
```bash
# Read STANDARDS.md and generate ESLint config
cat STANDARDS.md  # Parse the rules
# Generate .eslintrc.json matching the defined standards
```

Key ESLint rules to map:
- Naming → `@typescript-eslint/naming-convention`
- Import order → `import/order` with pathGroups
- Function length → `max-lines-per-function`
- Parameter count → `max-params`
- No silent catch → `no-empty` in catch blocks
- Explicit return types → `@typescript-eslint/explicit-function-return-type`

#### Prettier (.prettierrc)
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "always"
}
```

#### Ruff (ruff.toml) for Python
```toml
[lint]
select = ["E", "F", "W", "I", "N", "UP", "B", "A", "C4", "SIM", "TCH"]
ignore = ["E501"]  # Line length handled by formatter

[lint.isort]
known-first-party = ["app", "core", "services"]

[format]
quote-style = "double"
indent-style = "space"
line-ending = "auto"
```

#### TypeScript (tsconfig.json standards)
```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true
  }
}
```

### 3. Validate Code Against Standards

When given code to validate, check against the standards document:

**Output format — Standards Validation Report:**

```markdown
# Standards Validation Report
**File:** `src/components/UserProfile.tsx`
**Standards Version:** v1.2

## Summary
- ✅ Passed: 12 rules
- ⚠️ Warnings: 3
- ❌ Violations: 2

## Violations

### ❌ [NAMING-001] Variable naming convention
**Line 15:** `const UserData = fetchUser()`
**Rule:** Variables must use camelCase
**Fix:** `const userData = fetchUser()`

### ❌ [FUNC-002] Function exceeds max lines
**Line 32-78:** `processUserData()` is 46 lines (max: 30)
**Fix:** Extract validation logic into `validateUserInput()` and data mapping into `mapUserResponse()`

## Warnings

### ⚠️ [IMPORT-001] Import order violation
**Line 1-8:** Relative imports before external packages
**Fix:** Reorder imports: node built-ins → external → internal → relative

## Auto-fix Available
Run: `eslint --fix src/components/UserProfile.tsx`
```

### 4. Bulk Project Scan

Scan an entire project directory and produce a summary:

```markdown
# Project Standards Compliance Report
**Scanned:** 142 files | **Time:** 3.2s

## Overall Score: 87/100

## By Category
| Category | Pass Rate | Files Affected |
|----------|-----------|----------------|
| Naming   | 94%       | 8 files        |
| Imports  | 82%       | 24 files       |
| Functions| 91%       | 12 files       |
| Types    | 78%       | 31 files       |

## Top 5 Most Violated Rules
1. IMPORT-001: Import order (24 files)
2. TYPE-003: Missing explicit return type (18 files)
3. FUNC-002: Function too long (12 files)
4. NAME-004: File naming convention (8 files)
5. ERR-001: Silent error catch (5 files)

## Quick Wins (auto-fixable)
- 67% of violations are auto-fixable via `eslint --fix` and `prettier --write`
```

## Workflow Integration

This skill is designed to chain with other skills:
- **Before `code-review`**: Run standards check first, so reviewers focus on logic not style
- **With `spec-kit`**: Standards doc becomes part of the project spec
- **With `git-workflow`**: Pre-commit hooks enforce standards before push

## Customization

Always ask the user:
1. Which languages/frameworks does the project use?
2. Any existing standards or configs to extend?
3. Strict mode (block on violations) or advisory mode (warn only)?
4. Team size — smaller teams can be more opinionated

Generate configs that match their answers, not generic defaults.
