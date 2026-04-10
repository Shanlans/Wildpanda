# Procedure Spec: Bootstrap Skill Runtime Exposure

## Metadata
- Procedure name: `Bootstrap_Skill_Runtime_Exposure`
- Entry: bootstrap skill runtime-availability governance
- Path: `master_spec/procedure_spec/Bootstrap_Skill_Runtime_Exposure.procedure.md`
- Last updated: `2026-03-16`

## Template Binding
- Template skeleton: `master_spec/procedure_spec/PROCEDURE_TEMPLATE.md`
- Repository classification: `template runtime-exposure procedure`

## When To Use
- A repository has registered `bootstrap-governance` in `project_profile.yaml`, but bootstrap execution depends on whether the current session actually exposes that skill at runtime.
- Use this procedure before assuming the skill can be invoked directly.

## Procedure Goal
- Define one reusable path from `registered` to `runtime-exposed` or `manual fallback` for bootstrap skill execution.

## Pipeline
1. Confirm `bootstrap-governance` is registered in `project_profile.yaml.skills.registry`.
2. Check whether the current session runtime exposes `bootstrap-governance` in the available skill list.
3. If exposed, use the skill as the named bootstrap entrypoint.
4. If not exposed, report `registered-but-not-exposed`.
5. Fall back to the same document-driven bootstrap path:
   - `master_spec/procedure_spec/New_Project_Governance_Bootstrap.procedure.md`
   - `master_spec/procedure_spec/New_Project_Instance_Generation.procedure.md`
   - `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_CHECKLIST.md`
   - `master_spec/task_spec/NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md`
   - `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`
6. If the repository later adds a runtime installation/exposure mechanism, record that repository-specific path outside this template procedure.

## Output Requirements
- bootstrap skill exposure state is explicitly classified as:
  - `runtime-exposed`
  - `registered-but-not-exposed`
- fallback path is explicit when runtime exposure is absent
- bootstrap execution path is never silently skipped

## Notes
- This procedure governs runtime exposure only; it does not define a universal installer.
- Repository-specific installer/exposure mechanics belong in repository-instance docs, not this template procedure.
