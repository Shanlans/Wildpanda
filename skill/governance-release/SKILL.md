---
name: governance-release
description: Prepare a versioned release PR for the Wildpanda governance framework. Use when the maintainer wants to package merged contributions into a new tagged version. The skill creates a PR — the maintainer merges and tags on GitHub.
---

# Governance Release

Prepare a versioned release pull request for the Wildpanda governance framework.

## Prerequisites

### GitHub CLI (`gh`)
- **Required**: yes
- **Verify**: `gh auth status`
- **Install**:
  - Windows: `winget install GitHub.cli`
  - Linux: `sudo apt install gh` or `brew install gh`
  - macOS: `brew install gh`
- **Post-install**: `gh auth login`

### Pre-Check (Step 0, mandatory before any release operation)
1. Detect `gh` on PATH or known install locations.
   - Not found → display install command for detected OS, ask user to install, **stop**.
2. Run `gh auth status`.
   - Not authenticated → display `gh auth login`, ask user to authenticate, **stop**.
3. Identify the upstream repo.
   - If running inside a consuming project: read `project_profile.yaml` → `governance.upstream_repo`.
   - If running standalone or in the Wildpanda repo itself: default to `Shanlans/Wildpanda`.
   - If neither can be determined → prompt user for repo, **stop** until provided.

## Trigger
- **Manual only**: maintainer invokes the skill when ready to cut a release.
- **Keyword triggers** (any of these phrases activates this skill):
  - "agent 发布正式版本"
  - "agent 正式发布"
  - "发布新版本"
  - "prepare release"
  - "cut a release"

## Run Environment
- Can be run from any project or any environment. The skill operates on the Wildpanda repo remotely via GitHub API and temp directory clone.

## Release Flow

### Step 1: Read Current Release State
- Fetch the latest tag from upstream: `gh api repos/<upstream_repo>/tags -q '.[0].name'`
- Fetch the current `VERSION` file: `gh api repos/<upstream_repo>/contents/VERSION -q .content | base64 -d`
- Fetch the latest commit hash on the default branch: `gh api repos/<upstream_repo>/commits/<upstream_branch> -q .sha`
- If latest tag commit == latest branch commit → "No unreleased changes. Nothing to release." → **end**.

### Step 2: Collect Merged PRs Since Last Tag
- List merged PRs since last tag:
  ```
  gh api repos/<upstream_repo>/pulls?state=closed&base=<upstream_branch>&sort=updated&direction=desc
  ```
- Filter to PRs merged after the last tag date.
- For each merged PR, extract:
  - PR number and title
  - PR body → look for `Co-Authored-By:` lines → contributor names
  - Merge commit SHA
- If no merged PRs found since last tag → "No merged PRs since last release." → **end**.

### Step 3: Build Change Summary
- Group changes by category (inferred from PR title prefixes or labels):
  - `[Contrib]` → Contributed improvements
  - `[Fix]` → Bug fixes
  - `[Release]` → Release housekeeping (skip — meta)
  - Other → General changes
- Build a structured summary:
  ```
  ### Added
  - <description> (#<PR number>)
  
  ### Changed
  - <description> (#<PR number>)
  
  ### Fixed
  - <description> (#<PR number>)
  ```

### Step 4: Suggest Version Number
- Read current VERSION (e.g., `1.1.0`).
- Apply version semantics:
  - **Patch** (`1.1.0 → 1.1.1`): typo fixes, formatting, non-functional corrections
  - **Minor** (`1.1.0 → 1.2.0`): new spec sections, new fields, new skills, backward-compatible additions
  - **Major** (`1.1.0 → 2.0.0`): breaking changes to template-owned file structure or governance workflow
- Suggest the appropriate bump based on PR content.
- Display suggestion to user. User can override to any bump level.

### Step 5: Present Release Plan
Display to user:
- Current version → proposed version
- Number of merged PRs included
- Change summary (from Step 3)
- Contributor list (all Co-Authored-By names from merged PRs)
- Ask: "Prepare release PR for v<proposed_version>? (Y/N)"
- If user declines → **end**.

### Step 6: Fork or Clone
- If user has push access to upstream (maintainer):
  - `git clone https://github.com/<upstream_repo>.git /tmp/wildpanda-release-<timestamp>/`
- If user does not have push access:
  - `gh repo fork <upstream_repo> --clone=false` (if not already forked)
  - Clone fork to temp directory
  - Add upstream remote

### Step 7: Create Release Branch
- `cd /tmp/wildpanda-release-<timestamp>/`
- `git fetch origin <upstream_branch>`
- `git checkout -b release/v<proposed_version>` from `origin/<upstream_branch>`

### Step 8: Update VERSION
- Write proposed version to `VERSION` file.

### Step 9: Update CHANGELOG.md
- Read existing CHANGELOG.md.
- Insert new entry at the top of the changelog (below header), replacing `## [Unreleased]` content:
  ```markdown
  ## [<proposed_version>] — <YYYY-MM-DD>
  
  <change summary from Step 3>
  
  ### Contributors
  <list of contributors from merged PRs>
  ```

### Step 10: Update CONTRIBUTORS.md
- Read existing CONTRIBUTORS.md.
- For each new contributor (from merged PR Co-Authored-By lines) not already listed:
  - Append row: `| <name> | @<github_handle> | v<proposed_version> (<date>) |`
- If no new contributors → leave unchanged.

### Step 11: Commit
- Read contributor identity:
  - `git config user.name` → releaser name
  - `git config user.email` → releaser email
- Commit message:
  ```
  Release v<proposed_version>
  
  Includes <N> merged PRs since v<current_version>.
  
  Co-Authored-By: <releaser_name> <releaser_email>
  ```

### Step 12: Push
- `git push origin release/v<proposed_version>`

### Step 13: Create Pull Request
- `gh pr create` targeting `<upstream_repo>:<upstream_branch>` with:
  - **Title**: `Release v<proposed_version>`
  - **Body**:
    ```
    ## Release v<proposed_version>
    
    **Previous version**: v<current_version>
    **Release date**: <YYYY-MM-DD>
    
    ## Changes
    <change summary from Step 3>
    
    ## Merged PRs
    <list of PR numbers and titles>
    
    ## Contributors
    <contributor list>
    
    ## Release Checklist
    - [ ] CHANGELOG.md updated
    - [ ] VERSION bumped
    - [ ] CONTRIBUTORS.md updated
    - [ ] Maintainer reviewed and approved
    - [ ] Merged to <upstream_branch>
    - [ ] Tag `v<proposed_version>` created on merge commit
    ```

### Step 14: Output
- Display PR URL.
- Remind: "Maintainer: review, merge, then create tag `v<proposed_version>` on the merge commit."
- Display tagging command for reference:
  ```
  gh api repos/<upstream_repo>/git/refs -f ref="refs/tags/v<proposed_version>" -f sha="<merge_commit_sha>"
  ```

### Step 15: Cleanup
- Remove temp directory `/tmp/wildpanda-release-<timestamp>/`.
- If cleanup fails, warn user with path for manual removal.

## README Check (Mandatory)
- Before creating the release PR, review the merged PRs for any changes that affect capabilities described in `README.md` (e.g., new skills, changed workflows, new features).
- If yes: update `README.md` in the same release PR to reflect all relevant changes.
- If no: no action needed.

## Important Notes
- This skill only creates a PR. It never merges to the main branch automatically.
- Only the maintainer merges the release PR and creates the tag on GitHub.
- The tag must point to the merge commit on the main branch, not to the release branch.
- VERSION, CHANGELOG.md, and CONTRIBUTORS.md are the only files modified by this skill.
- If there are no merged PRs since the last tag, there is nothing to release.
- Contributor signature (Co-Authored-By) is mandatory in the release commit.
