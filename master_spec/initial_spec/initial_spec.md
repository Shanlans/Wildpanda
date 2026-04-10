# Initial Spec (Repository Bootstrap Governance)

## Metadata
- Path: `master_spec/initial_spec/initial_spec.md`
- Owner: Shanlan
- Last updated: 2026-04-08

## 1. Purpose
- Define how the agent initializes a repository when only `AGENTS.md` exists or the governance structure is incomplete.
- Keep initialization deterministic and reusable.

## 2. Trigger
- Trigger initialization when any of the required governance roots is missing:
  - `master_spec/master_spec.md`
  - `master_spec/task_spec/task_spec.md`
  - `master_spec/acceptance_spec/acceptance_catalog.md`
  - `task/`
  - `task/Achieve/`

## 3. Required Structure
- `master_spec/`
- `master_spec/task_spec/`
- `master_spec/acceptance_spec/`
- `master_spec/flow_spec/`
- `master_spec/procedure_spec/`
- `master_spec/skill_spec/`
- `master_spec/initial_spec/`
- `master_spec/chat_spec/`
- `master_spec/comment_spec/`
- `master_spec/read_audit_spec/`
- `task/`
- `task/Achieve/`

## 4. Required Templates
- `master_spec/project_profile_template.yaml`
- `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_CHECKLIST.md`
- `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`
- `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json`
- `project_profile.yaml` (project-scoped path/command/exclusion mapping)
- `master_spec/initial_spec/governance_template_boundary.md`
- `master_spec/acceptance_spec/ACCEPTANCE_PROFILE_TEMPLATE.md`
- `master_spec/acceptance_spec/ACCEPTANCE_CATALOG_TEMPLATE.md`
- `master_spec/procedure_spec/PROCEDURE_TEMPLATE.md`
- `master_spec/procedure_spec/PROCEDURE_CATALOG_TEMPLATE.md`
- `master_spec/flow_spec/FLOW_TEMPLATE.md`
- `master_spec/flow_spec/FLOW_CATALOG_TEMPLATE.md`
- `master_spec/skill_spec/SKILL_CATALOG_TEMPLATE.md`
- `master_spec/task_spec/TASK_TEMPLATE.md`
- `master_spec/task_spec/MASTER_TASK_TEMPLATE.md`
- `master_spec/task_spec/NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md`
- `master_spec/acceptance_spec/acceptance_catalog.md`
- `master_spec/flow_spec/flow_catalog.md`
- `master_spec/procedure_spec/procedure_catalog.md`
- `master_spec/skill_spec/skill_spec.md`
- `master_spec/skill_spec/skill_catalog.md`
- `master_spec/read_audit_spec/read_audit_spec.md`
- `master_spec/read_audit_spec/READ_AUDIT_TEMPLATE.md`
- `master_spec/env_spec.md`
- `skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1`

## 5. Initialization Rules
1. Create missing directories first.
2. Create missing templates from existing project conventions.
3. Instantiate `project_profile.yaml` from `master_spec/project_profile_template.yaml` instead of copying another repository profile verbatim.
4. Do not overwrite non-empty existing files unless user explicitly requests replacement.
5. Record initialization outcome in a task file under `task/`.
6. For first-time governance onboarding, instantiate the task record from `master_spec/task_spec/NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md`.
7. Follow the fixed bootstrap execution order from `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_CHECKLIST.md`.
8. Record actual bootstrap outputs in a repository-instance manifest instantiated from `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`.
9. Prefer `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json` when repository facts should be reviewed, reused, or handed off before execution.
10. Prefer `skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1` with `-InputFile` when the minimum required input schema is complete and deterministic first-pass initialization is desired.
11. If the minimum input schema is incomplete, record missing facts as pending instead of guessing.
12. Flow spec generation (bootstrap gate): bootstrap must produce at least one flow spec entry in `master_spec/flow_spec/flow_catalog.md`. The flow entry point must be confirmed by the user; the agent then traces and documents the complete function-level call chain in the matching `master_spec/flow_spec/*.flow.md`. If the entry point is not yet known, record it as pending in the bootstrap manifest instead of generating a placeholder-only flow.

## 5.1 Bootstrap Procedure Binding
- Recommended execution procedure for first-time adoption:
  - `master_spec/procedure_spec/New_Project_Governance_Bootstrap.procedure.md`

## 5.2 Instance Generation Procedure Binding
- Recommended repository-instance generation procedure during bootstrap:
  - `master_spec/procedure_spec/New_Project_Instance_Generation.procedure.md`

## 6. Acceptance
- All required structure and template files exist.
- Agent can complete mandatory read order without missing-file fallback.

## 7. Governance Spec Change Propagation Rule (Mandatory)

### 7.1 Trigger
This rule activates whenever any file under `master_spec/` is created, modified, or deleted as part of a task — including:
- acceptance profiles (`master_spec/acceptance_spec/*.acceptance.md`)
- acceptance catalog (`master_spec/acceptance_spec/acceptance_catalog.md`)
- task spec / task template (`master_spec/task_spec/task_spec.md`, `master_spec/task_spec/TASK_TEMPLATE.md`)
- chat spec / chat index (`master_spec/chat_spec/chat_spec.md`, `master_spec/chat_spec/chat_index.md`)
- procedure specs (`master_spec/procedure_spec/*.procedure.md`)
- initial spec itself (`master_spec/initial_spec/initial_spec.md`)

### 7.2 Propagation Check (Mandatory)
After any qualifying `master_spec/` change, agent must:
1. Identify which concepts were added, changed, or removed.
2. Check each corresponding bootstrap/starter file for an outdated or missing counterpart:
   - `master_spec/initial_spec/starter_instance/acceptance_spec/acceptance_catalog.md`
   - `master_spec/initial_spec/starter_instance/acceptance_spec/*.acceptance.md`
   - `master_spec/task_spec/TASK_TEMPLATE.md` (profile dropdown, mandatory fields)
   - `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_CHECKLIST.md`
   - `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`
3. For each file that is outdated or missing a counterpart: apply the corresponding update.
4. For each file that is not affected: record explicitly `not_applicable`.

### 7.3 Required Output
Agent must output one propagation check summary line per qualifying change:
- `GovernancePropagationCheck: <changed file> → <bootstrap file> → <updated | not_applicable>`

### 7.4 Hard Gate
- A governance spec change is not considered complete until the propagation check has been run and recorded.
- Skipping the propagation check is a governance violation equivalent to an incomplete task closeout.
- The check must be performed in the same session as the spec change, not deferred to a later task.
