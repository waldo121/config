---
name: issue-workflow
description: Automated workflow for working on issues - creates branch, runs build agent, code review, documentation pass, and commits changes. Use when starting work on an issue.
---

# GitHub Issue Workflow

This skill orchestrates a complete workflow for addressing GitHub issues with quality gates.

## Workflow Steps

### 1. Branch Creation
- Create a new branch named `issue/<issue-number>-<short-description>`
- Branch from the default branch (main/master)

### 2. Build Agent Execution
- Use the `build` agent to implement the issue requirements
- The build agent should make all necessary code changes

### 3. Code Review Loop
- Invoke `@code-reviewer` agent to review changes
- Review focuses on: bugs, security, best practices, best practices, readability, error handling
- If issues found, the build agent fixes them and review repeats
- Continue until code-reviewer approves (no blocking issues)

### 4. Documentation Pass
- Invoke `@documentation` agent to review and update documentation
- Ensure README, API docs, and inline comments are updated
- Documentation agent makes edits directly

### 5. Commit Creation
- Create cohesive commit(s) with descriptive messages
- Follow conventional commit format if project uses it
- Each commit should represent a logical unit of change

## Usage

When a user says "work on issue #123" or "implement GitHub issue #456", trigger this workflow.

## Agent Invocations

Use the `task` tool with subagent types:
- `code-reviewer` for code review step
- `documentation` for documentation pass step
- `build` (built-in) for implementation step

## Example Prompt for Code Reviewer

```
Review the changes made for issue #<number>. Focus on:
- Potential bugs and edge cases
- Security vulnerabilities
- Best practices adherence
- Code readability and maintainability
- Error handling and input validation

List any issues found. If none, approve the changes.
```

## Example Prompt for Documentation

```
Document the changes made for issue #<number>. Update:
- README files if new features/configuration added
- API documentation for any public interfaces
- Inline comments where intent is non-obvious
- CHANGELOG if applicable

Make edits directly to the codebase.
```