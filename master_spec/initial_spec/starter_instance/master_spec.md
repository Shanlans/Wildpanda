# Project Master Spec

## Metadata
- Module: `PROJECT`
- Path: `master_spec/master_spec.md`
- Owner: `bootstrap-generated instance`
- Last updated: `bootstrap bootstrap date`

## 1. Purpose
- Define repository-level governance boundaries and stable cross-module constraints.
- Serve as the initial instance master spec after package bootstrap.

## 2. Scope
- Applies to the full current repository.
- Module-private long-term rules belong in each subproject `Spec/Spec.md`.
- Task-specific or temporary requirements belong in `task/**`.

## 3. Governance Layering
- Mandatory read order and conflict priority are defined by `AGENTS.md`.
- Project-scoped runtime/build configuration belongs in `project_profile.yaml`.
- Acceptance criteria belong in `master_spec/acceptance_spec/*.acceptance.md`.
- Flow/procedure routing belongs in `master_spec/flow_spec/**` and `master_spec/procedure_spec/**`.

## 4. Global Constraints
- Keep repository-specific commands and paths out of this file.
- Change principle: minimal, compatible, and spec-first when behavior/contracts are affected.

## 5. Acceptance Baseline
- Acceptance command details must not be duplicated here.
- Canonical command/config sources:
  1. `project_profile.yaml`
  2. selected acceptance profile from `master_spec/acceptance_spec/acceptance_catalog.md`
  3. environment/tool resolution from `master_spec/env_spec.md`

