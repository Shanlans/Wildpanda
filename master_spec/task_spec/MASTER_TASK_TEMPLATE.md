# Master Task Template

## Metadata
- Task name:
- Owner:
- Date:
- Related flow/procedure:
- Task mode: `multi-task-master`
- Acceptance profile (required): `A0_Documentation_Only` / `A1_Spec_Only` / `A2_Algorithm_Library_Change` / `A3_Release_Procedure`
- Acceptance reference (required): `master_spec/acceptance_spec/<profile>.acceptance.md`
- Task review approval (required before implementation): `pending` / `approved`
- Current Phase (state machine): `PlanCreated` / `ReviewApproved` / `ImplementationDone` / `AcceptancePassed` / `ProcedureCompleted` / `PostReviewUpdated` / `Archived`
- Last Completed Step:
- Next Required Step:
- Blocking Condition: `none` / `<reason>`

### Runtime State (per chat_spec §7.1 — task file is authoritative)
<!-- Same fields as TASK_TEMPLATE. For a master task, Acceptance State is the
     **aggregate** of subtask states: `passed` only when ALL subtasks are
     `passed` or `not_applicable`. -->
- Acceptance State: `not_run` / `passed` / `partial_pass` / `failed` / `not_applicable`
- Acceptance Evidence Path: `task/<this-master-task>.md`
- Last Build Exit Code: `n/a`
- Last Runtime Exit Code: `n/a`
- Release Pipeline State: `not_started` / `in_progress` / `blocked` / `completed` / `not_applicable`
- Comment Review State: `clear` / `pending_review_exists` / `blocked` / `not_applicable`
- Comment Review Decision Latest: `not_applicable`
- Archive Ready: `no` / `yes` / `not_applicable`
- Last Verified At: `<YYYY-MM-DD>`
- Owning Chat ID: `<chat-YYYYMMDD-HHMM-xxx>` / `grandfathered`
- Last Heartbeat At: `<YYYY-MM-DDTHH:MM>` / `n/a`

## Background And Goal
- Why this master task exists.
- Final expected outcome across all subtasks.

## Global Scope
- Overall in-scope modules/files.

## Global Non-Scope
- Explicit exclusions.

## Decomposition Strategy
- Why decomposition is needed (risk/complexity/consistency/validation).
- How work is partitioned.

## Subtask Index
| Subtask ID | Subtask file path | Scope summary | Acceptance profile | Status |
|---|---|---|---|---|
| ST-01 | task/<SubTask1>.md |  |  | `pending` |
| ST-02 | task/<SubTask2>.md |  |  | `pending` |

## Master Acceptance Criteria
1. All subtasks are completed.
2. All required acceptance checks pass.
3. Cross-subtask consistency is confirmed.

## Validation
- Global validation commands/checks if required.

## Risks
- Cross-subtask dependency and regression risks.

## Execution Update
- Ongoing notes and status.

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

