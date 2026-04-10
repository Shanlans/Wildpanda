# Procedure Spec: New Project Instance Generation

## Metadata
- Procedure name: `New_Project_Instance_Generation`
- Entry: repository-instance file generation during first-time governance onboarding
- Path: `master_spec/procedure_spec/New_Project_Instance_Generation.procedure.md`
- Last updated: `2026-03-17`

## Template Binding
- Template skeleton: `master_spec/procedure_spec/PROCEDURE_TEMPLATE.md`
- Repository classification: `template instance-generation procedure`

## When To Use
- A repository is adopting this governance system and needs to instantiate repository-owned governance files from reusable templates and repository facts.
- This procedure is normally called from `master_spec/procedure_spec/New_Project_Governance_Bootstrap.procedure.md`.

## Procedure Goal
- Define one reusable path for turning template-owned governance assets into repository-instance files without leaking source-repository values.
- Provide a deterministic execution path when the repository facts are complete enough to use the bootstrap automation script.

## Preferred Deterministic Entrypoints
- Input template: `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json`
- High-level script: `skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1`
- Use this path when the full minimum input schema is known and the repository wants deterministic first-pass instance generation.
- The script validates the input schema first, then calls `skill/bootstrap-governance/scripts/initialize-bootstrap-artifacts.ps1` for the actual artifact instantiation.

## Pipeline
1. Collect repository facts required for instance generation.
2. Fill or review `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json` when a reusable input artifact is preferred.
3. Validate that the minimum automation input schema is complete.
4. Instantiate `project_profile.yaml` from `master_spec/project_profile_template.yaml`.
5. Instantiate the bootstrap task file from `master_spec/task_spec/NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md`.
6. Instantiate the bootstrap manifest from `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`.
7. Instantiate or update repository-owned governance files that must reflect local repository facts.
8. Create runtime/task-state files required for normal governance operation.
9. Verify instance files no longer retain unintended source-repository values.
10. Record generated outputs and pending follow-up items in the bootstrap task file and manifest.

## Required Inputs
- repository name/id/root
- build/runtime command facts
- runtime working directory
- test entry inventory
- third-party exclusion paths
- skill registry / release pipeline
- repository-specific master/env/catalog facts that cannot remain template-only

## Output Requirements
- `project_profile.yaml` instantiated with repository facts
- bootstrap task file instantiated
- bootstrap manifest instantiated
- repository-owned governance files updated with repository facts
- runtime/task-state files created
- no known source-repository value leakage remains in instance-owned files

## Notes
- This procedure standardizes instance generation and defines the conditions under which scripting is preferred.
- If required repository facts are unavailable, record them as pending in the bootstrap manifest instead of guessing.
