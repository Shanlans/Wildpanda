# Task Template

## Metadata
- Task name:
- Owner:
- Date:
- Related flow/procedure:
- Task mode: `single-task` / `multi-task-subtask`
- Parent master task (for subtask): `task/<MasterTask>.md` / `not_applicable`
- Child subtasks (for single independent task): `not_applicable`
- Acceptance profile (required): `A0_Documentation_Only` / `A1_Spec_Only` / `A1_Config_Only_Change` / `A2_Algorithm_Library_Change` / `A3_Release_Procedure`
- Acceptance reference (required): `master_spec/acceptance_spec/<profile>.acceptance.md`
- Task review approval (required before implementation): `pending` / `approved`
- Current Phase (state machine): `PlanCreated` / `ReviewApproved` / `ImplementationDone` / `AcceptancePassed` / `ProcedureCompleted` / `PostReviewUpdated` / `Archived`
- Last Completed Step:
- Next Required Step:
- Blocking Condition: `none` / `<reason>`

### Runtime State (per chat_spec §7.1 — task file is authoritative)
<!-- These fields are the single source of truth for per-task runtime state (per chat_spec §7.1).
     chat_index.md holds only a thin phase snapshot for cross-task overview. -->
- Acceptance State: `not_run` / `passed` / `partial_pass` / `failed` / `not_applicable`
- Acceptance Evidence Path: `task/<this-task>.md`
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
- Why this task exists.
- Expected outcome.

## Scope
- In-scope files/modules.

## Non-Scope
- Explicitly excluded items.

## Replan Record (mandatory when replan is triggered)
- Replan Trigger: `not_triggered` / `<what changed>`
- Updated Objective: `not_applicable` / `<updated objective>`
- Updated Scope (In):
  - `not_applicable` / `<in-scope items>`
- Updated Scope (Out):
  - `not_applicable` / `<out-of-scope items>`
- Hypotheses:
  1. `not_applicable` / `<hypothesis-1>`
  2. `not_applicable` / `<hypothesis-2>`
- Validation Matrix:
  1. `<hypothesis id>` -> `<method>` -> `<evidence artifact path>`
  2. `<hypothesis id>` -> `<method>` -> `<evidence artifact path>`
- Acceptance Evidence Outputs:
  1. `<csv/log/image/md path>`
  2. `<csv/log/image/md path>`

## Bug Type (for debug tasks)
- `functional` / `rule` / `not_applicable`

## Error Analysis (required for debug tasks)
- Finding ID:
- Error type (`functional` / `rule`):
- Root-cause mechanism:
- Trigger condition:
- Impact scope:
- Evidence (`file:line`):
- Reproducibility notes:
- Fix boundary:

## Plan
1.
2.
3.

## Pass/Fail Criteria
<!-- Each criterion must be measurable, falsifiable, and attributed. Required per task_spec §16.1. -->
| # | Category | Criterion | Pass Threshold | Actual | Result |
|---|---|---|---|---|---|
| 1 | Build | Full solution build exit code | = 0 | — | — |
| 2 | Correctness | Runtime smoke test exit code | = 0 | — | — |
| 3 | Performance | `<metric>` | `<threshold>` | — | — |

## Validation
- Commands/checks from selected acceptance profile.

## Read Audit
<!-- Required for code-change tasks (acceptance profile A2/A3) per master_spec/read_audit_spec/read_audit_spec.md.
     For doc/spec/config-only tasks, set the non-applicable status below.
     Field skeleton lives in master_spec/read_audit_spec/READ_AUDIT_TEMPLATE.md. -->
- task_ref: `task/<this-task>.md`
- last_updated_at: `<YYYY-MM-DD>`
- read_purpose (default): `<analysis | debug | validation | implementation reference | call-chain trace>`

### Read Set
| # | Path | Range / Function | Purpose | Read Trigger Outcome |
|---|---|---|---|---|
| 1 | | | | |

### Non-Applicable Status (use only when applicable)
- `read_audit: not_applicable_doc_only` — task acceptance profile is `A0` / `A1_Spec_Only` / `A1_Config_Only_Change`
- `read_audit: not_applicable_no_source_read` — no in-repo source file was read for this task
- `read_audit: not_applicable_pre_adoption` — task created before `2026-04-08` adoption date

## Risks
- Potential regressions and mitigations.

## Execution Update
- Ongoing notes and status.

## Post-Execution Review (required)
- Actual change summary:
- Acceptance command results (exit code):
- Final acceptance conclusion: `pass` / `fail` / `partial`
- Archive readiness: `yes` / `no`

### Failure Disposition Record (required if any criterion FAIL — per task_spec §16.3)
- FailedCriteria:
  - Criterion #: `<criterion text>` | Expected: `<threshold>` | Actual: `<value>`
- RCADisposition: `RCA-inline` / `RCA-subtask` / `Criterion-revision` / `Known-limitation`
- RCAEvidence: `<measurements, file:line, timing breakdown, etc.>`
- RCAConclusion: `<one-sentence mechanism>`
- UserDispositionApproval: `pending` / `approved by <user> on <date>`

### Task Conclusion (mandatory)
- Outcome: `accepted` / `rejected` / `partial`
- Decision: `continue` / `stop` / `rollback`
- Key Evidence:
- Root Cause Summary:
- Risk Assessment: `low` / `medium` / `high`
- Next Action: `none` / `<exact next step>`
