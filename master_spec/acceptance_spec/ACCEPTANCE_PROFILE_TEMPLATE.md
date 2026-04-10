# Acceptance Profile Template

## Metadata
- Profile name:
- Path:
- Owner:
- Last updated:
- Classification: `template-owned skeleton`

## Scope
- Describe what change category this profile is intended to validate.

## Required Checks
1. Structural/document review checks that are reusable across repositories.
2. Command/config source rules.
3. Repository-instance gates that must be supplied by instance files or `project_profile.yaml`.

## Command Binding Rule
- Generic command structure belongs in the template only as a source rule.
- Concrete command bodies must come from repository-instance files:
  1. `project_profile.yaml`
  2. repository acceptance instance file
  3. environment/tool resolution from `master_spec/env_spec.md`

## Pass Criteria
- Define reusable pass/fail semantics.
- Do not hardcode repository-specific binary names or datasets in this template.

## Instance Notes
- Repository instance files may extend this template with:
  - module/path examples
  - concrete command bodies
  - repository-specific blockers

