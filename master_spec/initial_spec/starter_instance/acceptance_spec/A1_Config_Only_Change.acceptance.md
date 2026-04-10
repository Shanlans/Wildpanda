# Acceptance Profile: A1_Config_Only_Change

## Template Binding
- Template skeleton: `master_spec/acceptance_spec/ACCEPTANCE_PROFILE_TEMPLATE.md`
- Repository classification: `starter instance profile`

## Scope
- Configuration-file-only changes: parameter files, cfg, ini, txt, or equivalent data-drive files.
- No algorithm library source code modified.

## Required Checks
1. Runtime smoke test passes with the modified cfg file (no parameter parse error, no runtime crash).
2. Targeted quality/performance metric (if specified in task Pass/Fail Criteria) is measured and recorded.
3. No source code files modified.

## Command Binding Rule
- Concrete runtime command comes from `project_profile.yaml` and the repository runtime spec.
- Build step is not required (no code change).

## Pass Criteria
- Runtime smoke test exit code = 0.
- All task-specific Pass/Fail criteria evaluated with actual vs threshold recorded.

## State Machine Impact
- Tasks using this profile skip `ProcedureCompleted` (no release pipeline required).
- Agent must record `ProcedureCompleted: not_applicable` in Post-Execution Review per task_spec §11.1.

## Instance Notes
- Repository instances should extend with concrete runtime command from `project_profile.yaml`.
