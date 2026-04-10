# New Project Bootstrap Task Template

## Purpose
- Standard task record for first-time repository adoption of this governance system.
- Use when a repository is instantiating governance structure, profile, and runtime status files from the reusable templates.

## Metadata
- Task name: `Governance_New_Project_Bootstrap`
- Owner:
- Date:
- Related flow/procedure: `master_spec/procedure_spec/New_Project_Governance_Bootstrap.procedure.md`
- Task mode: `single-task`
- Parent master task (for subtask): `not_applicable`
- Child subtasks (for single independent task): `not_applicable`
- Acceptance profile (required): `A1_Spec_Only`
- Acceptance reference (required): `master_spec/acceptance_spec/A1_Spec_Only.acceptance.md`
- Task review approval (required before implementation): `pending`
- Current Phase (state machine): `PlanCreated`
- Last Completed Step:
- Next Required Step:
- Blocking Condition: `none`

## Repository Facts To Instantiate
- Repository name:
- Repository id:
- Repository root:
- Build command facts:
- Runtime smoke command facts:
- Test entry inventory:
- Third-party exclusion paths:
- Skill registry:
- Release pipeline:

## Background And Goal
- Explain why this repository is adopting the governance system now.
- State the expected bootstrap result.

## Scope
- `AGENTS.md`
- `project_profile.yaml`
- `master_spec/**` governance roots needed by `master_spec/initial_spec/initial_spec.md`
- `task/`
- `task/Achieve/`
- runtime status files such as `master_spec/chat_spec/chat_index.md` and `master_spec/comment_spec/comment_status.md`

## Non-Scope
- Algorithm/library code changes
- Release execution
- Repository-specific feature tasks beyond governance initialization

## Replan Record (mandatory when replan is triggered)
- Replan Trigger: `not_triggered`
- Updated Objective: `not_applicable`
- Updated Scope (In):
  - `not_applicable`
- Updated Scope (Out):
  - `not_applicable`
- Hypotheses:
  1. Instantiating governance files from templates will let the repository complete the mandatory read order without missing-file fallback.
  2. Instantiating `project_profile.yaml` from the template will prevent accidental carry-over of another repository's instance values.
- Validation Matrix:
  1. `H1` -> verify required structure and template-owned files exist -> `task/<this bootstrap task>.md`
  2. `H2` -> verify `project_profile.yaml` and runtime status files were instantiated with repository facts -> `task/<this bootstrap task>.md`
- Acceptance Evidence Outputs:
  1. `project_profile.yaml`
  2. `master_spec/chat_spec/chat_index.md`
  3. `master_spec/comment_spec/comment_status.md`
  4. `task/<this bootstrap task>.md`

## Plan
1. Confirm bootstrap trigger and repository facts.
2. Create missing governance directories and template-owned files.
3. Instantiate repository-owned files from the appropriate templates.
4. Create runtime/task-state files.
5. Run `A1_Spec_Only` verification and record the result.

## Acceptance Criteria
1. Required governance roots from `master_spec/initial_spec/initial_spec.md` exist.
2. `project_profile.yaml` is instantiated from `master_spec/project_profile_template.yaml`.
3. Runtime/task-state files needed for normal operation exist.
4. The repository can complete the mandatory read order without bootstrap-time missing-file gaps.

## Validation
- Use `master_spec/acceptance_spec/A1_Spec_Only.acceptance.md`.
- Verify referenced paths exist.
- Verify no algorithm/library code files were modified.

## Risks
- Template files may still retain source-repository instance values if instantiation is incomplete.
- Repository-specific command facts may be guessed instead of confirmed.

## Execution Update
- Record what was created, instantiated, or intentionally left pending for repository-specific follow-up.

## Post-Execution Review (required)
- Actual change summary:
- Acceptance command results (exit code):
- Final acceptance conclusion: `pass` / `fail`
- Archive readiness: `yes` / `no`
- Task Conclusion (mandatory):
  - Outcome: `accepted` / `rejected` / `partial`
  - Decision: `continue` / `stop` / `rollback`
  - Key Evidence:
  - Root Cause Summary:
  - Risk Assessment: `low` / `medium` / `high`
  - Next Action: `none` / `<exact next step>`
