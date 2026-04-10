# Acceptance Profile: A2_Algorithm_Library_Change

## Template Binding
- Template skeleton: `master_spec/acceptance_spec/ACCEPTANCE_PROFILE_TEMPLATE.md`
- Repository classification: `starter instance profile`

## Scope
- Any algorithm-library code change, including bug fixes and behavior updates.

## Required Checks
1. Resolve full-build command from `project_profile.yaml` and `master_spec/env_spec.md`.
2. Resolve runtime-smoke command from `project_profile.yaml` and `master_spec/env_spec.md`.
3. Full solution build is required unless the repository defines a stricter equivalent acceptance rule.

## Pass Criteria
- Full build exit code is `0`.
- Runtime smoke exit code is `0`, or the repository instance file records the explicit blocker and stops release actions.
