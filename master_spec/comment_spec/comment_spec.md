# Comment Spec (Function-Level Comment Governance)

## Metadata
- Path: `master_spec/comment_spec/comment_spec.md`
- Owner: Shanlan
- Last updated: 2026-02-27

## 1. Purpose
- Define a uniform, progressive comment standard for maintainability and future debugging.
- Scope note: this spec governs source-code comments only (not markdown task/spec prose).

## 2. Coverage Trigger (Mandatory)
- If a task changes code, comment completion scope includes functions that are:
  1. the owning functions of modified code,
  2. functions directly involved by the modified behavior,
  3. functions directly called by modified logic where understanding is required for correctness.
- Read-trigger hard rule:
  - If agent reads any source function for analysis/debug/validation and finds missing or non-compliant function-level comments, agent must add/complete comments in the same task.
  - This read-trigger rule applies even when final code logic is unchanged.
- Execution-order hard rule:
  - Once the read-trigger is hit, comment updates become a blocking gate.
  - Agent must finish in-scope comment updates and `comment_status.md` updates before any of these actions:
    1. next technical analysis loop on new functions/modules,
    2. build/runtime/acceptance command execution,
    3. release procedure steps,
    4. task close/archive.
  - Carrying unresolved comment scope to a later turn in the same task is forbidden unless user explicitly approves override in that turn.

## 3. Granularity
- Comment standard is function-level (not line-by-line narration).
- Do not add noisy comments that restate obvious syntax.

## 4. Function-Level Required Fields
- For each function in comment scope, comments must describe:
1. Input interface (source/format/range/units, key preconditions)
2. Output interface (result format/range and observable side effects)
3. Key internal function blocks (critical algorithm stages only)
4. Key parameters and their intent (thresholds/weights/switches)
5. Global or shared state dependencies (if any)

## 4.1 Comment Template And Signature (Mandatory)
- Agent-authored function comments must use a consistent signature line so comment ownership is traceable.
- Required signature token:
  - `@codex-comment`
- Required template (language can follow file/project convention):
```text
/* @codex-comment
 * Input:
 * Output:
 * Key Steps:
 * Key Params:
 * State/Dependencies:
 */
```
- Template usage rules:
  - Keep content factual and concise; no line-by-line narration.
  - Do not duplicate existing high-quality comments; only append signature when agent updates/rewrites that comment block.
  - If existing comments are complete but unsigned and untouched in current task, signature backfill is optional.

## 5. Comment Review Workflow
1. After comment updates, set `author_review_status` for each function entry:
  - `approved`
  - `pending`
2. If review is `pending`, next analysis cannot fully trust comments; agent must re-confirm behavior from code.
3. Agent must proactively request user review for comment updates in the current task.
4. User must explicitly confirm review decision for current task:
  - `review_now_approved`
  - `review_now_rework_required`
  - `review_not_now`
5. If decision is `review_now_rework_required`, user feedback must be captured with incorrect points, comments must be corrected, and review must be requested again.
6. If decision is `review_not_now`, status remains `pending`; no implicit approval is allowed.

## 6. Comment Status Registry
- Maintain status file: `master_spec/comment_spec/comment_status.md`
- Required columns:
  - `file`
  - `function`
  - `comment_status` (`complete` / `partial` / `missing`)
  - `review_decision` (`review_now_approved` / `review_now_rework_required` / `review_not_now`)
  - `author_review_status` (`approved` / `pending`)
  - `last_updated_task`
- Field semantics:
  - `review_decision` records current-task user decision trace.
  - `author_review_status` records effective final state after rework cycle.

## 7. Ongoing Maintenance Rule
- Any code-change task touching function behavior must update:
1. function comments in source files (within defined scope),
2. `master_spec/comment_spec/comment_status.md`.

## 8. Acceptance
- Comment scope is satisfied for all triggered functions.
- `comment_status.md` is updated in the same change.
- Comment gate pass criteria:
  - all triggered functions are `complete` in status registry for this task, and
  - no unresolved `missing` entries remain for read-triggered scope.

## 9. Task-End Reminder (Mandatory)
- At the end of every tracked task, agent must explicitly list functions/files whose comment review status is still `pending`.
- This reminder is mandatory even when task acceptance passed.
