# Procedure Spec: New Project Governance Bootstrap

## Metadata
- Procedure name: `New_Project_Governance_Bootstrap`
- Entry: new repository governance initialization
- Path: `master_spec/procedure_spec/New_Project_Governance_Bootstrap.procedure.md`
- Last updated: `2026-03-17`

## Template Binding
- Template skeleton: `master_spec/procedure_spec/PROCEDURE_TEMPLATE.md`
- Repository classification: `template bootstrap procedure`

## When To Use
- A repository wants to adopt this governance system for the first time.
- Governance roots are missing or only a partial `AGENTS.md` exists.
- Execution should follow `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_CHECKLIST.md` as the concrete bootstrap checklist.

## Procedure Goal
- Create the minimal reusable governance structure for a new repository without copying RAWHDR-specific instance values.
- Delegate repository-instance file generation to `master_spec/procedure_spec/New_Project_Instance_Generation.procedure.md`.
- Prefer one deterministic high-level entrypoint when repository facts are already known.

## Preferred Automation Entrypoints
- Input template: `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json`
- High-level script: `skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1`
- Delegation target: `skill/bootstrap-governance/scripts/initialize-bootstrap-artifacts.ps1`

## Minimum Required Input Schema
- repository name
- repository id
- repository root
- full-build command
- runtime-smoke command
- runtime working directory
- at least one test entry
- at least one third-party exclusion path
- at least one skill registry item
- at least one release-pipeline step

## Pipeline
1. Confirm bootstrap trigger using `master_spec/initial_spec/initial_spec.md`.
2. Fill or review `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json` when a reusable input artifact is preferred.
3. Collect and validate the minimum required input schema.
4. Create required governance directories.
5. Copy/create template-owned governance files.
6. Execute repository-instance generation using `master_spec/procedure_spec/New_Project_Instance_Generation.procedure.md`.
7. Prefer `skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1` with `-InputFile` when deterministic automation is desired and required repository facts are available.
8. Record bootstrap result and remaining instance-specific follow-up in both the instantiated task file and the bootstrap manifest.

## Required Inputs
- repository name/id
- repository root
- build/runtime command facts
- runtime working directory
- test entry inventory
- third-party exclusion paths
- intended skill registry / release pipeline

## Output Requirements
- `project_profile.yaml` instantiated from `master_spec/project_profile_template.yaml`
- one bootstrap task file instantiated from `master_spec/task_spec/NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md`
- one bootstrap manifest instantiated from `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`
- required `master_spec/**` structure exists
- `task/` and `task/Achieve/` exist
- `master_spec/chat_spec/chat_index.md` exists
- `master_spec/comment_spec/comment_status.md` exists
- the bootstrap task file records what was created and what remains instance-specific

## Notes
- Template-owned files should be copied with minimal wording changes.
- Instance-owned files must be explicitly instantiated for the new repository and must not retain RAWHDR values by accident.
- The checklist document is the quick execution aid; this procedure defines the reusable operational policy.
- If required repository facts are incomplete, stop before automation and record the missing facts as pending instead of guessing.
