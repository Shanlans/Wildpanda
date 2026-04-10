# Acceptance Catalog (Starter Instance)

## Template Binding
- Template skeleton: `master_spec/acceptance_spec/ACCEPTANCE_CATALOG_TEMPLATE.md`
- Repository classification: `repository instance catalog`

## Purpose
- Centralize acceptance rules by change type.
- Replace or extend these starter entries with repository-specific acceptance details when the target repository is ready.

## Profiles
1. `A0_Documentation_Only`
- File: `master_spec/acceptance_spec/A0_Documentation_Only.acceptance.md`
- Use for: pure docs/spec/task text updates without code changes.

2. `A1_Spec_Only`
- File: `master_spec/acceptance_spec/A1_Spec_Only.acceptance.md`
- Use for: spec/flow/procedure documentation updates only, no code or cfg changes.

3. `A1_Config_Only_Change`
- File: `master_spec/acceptance_spec/A1_Config_Only_Change.acceptance.md`
- Use for: configuration-file-only changes (parameter files, cfg, ini, txt under Data/**).
- Key difference from A1: requires runtime smoke test; no build required; `ProcedureCompleted` is not_applicable.

4. `A2_Algorithm_Library_Change`
- File: `master_spec/acceptance_spec/A2_Algorithm_Library_Change.acceptance.md`
- Use for: algorithm or library code changes.

5. `A3_Release_Procedure`
- File: `master_spec/acceptance_spec/A3_Release_Procedure.acceptance.md`
- Use for: release/publish procedure execution.

## Selection Rule
- If touched files include algorithm-library code, use `A2`.
- If task is release pipeline, use `A3`.
- If only cfg/parameter files changed (no source code), use `A1_Config_Only_Change`.
- If only spec/flow/procedure/task docs changed, use `A1_Spec_Only` or `A0`.
- Selection priority when in doubt: A2 > A1_Config_Only_Change > A1_Spec_Only > A0.

