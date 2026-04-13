---
name: bootstrap-governance
description: Use when a repository is adopting this governance system for the first time and you need to drive bootstrap setup, including initialization trigger checks, template-to-instance generation, bootstrap task creation, checklist execution, manifest recording, and deterministic bootstrap artifact initialization.
---

# Bootstrap Governance

Use this skill when the user wants to onboard a new repository into this governance system or asks to bootstrap missing governance structure from templates.

## Trigger / 触发条件
- **Automatic / 自动**: during `chat_spec.md` §3 continuity check (step 0), if governance state is `initial-only`.
  新 session 启动时，如果项目治理状态为 `initial-only`（只有 AGENTS.md 或治理结构不完整），自动触发。
- **Manual / 手动**: user wants to onboard a new repository into governance.
  用户想给新项目接入治理框架时手动调用。
- **Keyword triggers / 关键词触发**:
  - "初始化治理" / "initialize governance"
  - "引导治理" / "bootstrap governance"
  - "新项目接入" / "onboard new project"

## What This Skill Owns
- Detect whether bootstrap is needed.
- Route execution through the bootstrap governance documents in the correct order.
- Keep bootstrap outputs recorded through the standard task/checklist/manifest artifacts.

## Required Read Order
1. `master_spec/initial_spec/initial_spec.md`
2. `master_spec/procedure_spec/New_Project_Governance_Bootstrap.procedure.md`
3. `master_spec/procedure_spec/New_Project_Instance_Generation.procedure.md`
4. `master_spec/procedure_spec/Bootstrap_Skill_Runtime_Exposure.procedure.md`
5. `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_CHECKLIST.md`
6. `master_spec/task_spec/NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md`
7. `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`
8. `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json`
9. `master_spec/project_profile_template.yaml`

## Execution Rules
1. Confirm the repository actually meets bootstrap trigger conditions before creating files.
2. Instantiate repository-owned files from templates; do not copy source-repository instance values blindly.
3. Create and maintain a tracked bootstrap task file under `task/`.
4. Use the checklist as the concrete execution order.
5. Use the manifest template as the bootstrap output handoff artifact.
6. If repository facts are unknown, record them as pending instead of guessing.
7. For a true new-repository setup, prefer `scripts/bootstrap-new-repository.ps1` as the high-level entrypoint.
8. Prefer a filled input file based on `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json` when repository facts should be reviewed or reused outside one command line.
9. When deterministic artifact creation is helpful but a repository already exists, use `scripts/initialize-bootstrap-artifacts.ps1` for the minimal bootstrap artifact set.

## Deliverables
- bootstrap task file
- instantiated `project_profile.yaml`
- instantiated runtime/task-state files
- instantiated bootstrap manifest
- updated bootstrap status in the active task record

## Shortest Example
- Example input file: `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_EXAMPLE.json`
- Minimal invocation:
```powershell
powershell -ExecutionPolicy Bypass -File .\skill\bootstrap-governance\scripts\bootstrap-new-repository.ps1 -InputFile .\master_spec\initial_spec\NEW_PROJECT_BOOTSTRAP_INPUT_EXAMPLE.json
```
- Recommended first-use flow:
  1. Copy `NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json` to a repo-local working file.
  2. Fill the repository facts.
  3. Run `bootstrap-new-repository.ps1 -InputFile <your-file>`.

## Script
- `scripts/bootstrap-new-repository.ps1`
  - Purpose: one explicit new-repository bootstrap entrypoint with a minimum required input schema.
  - Scope: accepts either direct parameters or `-InputFile`, validates required repository facts, then delegates deterministic artifact generation to the lower-level initializer.
  - Preferred companion template: `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json`
- `scripts/initialize-bootstrap-artifacts.ps1`
  - Purpose: create the minimal bootstrap artifact set from existing templates.
  - Scope: directories, `project_profile.yaml`, bootstrap task, bootstrap manifest, `chat_index.md`, `comment_status.md`.
  - Guardrail: this script is intentionally narrow and does not attempt full repository-specific scaffolding.

## Registration Notes
- This skill is repository-configured through `project_profile.yaml` and cataloged in `master_spec/skill_spec/skill_catalog.md`.
- If the skill is registered but not runtime-exposed, follow `master_spec/procedure_spec/Bootstrap_Skill_Runtime_Exposure.procedure.md` and fall back to the same document-driven bootstrap flow manually.
