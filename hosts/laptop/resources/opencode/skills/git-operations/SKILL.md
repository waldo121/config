---
name: git-operations
description: Git operations skill with strict commit rules - max 1 task per commit, conventional commit format (<type>: headline + bullet details). Use ONLY when user asks to commit, create commit, git commit, make commit, create branch, git branch, push, git push, or any git operation.
---

# Git Operations

This skill enforces strict git commit standards and workflow rules.

## Commit Rules

### 1. Single Task Per Commit
- Each commit must represent exactly ONE logical task/change
- Do not combine unrelated changes in a single commit
- If multiple tasks exist, create separate commits for each

### 2. Commit Message Format
```
<type>: <headline>

- <detail 1>
- <detail 2>
- <detail 3>
```

### 3. Commit Types
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring (no behavior change)
- `docs`: Documentation changes
- `style`: Formatting, whitespace (no logic change)
- `test`: Adding/updating tests
- `chore`: Maintenance, build, dependencies
- `perf`: Performance improvement
- `ci`: CI/CD changes

### 4. Headline Rules
- Max 72 characters
- Imperative mood ("add" not "adds" or "added")
- No period at end
- Lowercase first letter after type

### 5. Detail Rules (Bullet Points)
- Explain WHAT was changed (not WHY - that belongs in PR/issue)
- One bullet per logical detail
- Max 3-5 bullets
- No issue/PR references (those belong in PR description)

## Examples

### Good Commit
```
feat: add user authentication endpoint

- Adds POST /api/auth/login endpoint with JWT tokens
- Implements password hashing with bcrypt
- Adds rate limiting for login attempts
```

### Bad Commits (Violations)
```
feat: add auth and fix login bug and update docs
```
→ Multiple tasks in one commit

```
feat: Added user authentication endpoint.
```
→ Past tense, period at end, no bullet points

```
feat: add user authentication endpoint

- wrote the login function
- used bcrypt for passwords
- this was hard to implement
```
→ Describes HOW not WHAT/WHY

## Branch Naming
- `feature/<short-description>` - New features
- `fix/<issue-number>-<short-description>` - Bug fixes
- `refactor/<short-description>` - Refactoring
- `docs/<short-description>` - Documentation
- `chore/<short-description>` - Maintenance

## Workflow

### Before Committing
1. Stage only files related to the single task
2. Run lint/typecheck if available
3. Verify tests pass

### Creating Commits
```bash
git add <specific-files>
git commit -m "type: headline

- detail 1
- detail 2"
```

### Commit Verification
- Run `git log --oneline -5` to verify format
- Check each commit follows single-task rule
- Ensure conventional format compliance
```
