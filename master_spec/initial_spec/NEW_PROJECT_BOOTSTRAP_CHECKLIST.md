# New Project Bootstrap Checklist

## Purpose
- Provide one explicit execution checklist for first-time repository adoption of this governance system.
- Reduce ambiguity by fixing the minimum instantiation order and expected output artifacts.

## When To Use
- A repository is onboarding this governance system for the first time.
- `master_spec/initial_spec/initial_spec.md` trigger conditions indicate governance roots are missing or incomplete.

## Required Inputs
- Repository display name
- Repository id
- Repository root
- Full-build command
- Runtime smoke command
- Runtime working directory
- Test entry inventory
- Third-party exclusion paths
- Skill registry
- Release pipeline

## Preferred Automation Path
- Preferred input template: `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json`
- Preferred script: `skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1`
- Use the template when the repository facts should be reviewed, handed off, or reused.
- Use the script with `-InputFile` once the template has been filled.

## Fixed Instantiation Order
1. Confirm the bootstrap trigger from `master_spec/initial_spec/initial_spec.md`.
2. Create missing governance directories required by `master_spec/initial_spec/initial_spec.md`.
3. Copy/create template-owned governance files needed for bootstrap.
4. Fill or review `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json`.
5. Collect and validate the minimum required input schema.
6. Instantiate `project_profile.yaml` from `master_spec/project_profile_template.yaml`.
7. Instantiate a bootstrap task record from `master_spec/task_spec/NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md`.
8. Execute repository-instance generation using `master_spec/procedure_spec/New_Project_Instance_Generation.procedure.md`.
9. Prefer `skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1 -InputFile <path>` for deterministic artifact creation.
10. Create runtime/task-state files:
   - `master_spec/chat_spec/chat_index.md`
   - `master_spec/comment_spec/comment_status.md`
   - `task/`
   - `task/Achieve/`
11. Update `AGENTS.md` only as needed to point to repository-instance facts instead of source-repository facts.
12. Instantiate and fill a bootstrap manifest from `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`.
13. Record created files, pending repository facts, and bootstrap conclusion in the instantiated bootstrap task file.

## Completion Checklist
- `project_profile.yaml` exists and does not retain source-repository instance values by accident.
- required `master_spec/**` roots exist.
- bootstrap task file exists under `task/`.
- runtime status files exist.
- the repository can complete the mandatory read order without missing-file fallback.
- remaining repository-specific follow-up items are recorded explicitly in the bootstrap task file.
- the automation entrypoint used is recorded in the bootstrap manifest.
- the input template path or equivalent reviewed input source is recorded in the bootstrap manifest.

## Evidence To Record
- instantiated `project_profile.yaml`
- instantiated bootstrap task file
- instantiated bootstrap manifest
- current `master_spec/chat_spec/chat_index.md`
- current `master_spec/comment_spec/comment_status.md`
- any intentionally deferred repository-instance files or facts

## Notes
- This checklist is a reusable bootstrap aid, not a runtime script.
- If repository facts are unknown, record them as pending rather than inventing values.
