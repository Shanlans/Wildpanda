# Governance Template Boundary

## Metadata
- Path: `master_spec/initial_spec/governance_template_boundary.md`
- Owner: `Shanlan`
- Last updated: `2026-03-16`

## 1. Purpose
- Define which governance files are reusable templates and which files must be repository-instance specific.
- Prevent future repositories from reintroducing coupling by mixing stable agent rules with project-specific values.

## 2. Classification Rule
- `template-owned`
  - File content is expected to be reused across repositories with no or minimal wording changes.
- `instance-owned`
  - File content exists to describe one concrete repository, one concrete environment, or one concrete workflow inventory.
- `hybrid`
  - File structure is reusable, but some fields are repository-instance values and must be instantiated explicitly.

## 3. File Ownership Matrix

### 3.1 Template-Owned
- `master_spec/project_profile_template.yaml`
- `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_CHECKLIST.md`
- `master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md`
- `master_spec/task_spec/task_spec.md`
- `master_spec/comment_spec/comment_spec.md`
- `master_spec/coding_spec/coding_spec.md`
- `master_spec/chat_spec/chat_spec.md`
- `master_spec/initial_spec/initial_spec.md`
- `master_spec/skill_spec/skill_spec.md`
- `master_spec/acceptance_spec/ACCEPTANCE_PROFILE_TEMPLATE.md`
- `master_spec/acceptance_spec/ACCEPTANCE_CATALOG_TEMPLATE.md`
- `master_spec/procedure_spec/PROCEDURE_TEMPLATE.md`
- `master_spec/procedure_spec/PROCEDURE_CATALOG_TEMPLATE.md`
- `master_spec/procedure_spec/New_Project_Governance_Bootstrap.procedure.md`
- `master_spec/procedure_spec/New_Project_Instance_Generation.procedure.md`
- `master_spec/procedure_spec/Bootstrap_Skill_Runtime_Exposure.procedure.md`
- `master_spec/flow_spec/FLOW_TEMPLATE.md`
- `master_spec/flow_spec/FLOW_CATALOG_TEMPLATE.md`
- `master_spec/skill_spec/SKILL_CATALOG_TEMPLATE.md`
- `master_spec/task_spec/TASK_TEMPLATE.md`
- `master_spec/task_spec/MASTER_TASK_TEMPLATE.md`
- `master_spec/task_spec/NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md`
- `master_spec/read_audit_spec/read_audit_spec.md`
- `master_spec/read_audit_spec/READ_AUDIT_TEMPLATE.md`
- `master_spec/initial_spec/governance_template_boundary.md`
- `skill/bootstrap-governance/SKILL.md`
- `skill/governance-sync/SKILL.md`
- `skill/governance-contribute/SKILL.md`
- `skill/governance-release/SKILL.md`

### 3.2 Instance-Owned
- `project_profile.yaml`
- `master_spec/master_spec.md`
- `master_spec/env_spec.md`
- `master_spec/coding_spec/coding_spec_instance.md` (project-specific coding rules, e.g., toolchain restrictions, resource class lists)
- `master_spec/skill_spec/skill_catalog.md`
- `master_spec/acceptance_spec/acceptance_catalog.md`
- `master_spec/flow_spec/flow_catalog.md`
- `master_spec/procedure_spec/procedure_catalog.md`
- `master_spec/acceptance_spec/A0_Documentation_Only.acceptance.md`
- `master_spec/acceptance_spec/A1_Spec_Only.acceptance.md`
- `master_spec/acceptance_spec/A2_Algorithm_Library_Change.acceptance.md`
- `master_spec/acceptance_spec/A3_Release_Procedure.acceptance.md`
- `master_spec/skill_spec/skill_catalog.md`
- `master_spec/flow_spec/*.flow.md`
- `master_spec/procedure_spec/*.procedure.md`
- `master_spec/acceptance_spec/*.acceptance.md`
- `<subproject>/Spec/Spec.md`
- `<subproject>/Spec/Headers/*.spec.md`

### 3.3 Runtime/Task-State Files
- `master_spec/chat_spec/chat_index.md`
- `master_spec/comment_spec/comment_status.md`
- `task/**`
- These files are not templates. They are runtime state, review state, or task execution records.

## 4. Field-Level Boundary For Hybrid Use

### 4.1 `AGENTS.md`
- Classification: `hybrid`
- Template-owned content:
  - read order
  - conflict priority
  - routing rules to the owning specs
  - safety boundaries
  - scoping/decoupling discipline
- Instance-owned content:
  - repository display name in title
  - any project-root path
  - any project file inventory
  - any project-specific exclusion list
  - any command body
- Rule:
  - `AGENTS.md` should route to the owning spec/profile and must not duplicate instance values that already exist elsewhere.

### 4.2 `project_profile.yaml`
- Classification: `instance-owned`
- Owns:
  - `project.id`
  - `project.name`
  - `project.repo_root`
  - concrete spec paths for this repository
  - build/runtime commands
  - skill registry and release pipeline
  - exclusions
  - file inventory such as test entry

### 4.3 `master_spec/env_spec.md`
- Classification: `instance-owned`
- Owns:
  - actual tool paths
  - actual environment variables
  - local machine/repository environment facts
- Template note:
  - its section layout is reusable, but the values are never template-owned.

### 4.4 `master_spec/master_spec.md`
- Classification: `instance-owned`
- Owns:
  - repository-level boundary statement for the current project
  - platform baseline for the current project
  - links to the current repository governance documents
- Must not own:
  - task-specific evidence formats
  - duplicated executable command bodies
  - temporary experiment rules

## 5. Migration Rule For Future Decoupling
- If a rule/value mentions a concrete path, binary, project name, module list, exclusion list, or command line, assume `instance-owned` first.
- If a rule/value describes reusable behavior across future repositories, assume `template-owned` first.
- If uncertain, keep the behavioral rule in a template spec and move the concrete values into `project_profile.yaml`.

## 6. Bootstrap Rule For New Repository Setup
- Recommended order when instantiating a new repository from this governance system:
  1. copy template-owned governance files,
  2. create a new `project_profile.yaml`,
  3. instantiate acceptance/procedure/flow instance files from the corresponding template skeletons,
  4. instantiate the remaining instance-owned specs from project facts,
  5. update `AGENTS.md` to point only to the new repository instance data,
  6. create empty runtime/task-state files.

## 7. Anti-Coupling Checklist
- Before adding a new rule, ask:
  1. Is this a reusable behavior or a project fact?
  2. Does a concrete value already exist in `project_profile.yaml`?
  3. Am I duplicating a command body that already lives in profile/acceptance/procedure?
  4. Is this requirement task-specific and therefore supposed to live in `task/**` instead?

## 8. Change Log
- 2026-03-16: Initial template-boundary definition created for agent-system template reuse and decoupling.
- 2026-04-08: Added `master_spec/read_audit_spec/read_audit_spec.md` and `READ_AUDIT_TEMPLATE.md` to template-owned list. Task: `task/GovernanceAuditCleanup_2026_04_08.md`.
- 2026-04-10: Added `governance_template_boundary.md`, `bootstrap-governance`, `governance-sync`, `governance-contribute`, `governance-release` skill paths to template-owned list. Task: `Wildpanda_v1.1.0_GovernanceSkills`.
