# AGENT Working Rules

When you read this file everytime, Give the phrase: "Agents loading".

## 1) Scope
- Repository root must be taken from runtime `cwd` and should match `project_profile.yaml -> project.repo_root`.
- All code reads/writes must stay inside the current repository.
- Decoupling baseline:
  - Prefer loading project-scoped runtime settings from `project_profile.yaml`.
  - If a profile key is missing, use existing rules in this file as fallback.

## 2) Spec Path (single source of truth)
- Project profile: `project_profile.yaml` (project-specific mapping for paths/commands/exclusions)
- Master spec: `master_spec/master_spec.md`
- Skill spec: `master_spec/skill_spec/skill_spec.md`
- Skill catalog: `master_spec/skill_spec/skill_catalog.md`
- Chat spec: `master_spec/chat_spec/chat_spec.md`
- Chat index: `master_spec/chat_spec/chat_index.md`
- Initial spec: `master_spec/initial_spec/initial_spec.md`
- Template boundary spec: `master_spec/initial_spec/governance_template_boundary.md`
- Comment spec: `master_spec/comment_spec/comment_spec.md`
- Read audit spec: `master_spec/read_audit_spec/read_audit_spec.md`
- Read audit template: `master_spec/read_audit_spec/READ_AUDIT_TEMPLATE.md`
- Coding spec: `master_spec/coding_spec/coding_spec.md`
- Environment spec: `master_spec/env_spec.md`
- Acceptance profiles: `master_spec/acceptance_spec/*.acceptance.md` (indexed by `master_spec/acceptance_spec/acceptance_catalog.md`)
- Flow catalog: `master_spec/flow_spec/flow_catalog.md`
- Procedure catalog: `master_spec/procedure_spec/procedure_catalog.md`
- Algorithm flow specs: `master_spec/flow_spec/*.flow.md` (indexed by flow catalog)
- Procedure specs: `master_spec/procedure_spec/*.procedure.md` (indexed by procedure catalog)
- Subproject specs: `<subproject>/Spec/Spec.md`
- Header specs: `<subproject>/Spec/Headers/*.spec.md`
- Task specs: `task/**` (for example: `task/EV0_MultiFrame_Fusion.md`)
- Task governance spec: `master_spec/task_spec/task_spec.md`

## 3) Mandatory Read Order (before any code change)
1. `AGENTS.md` (this file)
2. `project_profile.yaml` (if exists)
3. `master_spec/master_spec.md`
4. `master_spec/skill_spec/skill_spec.md`
5. `master_spec/skill_spec/skill_catalog.md`
6. `master_spec/chat_spec/chat_spec.md`
7. `master_spec/chat_spec/chat_index.md`
8. `master_spec/initial_spec/initial_spec.md`
9. `master_spec/initial_spec/governance_template_boundary.md`
10. `master_spec/comment_spec/comment_spec.md`
10a. `master_spec/read_audit_spec/read_audit_spec.md`
11. `master_spec/coding_spec/coding_spec.md`
12. `master_spec/env_spec.md`
13. `master_spec/task_spec/task_spec.md`
14. Classify task type using Master Spec catalogs:
   - Algorithm flow change:
     - read `master_spec/flow_spec/flow_catalog.md`
     - then read matching `master_spec/flow_spec/*.flow.md`
   - Procedure/release/execution flow:
     - read `master_spec/procedure_spec/procedure_catalog.md`
     - then read matching `master_spec/procedure_spec/*.procedure.md`
15. Matching task spec under `task/`
16. Acceptance binding:
   - read `master_spec/acceptance_spec/acceptance_catalog.md`
   - then read the selected `master_spec/acceptance_spec/*.acceptance.md`
17. Matching header spec(s) in `<subproject>/Spec/Headers/` for touched `.h/.cpp`
18. Matching subproject spec (`<subproject>/Spec/Spec.md`)
19. Target module headers and implementation files
20. Existing test entry declared in `project_profile.yaml -> paths.test_entry`

## 4) Conflict Priority (if specs disagree)
1. `AGENTS.md` for workflow/safety boundaries
2. `master_spec/master_spec.md` for global governance constraints
3. `master_spec/skill_spec/skill_spec.md` for skill registration/pipeline governance
4. `master_spec/skill_spec/skill_catalog.md` for project skill inventory
5. `master_spec/chat_spec/chat_spec.md` for session/task resume policy and chat-level gates
6. `master_spec/chat_spec/chat_index.md` for active task index and project-global state
7. `master_spec/initial_spec/initial_spec.md` for repository bootstrap/initialization governance
8. `master_spec/initial_spec/governance_template_boundary.md` for template-vs-instance ownership decisions
9. `master_spec/comment_spec/comment_spec.md` for comment coverage/review governance
9a. `master_spec/read_audit_spec/read_audit_spec.md` for per-task source read snapshot governance (audit trail only; does not introduce a second blocking gate beyond comment_spec)
10. `master_spec/coding_spec/coding_spec.md` for coding style/memory-lifecycle governance
11. `master_spec/env_spec.md` for environment/tool-path resolution
12. `master_spec/task_spec/task_spec.md` for task lifecycle/decomposition/review-gate rules
13. `master_spec/acceptance_spec/*.acceptance.md` (selected by acceptance catalog) for acceptance criteria and pass/fail gates
14. Flow/procedure spec (`master_spec/flow_spec/**` or `master_spec/procedure_spec/**`) selected via catalogs for routing and execution path
15. Task spec (`task/**`) for task-specific scope/plan/deliverables
16. Header spec (`<subproject>/Spec/Headers/*.spec.md`) for API/interface contract
17. Subproject spec (`<subproject>/Spec/Spec.md`) for module boundaries

## 5) Build/Acceptance Routing
- Resolve tools and environment via `master_spec/env_spec.md`.
- Resolve build/runtime command facts from:
  1. `project_profile.yaml`
  2. selected acceptance profile
  3. fallback commands only when both sources are missing
- Build/runtime handshake details, command binding, and acceptance gates are owned by:
  - `master_spec/task_spec/task_spec.md`
  - `master_spec/acceptance_spec/*.acceptance.md`
  - `master_spec/procedure_spec/*.procedure.md`
- `AGENTS.md` must not become a second copy of executable command bodies.

## 6) Forbidden Out-of-Scope Directories
- Any path outside the current repository root resolved at runtime (`cwd` and `project_profile.yaml -> project.repo_root`).
- User profile/private dirs (examples): `C:\Users\*`, `D:\*`, network shares, removable drives
- System-sensitive dirs (examples): `C:\Windows\*`, `C:\Program Files\*`

## 6.1) Third-Party Review/Edit Exclusion
- Unless user explicitly overrides in the same task, do not review or edit code under the project-specific third-party paths declared in `project_profile.yaml -> exclusions.third_party`.
- For flow analysis, those configured paths may be treated as black-box dependencies only.

## 7) Forbidden Commands / Behaviors
- Destructive VCS/file commands unless explicitly authorized:
  - `git reset --hard`
  - `git checkout -- <file>`
  - `rm -rf` / `Remove-Item -Recurse -Force` on broad paths
- Privilege escalation, external network download/install, or executing unknown binaries/scripts without explicit approval.
- Editing generated binaries/model blobs directly (`*.bin`, `*.a`, `*.lib`, `*.dll`, `*.exe`).

## 8) Change Discipline
- Make minimal, targeted edits only.
- Do not modify unrelated files.
- Keep changes consistent with existing coding style and module boundaries.
- Report build/test command results in the final update.
- Flow-spec-first: if a code change modifies behavior in any function that is part of a documented flow in `master_spec/flow_spec/flow_catalog.md`, update the matching flow spec before writing implementation code. This is the default governance rule and must not require user re-confirmation each session.
- Flow entry points are confirmed by the user. The agent traces the complete function-level call chain from the confirmed entry and documents it in the matching `master_spec/flow_spec/*.flow.md` before code changes are made.
- Flow discovery: if a code-change task starts and `flow_catalog.md` has no active entries, or the modified files are not covered by any existing flow, run `skill/flow-discovery` before implementation. If the call-graph tool is not configured, prompt the user to set up `call_graph` in `project_profile.yaml`.
- Call-graph-first: when the agent needs to understand function call relationships (debugging, impact analysis, refactoring, tracing), it must use `skill/call-graph` instead of manually reading code to trace calls. Fall back to manual reading only if the tool is not installed and the user declines to install it.
- Governance propagation: after any change to files under `master_spec/`, apply the bootstrap/starter propagation check defined in `master_spec/initial_spec/initial_spec.md §7` before considering the change complete.

## 9) Skill Routing
- Registration source:
  - `project_profile.yaml` -> `skills.registry`
  - `project_profile.yaml` -> `skills.release_pipeline`
  - `master_spec/skill_spec/skill_spec.md`
  - `master_spec/skill_spec/skill_catalog.md`
- Do not hardcode project skill names or pipeline steps in `AGENTS.md`.
- Trigger rules, pipeline ordering, push confirmation gates, and failure-stop behavior are owned by:
  - `master_spec/skill_spec/skill_spec.md`
  - `master_spec/procedure_spec/*.procedure.md`
  - each active `skill/*/SKILL.md`
- Safety rules in section `6/7` still apply globally.

## 10) Task Governance Routing
- Task lifecycle, task file gates, replan write-back, progress-output format, effect-quality overlays, and post-task rule reconfirmation are owned by `master_spec/task_spec/task_spec.md`.
- Acceptance profile selection is owned by `master_spec/acceptance_spec/acceptance_catalog.md`.
- Release completion after acceptance is owned by `master_spec/procedure_spec/*.procedure.md`.
- `AGENTS.md` only requires that these gates be followed; detailed task mechanics must stay in task/acceptance/procedure specs instead of being duplicated here.

## 10.1) Session Resume And Initialization Routing
- Session continuity and `chat_index.md` ownership belong to `master_spec/chat_spec/chat_spec.md`.
- Repository bootstrap and governance-root initialization belong to `master_spec/initial_spec/initial_spec.md`.

## 10.2) Comment Governance Routing
- Function-comment scope, `@codex-comment` template, review workflow, and `comment_status.md` updates are owned by `master_spec/comment_spec/comment_spec.md`.
- `AGENTS.md` requires compliance with comment governance but must not duplicate the detailed workflow text.

## 10.3) Spec Change Scoping Gate (Decoupling Protection)
- Any newly added requirement must be classified before writing:
  - `baseline constraint` (global reusable governance)
  - If a request does not explicitly specify which spec file to update, `AGENTS.md` must route/split the rule by governance content into the corresponding spec instead of keeping implementation detail rules in `AGENTS.md`.
  - `task-specific constraint` (only for current task/experiment/customer request)
- Default rule:
  - if scope is uncertain, classify as `task-specific constraint`.
  - do not promote to `master_spec/**` by default.
- Write location rules:
  - `baseline constraint` -> may be written to `master_spec/**` only when it is stable, reusable, and expected to apply across future tasks.
  - `task-specific constraint` -> must be written under `task/**` (or current task acceptance notes), not `master_spec/**`.
- Pollution prevention:
  - do not add experiment-only checkpoints, visualization formats, or temporary validation evidence requirements into `master_spec/task_spec/task_spec.md`.
  - do not turn one task's custom review criteria into global governance unless user explicitly requests globalization in the same session.
- If a wrong-scope change was written to `master_spec/**`, rollback that part immediately and keep the requirement in `task/**`.
- In execution updates, explicitly state classification outcome when adding new spec rules:
  - `SpecScopeDecision: baseline` or `SpecScopeDecision: task-specific`.

## 11) Documentation Language Policy
- All new or updated documentation files must be written in English.
- Scope includes: `master_spec/**`, `master_spec/flow_spec/**`, `master_spec/procedure_spec/**`, `master_spec/acceptance_spec/**`, `<subproject>/Spec/**`, and `task/**`.
- If an existing non-English section is touched, convert that section to English in the same change.

## 12) Self-Governance Rules

These rules govern the Wildpanda repository itself. They take effect after the v1.1.0 release.

### 12.1) PR-Only Policy
- The `master` branch is protected. All changes must be submitted via pull request.
- Direct pushes to `master` are prohibited after v1.1.0.
- Exception: the v1.1.0 release itself is the last direct push (transitional).

### 12.2) PR Requirements
Every pull request to Wildpanda must include:
1. A `CHANGELOG.md` entry under `## [Unreleased]` describing the change.
2. A `VERSION` bump (patch, minor, or major) if the PR is a release PR.
3. A `Co-Authored-By:` trailer in at least one commit identifying the contributor.

### 12.3) Contributor Tracking
- `CONTRIBUTORS.md` records all contributors.
- When a PR is merged, the contributor (from `Co-Authored-By`) must be added to `CONTRIBUTORS.md` if not already listed.
- The `governance-release` skill automates this during release PR preparation.

### 12.4) Version Semantics
- **Patch** (`x.y.Z`): typo fixes, formatting corrections, non-functional changes.
- **Minor** (`x.Y.0`): new spec sections, new fields, new skills, backward-compatible additions.
- **Major** (`X.0.0`): breaking changes to template-owned file structure, governance workflow, or sync protocol.

### 12.5) Self-Application
- Wildpanda itself follows the task lifecycle defined in `master_spec/task_spec/task_spec.md`.
- Changes to Wildpanda should be tracked via task files when the scope warrants it.

### 12.6) Release Process
- Releases are prepared via the `governance-release` skill.
- The skill creates a release PR. It never merges automatically.
- The maintainer reviews, merges the PR, and creates the version tag on GitHub.

### 12.7) Merge Authority
- Only the repository maintainer (or users with write access) may merge pull requests.
- Only the maintainer creates version tags on the merge commit.
- Automated merge or auto-tag is not permitted.

After all Agents file finished read, give "Agents loaded".