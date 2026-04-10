# Skill Spec Governance (Project-Decoupled)

## Metadata
- Path: `master_spec/skill_spec/skill_spec.md`
- Owner: Shanlan
- Last updated: 2026-02-27

## 1. Purpose
- Decouple skill registration from `AGENTS.md`.
- Keep project-specific skill sets configurable per repository.
- Ensure different projects can use different skills without polluting global agent rules.

## 2. Registration Source Of Truth
- Project-level skill registration must be defined in `project_profile.yaml` under:
  - `skills.registry`
  - `skills.release_pipeline` (if a pipeline is needed)
- `AGENTS.md` must not hardcode a project skill name list.

## 3. Catalog Binding
- `master_spec/skill_spec/skill_catalog.md` is the normalized human-readable project catalog.
- Authoritative runtime/config source remains `project_profile.yaml.skills.*`.
- Catalog entries should map each skill name to:
  - local path (for example `skill/<name>/SKILL.md`)
  - intent/use case
  - status (`active` / `inactive`)

## 4. Runtime Availability Rule
- Declared registration is desired configuration.
- Actual executability still depends on session runtime-exposed available skill list.
- If a registered skill is missing in runtime:
  1. report as `registered-but-not-exposed`,
  2. continue with best fallback (manual command flow) when safe,
  3. do not silently skip the step.
- Bootstrap-specific runtime exposure binding:
  - `bootstrap-governance` runtime handling should follow `master_spec/procedure_spec/Bootstrap_Skill_Runtime_Exposure.procedure.md`.
  - Repository-specific installer/exposure mechanics may extend that path in repository-instance docs, but must preserve the explicit `registered-but-not-exposed` fallback classification.

## 5. Pipeline Policy
- If user requests full release pipeline:
  - Execute in order defined by `project_profile.yaml.skills.release_pipeline`.
- If user names a specific skill:
  - Execute that skill only.
- If pipeline includes a push step:
  - Explicit same-session user confirmation is mandatory before push.

## 6. Update Rule
- When adding/removing project skills:
  1. update `project_profile.yaml.skills.*`,
  2. update `master_spec/skill_spec/skill_catalog.md`,
  3. avoid hardcoding the same list in `AGENTS.md`.
