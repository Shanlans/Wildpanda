# Changelog

All notable changes to Wildpanda are documented in this file.

## [1.1.1] — 2026-04-10

### Contributors
- shanlan.shen (@Shanlans)

### Contributed from RAWHDR
- Added keyword triggers to `governance-contribute` and `governance-release` skills (Chinese + English phrases for natural invocation)

## [1.1.0] - 2026-04-10

### Governance Skill Suite

Three new skills enabling governance lifecycle management for consuming projects:

#### New Skills
- `skill/governance-sync/SKILL.md` — Pull template-owned file updates from upstream Wildpanda into consuming projects. Triggered during session continuity check or manually. Compares local vs remote via GitHub API, presents diffs, overwrites on user confirmation.
- `skill/governance-contribute/SKILL.md` — Contribute governance improvements back to Wildpanda via pull request. Forks upstream, creates temp clone, copies selected files, drafts CHANGELOG entry, bumps VERSION, commits with `Co-Authored-By`, creates PR.
- `skill/governance-release/SKILL.md` — Prepare a versioned release PR for Wildpanda. Collects merged PRs since last tag, builds change summary, updates VERSION/CHANGELOG/CONTRIBUTORS, creates release PR. Maintainer merges and tags on GitHub.

#### Self-Governance Rules (`AGENTS.md` §12)
- PR-only policy for master branch (effective after v1.1.0)
- PR requirements: CHANGELOG entry + VERSION bump + Co-Authored-By
- Contributor tracking via `CONTRIBUTORS.md`
- Version semantics: patch / minor / major
- Self-application: Wildpanda follows its own task lifecycle
- Release process via governance-release skill (PR only, maintainer merges)
- Merge authority: only maintainer merges PRs and creates tags

#### New Files
- `CONTRIBUTORS.md` — contributor list with GitHub handle and first contribution version

#### Template Updates
- `project_profile_template.yaml` — governance section expanded from 1 field to 5: `framework_version`, `upstream_repo`, `upstream_branch`, `upstream_commit`, `last_sync_at`
- `chat_spec.md` §3 — added step 0.5: governance-sync check during session continuity
- `chat_spec.md` §7.3.6 — added "In-Session Rule Activation" requiring agent to self-apply newly created governance rules within the same session
- `governance_template_boundary.md` §3.1 — added 3 new skill directories and `governance_template_boundary.md` itself to template-owned list

#### Runtime Dependencies
- All 3 new skills require GitHub CLI (`gh`) with pre-check flow: detect on PATH → verify auth → install guidance per OS

---

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
