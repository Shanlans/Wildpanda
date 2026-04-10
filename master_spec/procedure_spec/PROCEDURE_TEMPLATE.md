# Procedure Template

## Metadata
- Procedure name:
- Path:
- Owner:
- Last updated:
- Classification: `template-owned skeleton`

## When To Use
- Describe the class of workflow this procedure applies to.

## Procedure Goal
- Describe the reusable workflow intent.

## Pipeline
1. List reusable step names in order.
2. Keep repository-instance command details out of this template.

## Command/Skill Binding Rule
- Pipeline ordering may reference generic skills or phases.
- Concrete command bodies and repository-specific artifacts must be resolved from:
  1. `project_profile.yaml`
  2. repository procedure instance file
  3. selected acceptance profile

## Output Requirements
- Define reusable expected outputs and gates.
- Do not hardcode repository-specific paths unless the instance file supplies them.

## Instance Notes
- Repository instance files may add:
  - concrete skill names
  - instance-specific output files
  - repository-specific stop conditions

