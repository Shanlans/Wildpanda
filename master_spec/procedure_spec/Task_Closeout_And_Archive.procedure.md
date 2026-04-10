# Procedure Spec: Task Closeout And Archive

## Metadata
- Procedure name: `Task_Closeout_And_Archive`
- Entry: task closeout after implementation/release completion
- Path: `master_spec/procedure_spec/Task_Closeout_And_Archive.procedure.md`
- Last updated: 2026-03-17

## Template Binding
- Template skeleton: `master_spec/procedure_spec/PROCEDURE_TEMPLATE.md`
- Repository classification: `repository instance procedure`

## When To Use
- Any tracked task reaches closeout after:
  - acceptance passes for spec-only or non-code tasks, or
  - release procedure completes for code-change tasks.

## Procedure Goal
- Standardize the last-mile closeout work so post-review, status synchronization, and archive movement are done in a consistent order.

## Pipeline
1. Refresh the active task file to `PostReviewUpdated`:
   - Fill all empty fields in `Post-Execution Review` (Actual change summary, Acceptance command results, Final acceptance conclusion, Archive readiness).
   - If any Pass/Fail criterion is FAIL, confirm that `FailedCriteria`, `RCADisposition`, `RCAEvidence`, `RCAConclusion`, and `UserDispositionApproval` are all non-empty and `UserDispositionApproval` ≠ `pending`.
   - Confirm `Task Conclusion` block is complete (all 6 mandatory fields per task_spec §14).
2. Synchronize `master_spec/chat_spec/chat_index.md` with the `PostReviewUpdated` state.
3. Run the pre-archive self-check (task_spec §13) and record each check result explicitly in task post-review:
   - [ ] Required acceptance profile passed with command exit codes recorded.
   - [ ] For code-change tasks: standard completion procedure (`ProcedureCompleted`) is recorded; for cfg-only/spec-only tasks: explicitly note `ProcedureCompleted: not_applicable`.
   - [ ] Master/subtask statuses synchronized (or `not_applicable`).
   - [ ] Pending comment-review items explicitly acknowledged or `not_applicable`.
   - [ ] `Current Phase` is `PostReviewUpdated` at this point.
   - Hard gate: any unchecked item blocks archive.
4. If all checks pass, move the task file to `task/Achieve/`.
5. Update task `Current Phase` to `Archived` and synchronize `master_spec/chat_spec/chat_index.md`:
   - Set `active_task: none`, `task_phase: Archived`, `archive_ready: yes`.

## Pre-Archive Blocking Rules (Hard Gates)
- Archive is forbidden if `Post-Execution Review` contains any empty mandatory field.
- Archive is forbidden if any criterion is FAIL and `UserDispositionApproval` is `pending` or missing.
- Archive is forbidden if `Current Phase` is not `PostReviewUpdated` at step 3.
- Archive is forbidden if `Task Conclusion` block is missing or any of its 6 fields is blank.

## Command/Skill Binding Rule
- This procedure is governance-driven and usually does not require repository build commands.
- If a closeout step must be committed/pushed, that commit must already respect the release procedure gates for commit-message approval and final-status synchronization.

## Output Requirements
- The task file contains a closeout-ready `PostReviewUpdated` state before archive.
- `master_spec/chat_spec/chat_index.md` is synchronized both before and after archive.
- Pre-archive self-check result is explicit in task post-review.
- Archived tasks live only under `task/Achieve/`.
- Any pending comment-review items are explicitly acknowledged in the task closeout record before archive.

## Change Log
- 2026-03-17: Added dedicated closeout/archive procedure to reduce post-release drift and standardize archive sequencing.

