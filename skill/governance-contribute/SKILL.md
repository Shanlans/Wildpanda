---
name: governance-contribute
description: Contribute governance framework improvements from the current consuming project back to the upstream Wildpanda repo via pull request. Use when the user has improved a template-owned spec and wants to share it upstream.
---

# Governance Contribute

Contribute governance improvements from a consuming project back to the upstream Wildpanda repo via pull request.

## Prerequisites

### GitHub CLI (`gh`)
- **Required**: yes
- **Verify**: `gh auth status`
- **Install**:
  - Windows: `winget install GitHub.cli`
  - Linux: `sudo apt install gh` or `brew install gh`
  - macOS: `brew install gh`
- **Post-install**: `gh auth login`

### Pre-Check (Step 0, mandatory before any contribute operation)
1. Detect `gh` on PATH or known install locations.
   - Not found → display install command for detected OS, ask user to install, **stop**.
2. Run `gh auth status`.
   - Not authenticated → display `gh auth login`, ask user to authenticate, **stop**.
3. Read `project_profile.yaml` → `governance` section.
   - `upstream_repo` must be defined. If missing → prompt and write, then continue.
   - `upstream_commit` should be defined. If missing → warn that contribution will be based on unknown baseline.

## Trigger
- **Manual only**: user invokes the skill when they want to contribute changes back.
- **Keyword triggers** (any of these phrases activates this skill):
  - "agent 更新"
  - "agent 变更发布"
  - "贡献回上游"
  - "contribute back"
  - "push changes upstream"

## Contribution Flow

### Step 1: Identify Changed Template-Owned Files
- Read local `master_spec/initial_spec/governance_template_boundary.md` §3.1 → template-owned file list.
- For each file, fetch the remote version from upstream at the `upstream_commit` recorded in `project_profile.yaml`.
- Diff local vs remote → build list of files with local modifications.

### Step 2: Present Changes
- Display changed files with diff preview.
- Ask user to select which files to contribute.
- If no template-owned files are changed → "No governance changes to contribute" → **end**.

### Step 3: User Confirmation
- Show selected files and confirm:
  - "Contribute these N files to <upstream_repo> via PR?"
  - "Based on upstream commit: <upstream_commit>"

### Step 4: Fork Upstream
- Run `gh repo fork <upstream_repo> --clone=false` (if not already forked).
- Detect fork name from `gh api user/repos` or `gh repo list --fork`.

### Step 5: Clone Fork to Temp Directory
- `git clone <fork_url> /tmp/wildpanda-contrib-<timestamp>/`
- `cd /tmp/wildpanda-contrib-<timestamp>/`
- `git remote add upstream https://github.com/<upstream_repo>.git`
- `git fetch upstream <upstream_branch>`
- `git checkout -b contrib/<project_id>-<short_summary>` from `upstream/<upstream_branch>`

### Step 6: Copy Files
- For each selected file:
  - Copy from consuming project path → temp directory at the same relative path.
  - Ensure directory structure exists.

### Step 7: Prepare CHANGELOG Entry
- Draft a CHANGELOG entry under `## [Unreleased]`:
  ```
  ### Contributed from <project_id>
  - <summary of changes per file>
  ```
- Display draft to user for editing.
- Append to `CHANGELOG.md` in temp directory.

### Step 8: Bump VERSION
- Read current VERSION from temp directory.
- Suggest patch bump (e.g., `1.1.0` → `1.1.1`).
- User can override to minor or major.
- Write new version to `VERSION`.

### Step 9: Commit
- Read contributor identity from consuming project:
  - `git config user.name` → contributor name
  - `git config user.email` → contributor email
- Commit message:
  ```
  <short_summary>

  Contributed from <project_id> (based on <upstream_commit>).

  Co-Authored-By: <contributor_name> <contributor_email>
  ```

### Step 10: Push
- `git push origin contrib/<project_id>-<short_summary>`

### Step 11: Create Pull Request
- `gh pr create` targeting `<upstream_repo>:<upstream_branch>` with:
  - **Title**: `[Contrib] <short_summary>`
  - **Body**:
    ```
    ## Source
    - Project: <project_id>
    - Based on: <upstream_commit>

    ## Changes
    <file list with one-line summaries>

    ## Changelog Entry
    <drafted changelog text>

    ## Contributor
    <contributor_name> (<contributor_email>)
    ```

### Step 12: Output
- Display PR URL.
- Remind: "Maintainer will review and merge on GitHub."

### Step 13: Cleanup
- Remove temp directory `/tmp/wildpanda-contrib-<timestamp>/`.
- If cleanup fails, warn user with path for manual removal.

## README Check (Mandatory)
- Before creating the PR, check whether the contributed changes affect any capability described in `README.md` (e.g., new skill, new feature, changed workflow).
- If yes: update `README.md` in the same PR to reflect the change.
- If no: no action needed.

## Important Notes
- Only template-owned files (§3.1) can be contributed. Instance-owned, runtime, and hybrid files are excluded.
- The contribution is always a PR. It is never merged automatically.
- The PR targets the upstream repo, not the fork's master.
- Contributor signature (Co-Authored-By) is mandatory in every commit.
