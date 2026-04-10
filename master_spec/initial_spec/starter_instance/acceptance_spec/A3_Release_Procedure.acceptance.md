# Acceptance Profile: A3_Release_Procedure

## Template Binding
- Template skeleton: `master_spec/acceptance_spec/ACCEPTANCE_PROFILE_TEMPLATE.md`
- Repository classification: `starter instance profile`

## Scope
- Full release/publish workflow.

## Required Sequence
1. Execute `A2_Algorithm_Library_Change` acceptance if code changed.
2. Execute the repository release pipeline declared in `project_profile.yaml -> skills.release_pipeline`.
3. Respect explicit user confirmation gates before push.

## Pass Criteria
- All required release-pipeline steps succeed in order with required gates.
