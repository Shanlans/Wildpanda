# Task Spec Governance

## Metadata
- Path: `master_spec/task_spec/task_spec.md`
- Owner: Shanlan
- Last updated: 2026-03-03

## 1. Purpose
- Define task-document governance in one centralized location under `master_spec/`.
- Keep task planning, review gates, decomposition, and archive rules stable and reusable.

## 2. Task Classification
1. `single-task`
- Scope is small and coherent; one task file is sufficient.

2. `multi-task`
- Scope is large/complex; must use one master task plus subtasks.

## 3. Prompt Classification And Required Actions
1. Existing flow modification
- Create/update task file under `task/`.
- Set `Acceptance profile` and `Acceptance reference` from `master_spec/acceptance_spec/acceptance_catalog.md`.
- Read mapped flow spec and indexed subproject/header specs.
- Update spec/code as needed and validate by acceptance profile.

2. New flow creation
- Create task file under `task/`.
- Create/register new flow spec in `master_spec/flow_spec/` and update `master_spec/flow_spec/flow_catalog.md`.
- Set acceptance binding and complete spec/code updates.

3. Procedure task
- Follow mapped procedure spec in `master_spec/procedure_spec/`.
- If outputs change algorithm behavior/interface/state contract, update related specs.

4. Debug/diagnostic task
- Create/update task file with symptom, expected vs actual, and suspected scope.
- Classify bug type before deep analysis:
  - `functional`
  - `rule`
- Provide concrete root-cause evidence (`file:line`) before fix proposal.
- Tag each finding with bug type.
- For each finding, document mandatory debug review fields:
  - error type (`functional` / `rule`)
  - root-cause mechanism (how data/control flow leads to failure)
  - trigger condition (input/state/thread timing)
  - impact scope (crash/data corruption/wrong output/perf stall)
  - concrete evidence (`file:line`) and reproducibility notes.

5. Effect-quality task
- Trigger when user request is primarily about image/video quality artifacts, visual style mismatch, or competitor quality comparison (for example: halo, banding, layering, transition roughness, color cast).
 - Mandatory interaction gates (strict order):
  1. Provide root-cause analysis or root-cause analysis method first (with observable evidence path).
  2. Stop and wait for user conclusion on root cause.
  3. Provide solution options and validation method (A/B criteria, test input, expected change direction).
  4. Before collecting user validation conclusion, run mandatory reliability gates for each selected solution:
    - Path-hit verification: prove the modified code path is executed in the effective runtime branch (for example with branch logs/parameter logs/intermediate artifacts).
    - Low-strength A/B: run a small-strength variant first and compare with baseline to verify direction and side effects.
  5. Stop and wait for user validation conclusion.
  6. If validation is not successful, revert to pre-change baseline code.
  7. After root-cause stage, remove temporary force-debug or force-disable code that is not part of final approved design.
  8. If validation is successful, execute full required completion procedure and acceptance flow.
- Task decomposition rule for effect-quality tasks:
  - Agent must first decide `single-task` vs `multi-task` based on scope/risk/verification load.
  - If work spans multiple independent stages or high uncertainty, use `multi-task` with one master task and stage subtasks.
  - At minimum, stage responsibilities must be explicitly documented:
    1. Root-cause analysis stage
    2. Solution validation stage
    3. Solution implementation stage

## 3.1 Mandatory Task-Governance Decision Handshake
- Before any technical analysis/implementation, agent must explicitly output one decision line:
  - `TaskGovernanceDecision: continue-tracked-task`
  - `TaskGovernanceDecision: new-task-required`
  - `TaskGovernanceDecision: non-task-request`
- Decision basis must be stated in one short sentence:
  - whether the user request maps to an existing task under `task/**`,
  - whether scope changed enough to require a new task/subtask.
- If decision is `new-task-required`, agent must create/update task file and get review approval before execution.
- If decision is `continue-tracked-task`, agent must name the task file being continued.

## 3.2 Mandatory Build Spec-Binding Handshake
- For any request that executes build/runtime/acceptance commands, agent must output one binding line before command execution:
  - `BuildSpecBinding: env_spec=<path>, acceptance_profile=<name>, command_source=<project_profile|acceptance_spec|fallback>`
- Command execution is blocked if the binding line is not provided first.
- Binding rule details:
  1. tool path resolution must come from `master_spec/env_spec.md` first,
  2. acceptance profile must be explicitly named (for example `A2_Algorithm_Library_Change`),
  3. command source must follow the active entry policy in `AGENTS.md` and the canonical sources defined by `project_profile.yaml` plus acceptance spec.

## 3.2.1 Keyword `???` Strict Execution Contract (Mandatory)
- If user request contains keyword `???`, agent must execute a fixed governance pipeline and must not reinterpret/simplify.
- Required ordered steps (all mandatory):
  1. `RuleReconfirmation`
  2. `TaskGovernanceDecision`
  3. If replan is triggered: task-file write-back + user approval
  4. `BuildSpecBinding`
  5. Full acceptance-required build
  6. Runtime smoke/acceptance run by bound command source
  7. Task-file post-review write-back (commands, exit codes, evidence, conclusion)
  8. Progress/status output with `Step Done` / `Step Pending` / `Why Blocked`
- Hard gate:
  - Any step missing/reordered means `???` not satisfied.
  - Command simplification, partial execution, or ad-hoc interpretation is forbidden.
  - Build/runtime command execution is forbidden before required handshake lines are explicitly printed.
## 3.3 Mandatory Replan And Task-File Write-Back Gate
- Trigger condition (any one matched):
  1. user updates objective/scope/constraint after a task is already in progress,
  2. user changes validation method, acceptance criteria, or evidence requirements,
  3. agent discovers prior plan no longer matches user intent.
- Required sequence (strict):
  1. output `TaskGovernanceDecision` (`continue-tracked-task` / `new-task-required`) with one-sentence basis,
  2. update task markdown (`task/**`) with replan content before technical execution,
  3. request user review/approval of the updated task plan,
  4. after approval, continue technical execution.
- Replan write-back minimum fields (must be present in task file):
  - `Replan Trigger`
  - `Updated Objective`
  - `Updated Scope (In/Out)`
  - `Hypotheses`
  - `Validation Matrix`
  - `Acceptance Evidence Outputs`
  - `Current Phase`
  - `Next Required Step`
- Hard gate:
  - If replan is required but task file is not updated, technical analysis/code edits/build-runtime commands are forbidden.
  - Chat-only planning text does not count as replan completion.

## 4. Mandatory Task Lifecycle
1. Plan
- Create/update task document before implementation.

2. Review gate
- Ask user to review task plan and obtain explicit approval.

3. Execute
- Implement changes according to approved scope.

4. Post-review
- Update task file with actual changes, acceptance commands, exit codes, and pass/fail conclusion.
- Update task file with a mandatory `Task Conclusion` block using the fixed template in section `14`.

5. Archive
- Move task to `task/Achieve/` only when required acceptance profile is fully satisfied.

### Effect-quality task lifecycle overlay (mandatory)
- This overlay is applied in addition to normal lifecycle gates.
- Required checkpoints to record in task file:
  - `RootCauseHypothesis`
  - `UserRootCauseConclusion`
  - `ProposedSolutionAndValidationPlan`
  - `PathHitVerification`
  - `LowStrengthABResult`
  - `UserValidationConclusion`
  - `RollbackStatus` (`reverted` / `not-needed`)
  - `TemporaryDebugChangeCleanup`
- Any missing checkpoint blocks transition to `AcceptancePassed`.

### Root-Cause Register Gate (mandatory for debug/effect-quality tasks)
- When root-cause analysis is performed, task file must include a `Root Cause Register` section.
- Each root-cause item must include all required fields:
  - `Phenomenon`
  - `Root Cause Hypothesis`
  - `Proposed Fix`
  - `HitStatus` (`hit` / `miss` / `pending`)
  - `Evidence` (artifact path and/or `file:line`)
- Update timing:
  - register item must be written before implementing a fix for that item,
  - `HitStatus` must be updated after validation.
- Hard gate:
  - if a fix is implemented without a corresponding root-cause register item, task cannot transition to `ImplementationDone` or later states.
  - if `HitStatus` remains `pending` after validation step completion, task cannot transition to `AcceptancePassed`.

### Root-Cause Scope Escalation Gate (subtask split)
- If root-cause fix scope is large/high-risk, agent must split into a child subtask before code implementation.
- Escalation triggers (any one):
  1. expected touched code area is cross-module or includes more than one primary pipeline stage,
  2. expected behavior risk is medium-or-above and requires staged validation,
  3. rollback surface is large enough that isolated acceptance is needed.
- Required actions when triggered:
  1. update parent task with split reason and child-subtask linkage,
  2. create child task under `task/` with explicit scope and acceptance binding,
  3. obtain user review approval for subtask before implementation.
- Hard gate:
  - when escalation trigger is met, direct implementation in the parent task is forbidden.

### Effect-quality stage acceptance (mandatory)
- Effect-quality work must define stage-level acceptance, not only final acceptance.
- Required stage acceptance outputs:
1. Root-cause analysis stage
  - Acceptance criterion: root-cause conclusion is confirmed as hit/miss by user.
  - Required record: evidence path + `UserRootCauseConclusion`.
2. Solution validation stage
  - Acceptance criterion: user provides explicit validation conclusion (accepted/rejected/partial).
  - Required record: `PathHitVerification`, `LowStrengthABResult`, `UserValidationConclusion`.
3. Solution implementation stage
  - Acceptance criterion: basic required acceptance profile passes (for code change usually A2) and subjective quality conclusion is recorded.
  - Required record: acceptance commands + exit codes + subjective conclusion.
- If a stage fails acceptance, do not advance to next stage; update task/subtask and rework or rollback per rules.
- Hard gate:
  - If solution-validation stage is not explicitly `accepted` by user, solution-implementation stage is forbidden.
  - `partial` or `rejected` validation conclusion cannot unlock implementation stage.
  - If repeated experiments for the current solution direction keep failing, Agent must ask user whether to mark this direction as `failed`.
  - Agent can move to the next experiment direction only after user explicitly confirms failure of the current direction.

### Effect-quality task mandatory pseudocode and A/B test plan (mandatory before stage 2)
- Before any code implementation, the task file must contain a dedicated pseudocode section and a detailed A/B test plan section.
- Required content for pseudocode section:
  - For each independent algorithm change (P1, P2, P3, ...), a named pseudocode block with:
    - Input/output declaration
    - Step-by-step logic including all branching conditions and formulae
    - At least one numerical verification example showing expected output for a known input
    - Edge case/boundary notes (e.g., K=0 fallback, clamp, OMP threading boundary)
- Required content for detailed A/B test plan:
  - A test matrix table listing all configs (BL / V1 / V1b / V2a / ...) with columns: parameter values per improvement, status
  - Per-config: specific test inputs and purpose
  - Per-config: explicit pass/fail criteria (observable artifact or metric + expected direction)
  - PathHitVerification entry: which log fields must appear and what values to expect for each config
- Hard gate:
  - If pseudocode section or detailed A/B test plan sections are missing from the task file, Stage 2 code implementation is forbidden.
  - Chat-only pseudocode or partial A/B notes do not count; both sections must be written to the task file.

## 5. Multi-Task Decomposition Rule
- Use a master task when many files/modules are involved, risk is high, or acceptance needs staged verification.
- Master task must include a subtask index table with per-subtask status.
- Each subtask must contain clear scope + acceptance binding.
- Master task is completed only when all subtasks are completed and acceptance conditions are satisfied.

## 6. Subtask Review Gate (User Confirmed)
- Execute one subtask at a time.
- Immediately after each completed subtask:
  - update subtask status
  - update master task subtask-status row
  - provide acceptance result for that subtask
- Before starting the next subtask, ask user whether to review completed subtask(s).
- Start next subtask only after explicit user confirmation (`OK` or equivalent).
- If user says not OK:
  - do not start next subtask
  - capture correction requirements
  - rework and refresh acceptance conclusion

## 7. Task/Spec Boundary
- `task/**` defines what to do (goal/scope/plan/acceptance/risk/execution record).
- `Spec/**` defines stable contracts/constraints/behavior semantics.
- If algorithm-library behavior/interface/flow/state contract changes, corresponding spec updates are mandatory in the same change.

## 8. References
- Master spec: `master_spec/master_spec.md`
- Chat spec: `master_spec/chat_spec/chat_spec.md`
- Initial spec: `master_spec/initial_spec/initial_spec.md`
- Comment spec: `master_spec/comment_spec/comment_spec.md`
- Comment status registry: `master_spec/comment_spec/comment_status.md`
- Acceptance catalog: `master_spec/acceptance_spec/acceptance_catalog.md`
- Task template: `master_spec/task_spec/TASK_TEMPLATE.md`
- Master task template: `master_spec/task_spec/MASTER_TASK_TEMPLATE.md`

## 8.1 Code Comment Governance Binding
- For code-change tasks, comment governance from `master_spec/comment_spec/comment_spec.md` is mandatory.
- Minimum required deliverables in the same task change:
1. function-level comments for in-scope functions (owning/involved/called as defined by comment spec),
2. status update in `master_spec/comment_spec/comment_status.md`.
- Hard gate:
  - if comment scope is triggered and comment deliverables are incomplete, the task cannot transition to `ImplementationDone`, `AcceptancePassed`, `ProcedureCompleted`, `PostReviewUpdated`, or `Archived`.
  - build/runtime execution is forbidden while comment gate is blocked.

## 9. Task Archive Rule (Authoritative)
- Archive destination is `task/Achieve/`.
- A task can be moved to `task/Achieve/` only after its required acceptance profile is fully satisfied.
- Active/in-progress tasks must remain under `task/`.
- Archived task files must keep `Acceptance profile` and `Acceptance reference` fields.

## 10. Code-Change Task Standard Completion Procedure
- For tasks that include code changes (bug fix/feature/refactor in repository code), running the standard completion procedure is mandatory after acceptance passes.
- Standard procedure reference:
  - repository release procedure selected from `master_spec/procedure_spec/procedure_catalog.md`
  - `master_spec/procedure_spec/Task_Closeout_And_Archive.procedure.md`
- Minimum required execution order:
1. Acceptance step must pass first (for algorithm-library changes, use A2 profile).
2. Execute standard procedure steps in order.
3. Before any local commit, output `CommitMessagePlan` (subject and optional body) for user review.
4. Local commit is forbidden until the user explicitly approves the commit message in the same session.
5. Before the last push of the task, synchronize the final task/chat/release-status artifacts that belong to the same closeout state.
6. If the procedure includes `git-commit-and-push`, run push only after same-session explicit user confirmation.
- Hard gate notes:
  - "User approved push" does not imply "user approved commit message"; these are separate gates.
  - Final status-sync artifacts include, at minimum, the active task file, `master_spec/chat_spec/chat_index.md`, and any required release output file such as `svn_log_from_version.txt` when applicable.
  - A code-change task must not require a follow-up "status sync only" commit after the main release push.
- If user explicitly overrides or pauses the standard procedure in the same task, record the override in task execution notes.

## 11. Hard Gate State Machine (Mandatory)
- Every tracked task must follow this strict state order without skipping:
  1. `PlanCreated`
  2. `ReviewApproved`
  3. `ImplementationDone`
  4. `AcceptancePassed`
  5. `ProcedureCompleted` (for code-change tasks: steps 1/2/3/4 of release procedure with push-confirmation gate)
  6. `PostReviewUpdated`
  7. `Archived`
- Gate rules:
  - `ReviewApproved` is required before any implementation.
  - `AcceptancePassed` is required before any release procedure step after acceptance.
  - `ProcedureCompleted` is required before archive for code-change tasks.
  - If a gate is unmet, next gate is blocked.

### 11.1 ProcedureCompleted Applicability Rule
- `ProcedureCompleted` applies to **code-change tasks** (acceptance profile A2 or A3).
- For **non-code tasks** (cfg-only, spec-only, documentation-only; acceptance profile A0, A1, or `A1_Config_Only`):
  - `ProcedureCompleted` is skipped; task advances directly from `AcceptancePassed` → `PostReviewUpdated`.
  - Agent must explicitly record `ProcedureCompleted: not_applicable` in the task Post-Execution Review before advancing to `PostReviewUpdated`.
  - Skipping this record is a governance violation — the skip must be documented, not silent.

## 12. Mandatory Task Status Fields
- Task files (`task/**`) must include and keep current:
  - `Current Phase`
  - `Last Completed Step`
  - `Next Required Step`
  - `Blocking Condition`
- Minimum semantics:
  - `Current Phase`: one value from section 11 states.
  - `Last Completed Step`: concrete command/step that is done.
  - `Next Required Step`: exact next gate action.
  - `Blocking Condition`: why next step cannot proceed (use `none` when clear).
- If these fields are missing or stale, task cannot be considered completed.

## 13. Pre-Archive Self-Check (Mandatory)
- Before moving any task to `task/Achieve/`, run a self-check and record result in task post-review:
  1. Required acceptance profile passed with command exit codes.
  2. For code-change tasks, standard completion procedure status is explicit.
  3. Master/subtask statuses are synchronized.
  4. Pending comment-review items, if any, are explicitly acknowledged by the user in the task closeout record.
  5. `Current Phase` is `PostReviewUpdated` before archive and `Archived` after archive.
- Any failed check blocks archive.

## 14. Mandatory Task Conclusion Template
- This is a baseline constraint (global reusable governance), not task-specific.
- Every task file under `task/**` must include a `Task Conclusion` block in `Post-Execution Review`.
- Required fields (all mandatory):
  1. `Outcome`: `accepted` / `rejected` / `partial`
  2. `Decision`: `continue` / `stop` / `rollback`
  3. `Key Evidence`: concrete artifacts/log paths used for the decision
  4. `Root Cause Summary`: one concise mechanism statement
  5. `Risk Assessment`: `low` / `medium` / `high` with short reason
  6. `Next Action`: exact next step or `none`
- For failed/terminated solution directions, `Decision` must be `stop` or `rollback`, and `Next Action` must explicitly state whether a new direction will be explored.

## 15. Post-Task Rule Reconfirmation Gate (Mandatory)
- Trigger:
  - after any task reaches `Archived`, or
  - task is explicitly closed/cancelled/stopped by user.
- Before starting the next request that involves analysis/implementation/command execution, agent must:
  1. re-read `AGENTS.md`,
  2. output one explicit confirmation line in chat:
     - `RuleReconfirmation: AGENTS.md reloaded; current mandatory gates acknowledged.`
  3. then continue with normal `TaskGovernanceDecision` handshake.
- Hard gate:
  - If this reconfirmation step is missing after a task end/close/cancel event, technical execution is forbidden.
- Purpose:
  - prevent rule drift in long chat context and ensure latest governance constraints are re-applied each round.

## 16. Acceptance Plan And Failure Disposition Gate (Mandatory)

### 16.1 Acceptance Plan Requirement
- Every task file must contain an explicit `Pass/Fail Criteria` section before execution begins.
- Each criterion must be:
  1. **Measurable**: a concrete metric, exit code, or observable output (e.g., `fusion_ms < 500`, `ExitCode=0`, `PSNR delta < 0.1 dB`).
  2. **Falsifiable**: a clear threshold or condition that can be objectively evaluated as PASS or FAIL.
  3. **Attributed**: each criterion must be labeled with its category (e.g., `Build`, `Performance`, `Correctness`, `Quality`).
- Vague criteria such as "faster" or "looks better" are not acceptable.
- Hard gate:
  - If `Pass/Fail Criteria` section is missing, execution step is forbidden.

### 16.2 Post-Execution Criterion Evaluation
- After execution, agent must explicitly evaluate every criterion as `PASS` or `FAIL` and record results in the task file.
- If all criteria PASS → task may proceed to `AcceptancePassed`.
- If any criterion FAIL → agent must immediately apply the Failure Disposition rule (section 16.3) before any further action.

### 16.3 Failure Disposition Rule
When one or more acceptance criteria fail after execution:

**Step 1 — Root Cause Analysis (RCA) obligation:**
Agent must determine whether the failure is:
  - `(A) Incorrect criterion`: the criterion itself was misspecified or based on a wrong estimate.
  - `(B) Implementation defect`: the code/logic does not achieve the intended behavior.
  - `(C) Environmental factor`: noise, thermal state, or machine difference that cannot be attributed to implementation.
  - `(D) Scope underestimate`: the optimization scope was too narrow; the bottleneck is elsewhere.

**Step 2 — Mandatory disposition choice (agent must ask user if not obvious):**
Agent must choose one of the following dispositions and record it in the task file:

| Disposition | When to apply | Required action |
|---|---|---|
| `RCA-inline` | Root cause is identified, fix is within current task scope | Perform RCA, document evidence (`file:line`), propose fix inline |
| `RCA-subtask` | Root cause requires non-trivial investigation or fix scope exceeds current task | Ask user: "Accept inline RCA or create sub-task?"; create sub-task after approval |
| `Criterion-revision` | Criterion was provably incorrect (wrong estimate, wrong baseline machine) | Update criterion with corrected value, document revision rationale, re-evaluate |
| `Known-limitation` | Failure is due to environmental or architectural factor outside current scope; impact is accepted | Document limitation explicitly, record user acknowledgment, mark task `partial-pass` |

**Step 3 — Record:**
Regardless of disposition chosen, the task file must contain:
  - `FailedCriteria`: list of each failed criterion with actual vs expected value
  - `RCADisposition`: one of `RCA-inline` / `RCA-subtask` / `Criterion-revision` / `Known-limitation`
  - `RCAEvidence`: concrete evidence (measurements, `file:line`, timing breakdown, etc.)
  - `RCAConclusion`: one-sentence mechanism statement
  - `UserDispositionApproval`: user's explicit approval of the disposition choice

- Hard gate:
  - Task cannot transition to `AcceptancePassed` or `Archived` while any criterion is `FAIL` without a completed `RCADisposition` record and `UserDispositionApproval`.
  - Agent must not silently skip failed criteria, revise criteria without documentation, or archive a task with unresolved failures.




