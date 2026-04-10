# Project Environment Spec

## Metadata
- Module: `PROJECT environment baseline`
- Path: `master_spec/env_spec.md`
- Owner: `bootstrap-generated instance`
- Last updated: `bootstrap bootstrap date`

## 1. Goal
- Centralize required local build/run environment information.
- Define how the agent discovers missing tools and persists resolved paths.

## 2. Environment Baseline
- OS: fill during repository validation
- Toolchain: fill during repository validation

## 3. Known Tool Paths
- `(none yet)`

## 4. Environment Variables And Resolution Policy
- If a required tool/path/env is missing during task execution, the agent must:
  1. Detect the missing dependency from command failure or precheck.
  2. Auto-search locally first.
  3. If still unresolved, ask the user.
  4. Persist the resolved value into this file once confirmed usable.

