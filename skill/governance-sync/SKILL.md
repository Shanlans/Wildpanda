---
name: governance-sync
description: Check upstream Wildpanda repo for governance framework updates and sync template-owned files into the consuming project. Use when starting a new session (continuity check) or when the user asks to check for governance updates.
---

# Governance Sync

Pull governance framework updates from the upstream Wildpanda repo into the current consuming project.

## Prerequisites

### GitHub CLI (`gh`)
- **Required**: yes
- **Verify**: `gh auth status`
- **Install**:
  - Windows: `winget install GitHub.cli`
  - Linux: `sudo apt install gh` or `brew install gh`
  - macOS: `brew install gh`
- **Post-install**: `gh auth login`

### Pre-Check (Step 0, mandatory before any sync operation)
1. Detect `gh` on PATH or known install locations.
   - Not found → display install command for detected OS, ask user to install, **stop**.
2. Run `gh auth status`.
   - Not authenticated → display `gh auth login`, ask user to authenticate, **stop**.
3. Read `project_profile.yaml` → `governance` section.
   - If `governance.upstream_repo` is missing → prompt user for upstream repo (default: `Shanlans/Wildpanda`), write it into `project_profile.yaml`, continue.
   - If entire `governance` section is missing → initialize with defaults:
     ```yaml
     governance:
       framework_version: "unknown"
       upstream_repo: "Shanlans/Wildpanda"
       upstream_branch: "master"
       upstream_commit: "unknown"
       last_sync_at: "never"
     ```

## Trigger / 触发条件
- **Automatic / 自动**: during `chat_spec.md` §3 continuity check (step 0.5), if `governance.upstream_repo` is defined.
  每次新 session 启动时，如果 `project_profile.yaml` 配置了 `governance.upstream_repo`，自动检查上游更新。
- **Manual / 手动**: user invokes the skill directly.
  用户直接调用。
- **Automatic behavior / 自动行为**: notify user if update available, do NOT auto-update without confirmation.
  有更新时通知用户，不自动更新。
- **Keyword triggers / 关键词触发**:
  - "检查治理更新" / "check governance updates"
  - "同步治理逻辑" / "sync governance"
  - "检查 agent 版本" / "check agent version"

## Sync Flow

### Step 1: Read Local State
Read `project_profile.yaml` → extract all 5 governance fields:
- `framework_version`
- `upstream_repo`
- `upstream_branch`
- `upstream_commit`
- `last_sync_at`

### Step 2: Read Remote State
- Fetch remote `VERSION` file: `gh api repos/<upstream_repo>/contents/VERSION -q .content | base64 -d`
- Fetch latest commit hash on `<upstream_branch>`: `gh api repos/<upstream_repo>/commits/<upstream_branch> -q .sha`

### Step 3: Compare
- If `upstream_commit` == remote latest commit → output "Governance is up to date (v<version>)" → **end**.
- If different → continue to Step 4.

### Step 4: Fetch Changelog
- Fetch remote `CHANGELOG.md` via GitHub API.
- Extract entries between local `framework_version` and remote version.
- Display changelog summary to user.

### Step 5: Build File List
- Read local `master_spec/initial_spec/governance_template_boundary.md` §3.1 → extract template-owned file list.
- These are the only files eligible for sync.

### Step 6: Per-File Diff
- For each template-owned file:
  - Fetch remote version via `https://raw.githubusercontent.com/<upstream_repo>/<upstream_branch>/<path>`.
  - Diff with local version.
  - Classify: `changed` / `unchanged` / `new` (exists remote but not local) / `deleted` (exists local but not remote).
- For `AGENTS.md` (hybrid):
  - Fetch and diff, but mark as **report-only** (will not be auto-overwritten).

### Step 7: Present to User
Display:
- Version change (e.g., `1.0.0 → 1.1.0`)
- Commit distance (e.g., `3 commits ahead`)
- Changelog summary
- File list with diff status:
  ```
  CHANGED  master_spec/chat_spec/chat_spec.md
  NEW      skill/governance-sync/SKILL.md
  NEW      skill/governance-contribute/SKILL.md
  ...
  ```
- AGENTS.md diff (if any) with note: "hybrid file, review manually"
- Ask: "Apply updates? (Y/N)"

### Step 8: Apply (on user confirmation)
- Overwrite each `changed` or `new` template-owned file with remote content.
- For `deleted` files: warn user, do not auto-delete.
- Do NOT touch: instance-owned files (§3.2), runtime files (§3.3), AGENTS.md (§4 hybrid).
- Update `project_profile.yaml` governance section:
  ```yaml
  governance:
    framework_version: "<remote VERSION>"
    upstream_repo: "<unchanged>"
    upstream_branch: "<unchanged>"
    upstream_commit: "<remote latest commit hash>"
    last_sync_at: "<current ISO timestamp>"
  ```

### Step 9: Commit
- Auto-commit with message: `"upgrade governance to Wildpanda v<version> (<short_commit>)"`
- If user declines commit, leave changes staged.

## Files Never Touched by Sync
- `project_profile.yaml` (except governance section fields)
- `master_spec/master_spec.md`
- `master_spec/env_spec.md`
- `master_spec/acceptance_spec/acceptance_catalog.md`
- `master_spec/acceptance_spec/A*.acceptance.md` (instance profiles)
- `master_spec/flow_spec/flow_catalog.md`
- `master_spec/flow_spec/*.flow.md`
- `master_spec/procedure_spec/procedure_catalog.md`
- `master_spec/procedure_spec/*.procedure.md` (instance procedures)
- `master_spec/skill_spec/skill_catalog.md`
- `master_spec/chat_spec/chat_index.md`
- `master_spec/comment_spec/comment_status.md`
- `task/**`
- `AGENTS.md` (report diff only, never overwrite)
