# Changelog

All notable changes to Wildpanda are documented in this file.

## [1.0.0] - 2026-04-10

### Initial Release

First public release of the governance framework extracted from RAWHDR production use.

#### Core Specs
- `AGENTS.md` — hybrid entry point (template-owned structure + instance-owned paths)
- `chat_spec.md` — session resume, continuity check, plain-language rule (§6), persistent chat status (§7)
- `task_spec.md` — task lifecycle state machine, decomposition, acceptance binding, archive procedure
- `coding_spec.md` — coding style, memory lifecycle governance
- `comment_spec.md` — function-comment scope, review workflow
- `read_audit_spec.md` — per-task source read audit trail
- `skill_spec.md` — skill registration and pipeline governance
- `initial_spec.md` — repository bootstrap trigger and propagation rule

#### Multi-Tenancy (ST-01 / ST-02 / ST-03)
- Task file as single source of truth for per-task runtime state (§7.1)
- `chat_index.md` thin index replacing monolithic `chat_status.md` (§7.2)
- Chat identity (`chat_id`), heartbeat, 4h stale threshold, takeover hard gate (§7.3)
- `Owning Chat ID` and `Last Heartbeat At` fields in TASK_TEMPLATE and MASTER_TASK_TEMPLATE
- `chat.stale_threshold_hours` configurable in `project_profile_template.yaml`

#### Templates
- `TASK_TEMPLATE.md` — 11-field Runtime State block
- `MASTER_TASK_TEMPLATE.md` — same with master aggregate note
- `ACCEPTANCE_PROFILE_TEMPLATE.md`, `ACCEPTANCE_CATALOG_TEMPLATE.md`
- `PROCEDURE_TEMPLATE.md`, `PROCEDURE_CATALOG_TEMPLATE.md`
- `FLOW_TEMPLATE.md`, `FLOW_CATALOG_TEMPLATE.md`
- `SKILL_CATALOG_TEMPLATE.md`
- `NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md`
- `READ_AUDIT_TEMPLATE.md`

#### Starter Instance (instance-owned skeletons)
- 5 acceptance profiles (A0, A1_Spec_Only, A1_Config_Only, A2, A3) + catalog
- `chat_index.md` (empty, 5-column schema)
- `comment_status.md` (empty)
- `env_spec.md`, `master_spec.md` (skeleton)
- `flow_catalog.md`, `procedure_catalog.md`, `skill_catalog.md` (empty catalogs)

#### Bootstrap Tooling
- `bootstrap-new-repository.ps1` — one-command bootstrap from input JSON
- `initialize-bootstrap-artifacts.ps1` — minimal artifact initializer
- `NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json` + example
- `NEW_PROJECT_BOOTSTRAP_CHECKLIST.md`
- `NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`
- `governance_template_boundary.md` — template vs instance ownership matrix

#### Procedures (template-owned)
- `New_Project_Governance_Bootstrap.procedure.md`
- `New_Project_Instance_Generation.procedure.md`
- `Bootstrap_Skill_Runtime_Exposure.procedure.md`
- `Task_Closeout_And_Archive.procedure.md`
