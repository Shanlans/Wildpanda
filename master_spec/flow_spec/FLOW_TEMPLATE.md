# Flow Template

## Metadata
- Flow name:
- Entry:
- Path:
- Owner:
- Last updated:
- Classification: `template-owned skeleton`

## When To Use
- Describe the class of call-path or module orchestration this flow documents.

## Flow Goal
- Describe the reusable documentation purpose for a flow spec.

## Primary Call Path
1. Entry function
2. Major stage
3. Major stage

## Function-Level Call Path
- Entry: `<ClassName>::<function>(file:line)`
- Trace each call with `file:line` references, branching conditions, and key state transitions.
- Use indented tree notation. Label branch conditions inline (e.g., `[guard: flag=false]`).
- Mark dead-code or disconnected paths explicitly with `NOTE:`.
- For async launch points, annotate `[async]` and name the target thread function.

## Spec Index
- List instance-owned header/spec bindings for the target repository.
- Keep the structure reusable, but keep actual module bindings in instance files.

## Acceptance
- Reference the selected acceptance profile.
- Concrete command bodies must come from:
  1. `project_profile.yaml`
  2. repository acceptance instance file
  3. environment/tool resolution from `master_spec/env_spec.md`

## Instance Notes
- Repository instance files may add:
  - actual entry file locations
  - actual module/header mappings
  - repository-specific acceptance reference

