# Changelog

All notable changes to Wildpanda are documented in this file.

## [1.4.0] — 2026-04-13

### Added
- New skill: readme-update — keeps README.md and README_zh.md in sync with framework state (version, triggers, features, diagrams). Auto-triggered during release and contribute; manual trigger: "update readme" (#19)
- Command Reference section in both READMEs listing all skill trigger phrases in Chinese and English (#19)
- `project.owner` field in project_profile_template.yaml for owner-based comment signatures (#19)

### Changed
- Removed Claude Code branding from READMEs; primary target changed to generic "LLM coding agents" (#19)
- Replaced `@codex-comment` signature with `@<owner>-comment` (reads from `project_profile.yaml → project.owner`) across comment_spec, coding_spec, and AGENTS.md (#19)
- governance-release now calls readme-update at Step 9.5 before release commit (#19)
- governance-contribute README Check now delegates to readme-update skill (#19)
- Increased README logo size from 120px to 240px (#18)
- Fixed CJK alignment in Chinese README diagrams (#19)

### Contributors
- Shanlan (@Shanlans)

## [1.3.1] — 2026-04-13

### Changed
- Rewrote README.md and README_zh.md with full feature coverage: expanded from 7 summary points to 8 detailed sections (task lifecycle, multi-session safety, acceptance profiles, code change governance, spec-first & flow docs, bootstrap, drift prevention, safety boundaries) (#16)
- Added version display line and Star History chart to both READMEs (#16)
- Updated flow diagram with governance decision and rule reconfirmation steps (#16)

### Contributors
- Shanlan (@Shanlans)


## [1.3.0] — 2026-04-13

### Added
- New skill: call-graph — low-level utility for querying function call relationships using static analysis tools (ctags, cscope, pyan3, madge, go callgraph), 5 query types Q1-Q5 (#13)
- New skill: flow-discovery — high-level flow spec generation using call-graph skill, 7-step discovery flow with user confirmation (#13)
- README_zh.md — separate Chinese README with language switch links (#14)
- AGENTS.md §8: flow-discovery trigger rule and call-graph-first rule (#13)
- governance_template_boundary.md: call-graph and flow-discovery added to template-owned skill list (#13)

### Changed
- README.md split into separate English and Chinese files with mutual language switch links (#14)
- All 6 skill trigger sections updated to bilingual Chinese + English (#13)
- AGENTS.md prompts changed from Chinese to English (#13)

### Contributors
- Shanlan (@Shanlans)

## [1.2.3] — 2026-04-13

### Fixed
- chat_spec.md §3 step 0.5: added automatic governance section initialization with defaults when missing from project_profile.yaml, so new projects get sync check on first session without manual setup (#11)

### Contributors
- shanlan.shen (@Shanlans)

## [1.2.2] — 2026-04-13

### Fixed
- Added Step 15 "Post-Release Sync Reminder" to governance-release skill — after release PR is merged and tagged, prompts user to run governance-sync immediately if inside a consuming project (#9)

### Contributors
- shanlan.shen (@Shanlans)

## [1.2.1] — 2026-04-10

### Changed
- Decoupled coding_spec.md from project-specific content: Android/MSVC toolchain names replaced with generic cross-platform rule, 23 image-class list replaced with instance-owned extension pattern (#7)
- Added coding_spec_instance.md to instance-owned list in governance_template_boundary.md (#7)

### Contributors
- shanlan.shen (@Shanlans)

## [1.2.0] — 2026-04-10

### Added
- Redesigned README.md with centered layout, shields.io badges, navigation bar, ASCII architecture diagram, and governance lifecycle flow chart (#3)
- AI-generated muscular panda PNG logo (`assets/logo.png`) (#4, #5)
- Mandatory README Check section in governance-contribute and governance-release skills (#3)
- Keyword triggers for governance-contribute and governance-release skills (#3)

### Removed
- Placeholder SVG logo (`assets/logo.svg`) (#4, #5)

### Contributors
- shanlan.shen (@Shanlans)


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
