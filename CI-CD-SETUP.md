# Branch Protection and CI/CD Setup

## Overview

This repository implements a comprehensive CI/CD pipeline with `pre-commit hooks` and `branch protection` to ensure **code quality** and **security**.

## CI/CD Pipeline

### Main Pipeline (`pipeline.yml`)

- **Pre-commit Checks**: Runs all configured pre-commit hooks
- **Multi-Python Testing**: Tests against Python 3.9, 3.10, 3.11, and 3.12
- **Security Scanning**: Uses safety and bandit for vulnerability detection
- **Build Validation**: Tests application startup and health endpoints
- **Coverage Reporting**: Generates and uploads test coverage

### PR Checks (`pr-checks.yml`)

- **PR Title Validation**: Enforces conventional commit format
- **PR Size Limits**: Prevents overly large PRs
- **Merge Conflict Detection**: Checks for conflicts before merge
- **Label Requirements**: Ensures proper categorization
- **Branch Freshness**: Warns if branch is behind main

## Setting Up Branch Protection

Steps to setup branch protection:

### 1. Push Your Changes

```bash
git add .
git commit -m "feat: implement comprehensive CI/CD pipeline"
git push origin main
```

### 2. Create Branch Protection Ruleset

Go to your repository on GitHub:

1. Navigate to **Settings** → **Code and automation** → **Rules**
2. Click **New ruleset** → **New branch ruleset**
3. Configure the following settings:

#### Basic Configuration

- **Ruleset Name**: `Main Branch Protection`
- **Enforcement status**: ✅ **Active**
- **Bypass list**: Leave empty (or add specific users/teams if needed)

#### Target branches

- Click **Add target** → **Include default branch**
- Or click **Add target** → **Include by name** → Enter `main`

#### Branch rules (enable these protections)

- ✅ **Restrict deletions** - Prevents branch deletion
- ✅ **Restrict force pushes** - Prevents rewriting history
- ✅ **Require a pull request before merging**
  - ✅ **Require approvals**: Set to `1`
  - ✅ **Dismiss stale pull request approvals when new commits are pushed**
  - ✅ **Require review from code owners**
- ✅ **Require status checks to pass**
  - ✅ **Require branches to be up to date before merging**
  - **Required status checks** (add these as they appear in your Actions):
    - `Pre-commit Checks`
    - `Run Tests (3.11)` or `test` (check your workflow job names)
    - `Security Scan`
    - `Build and Validate`
    - `Check PR Title`
- ✅ **Require signed commits** (optional but recommended)
- ✅ **Block force pushes** (should be enabled by default)

#### Advanced Options (Optional)

- ✅ **Require linear history** - Prevents merge commits
- ✅ **Require deployments to succeed** - If you have deployment environments
- ✅ **Lock branch** - For extra protection (makes branch read-only)

> **⚠️ Important**: The required status checks will only appear in the dropdown **after** the code is pushed and the GitHub Actions workflows have run at least once. If the status checks listed, push the changes first, then return to configure the ruleset.

1. Click **Create** to save the ruleset

### 3. Optional: Create CODEOWNERS file

Add reviewers who must approve changes to specific files:

```shell
# Global owners
* @your-team

# Specific file types
*.yml @devops-team
*.py @python-team
*.md @docs-team
```

## Pre-commit Setup

### Local Installation

```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install

# Run against all files
pre-commit run --all-files
```

### Available Hooks

- **YAML validation**: Checks YAML syntax
- **File formatting**: Fixes trailing whitespace, EOF
- **Security**: Detects private keys, large files
- **Code quality**: Ruff linting and formatting
- **Terraform**: Format and validate
- **Shell scripts**: Shellcheck validation

## Repository Labels

Create these labels in your repository for proper PR categorization:

### Type Labels

- `type:bug` - Bug fixes
- `type:feature` - New features
- `type:docs` - Documentation changes
- `type:chore` - Maintenance tasks

### Priority Labels

- `priority:low` - Low priority
- `priority:medium` - Medium priority
- `priority:high` - High priority
- `priority:critical` - Critical issues

### Status Labels

- `status:in-progress` - Work in progress
- `status:ready-for-review` - Ready for review
- `status:blocked` - Blocked by dependencies

## Troubleshooting

### CI/CD Issues

1. **Pre-commit failures**: Run `pre-commit run --all-files` locally first
2. **Test failures**: Ensure all dependencies are in `requirements.txt`
3. **Security scan failures**: Review and fix flagged vulnerabilities

### Branch Protection/Ruleset Issues

1. **Can't create rulesets**: Ensure you have admin access to the repository
2. **Status checks not found**: Push commits to trigger workflows first, then add them as required checks
3. **Ruleset not enforcing**: Check that Enforcement status is set to **Active**
4. **Required checks failing**: Review workflow logs in Actions tab
5. **Can't bypass ruleset**: Add your username/team to the bypass list if needed for emergencies

## Development Workflow

1. **Create feature branch**: `git checkout -b feature/your-feature`
2. **Make changes**: Edit code and add tests
3. **Run pre-commit**: `pre-commit run --all-files`
4. **Commit changes**: Use conventional commit format
5. **Push branch**: `git push origin feature/your-feature`
6. **Create PR**: Use descriptive title and labels
7. **Address feedback**: Make changes if requested
8. **Merge**: After all checks pass and approval received
