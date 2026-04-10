# Read Audit Spec (Source Read Snapshot Governance)

## Metadata
- Path: `master_spec/read_audit_spec/read_audit_spec.md`
- Owner: Shanlan
- Last updated: 2026-04-08
- Adoption date: 2026-04-08
- Classification: `template-owned` (baseline governance, reusable across repositories)

## 1. Purpose
- Make `AGENTS.md §3 step 19` ("Target module headers and implementation files") auditable by recording, per task, which source files the agent actually read for analysis/debug/validation/implementation.
- Provide an audit trail that interlocks with `master_spec/comment_spec/comment_spec.md §2` (read-trigger rule) without introducing a second blocking gate.
- Reduce silent rule drift: long sessions where the agent reads many functions but never records what was read make it hard to verify whether comment-spec scope was respected.

## 2. Scope
- Applies to every task under `task/**` whose `Acceptance profile` is `A2_Algorithm_Library_Change` or `A3_Release_Procedure` (i.e., tasks that touch source code).
- Documentation-only or spec-only tasks (`A0_Documentation_Only`, `A1_Spec_Only`, `A1_Config_Only_Change`) may set `read_audit: not_applicable_doc_only` and skip the snapshot.
- Tasks created **before** the adoption date `2026-04-08` are grandfathered: they may set `read_audit: not_applicable_pre_adoption` and skip the snapshot.

## 3. Snapshot Location
- Default: append a `## Read Audit` section to the active task file (`task/<task>.md`).
- Large reads (more than ~30 distinct files): use a sibling file `task/<task>.read_audit.md` and reference it from the task file.
- Snapshots must remain inside `task/**`; they are runtime/task-state, not template-owned.

## 4. Required Snapshot Fields
Each Read Audit entry must include all of the following:

| Field | Description |
|---|---|
| `task_ref` | Path of the owning task file (for example `task/TaskG_ST03_BiFilter4Channel_5x5_FP16.md`) |
| `read_set` | List of source files read this task. Each item should record `path` and one of: `whole_file`, `lines:<a>-<b>`, `function:<name>` |
| `read_purpose` | One short sentence per item or one shared sentence (analysis / debug / validation / implementation reference / call-chain trace) |
| `read_trigger_outcome` | One of: `comment_added` / `comment_already_complete` / `not_in_comment_scope` (per `comment_spec §2` read-trigger evaluation) |
| `last_updated_at` | ISO date of the most recent snapshot update |

## 5. Update Timing
- Initial entry: at the first time the agent reads any in-repo source file for the task.
- Incremental updates: at every subsequent read-batch.
- Final update: before the task transitions to `ImplementationDone`.

## 6. Hard Gate (Audit Trail Only — Not A New Blocking Gate)
- A code-change task cannot transition to `ImplementationDone` if its `Read Audit` section is missing or empty (and the task is not grandfathered or doc-only).
- This gate is an **audit-trail completeness** check only.
- It does **not** override or duplicate the `comment_spec §2` read-trigger blocking gate. If `read_trigger_outcome` for any item is `comment_added` and `comment_status.md` still shows that function as `pending`/`partial`, the existing comment-spec gate continues to block — read_audit_spec does not weaken or replace it.

## 7. Interlock With Other Specs
- `comment_spec §2`: every `comment_added` outcome must have a matching `comment_status.md` row in the same task.
- `task_spec §11`: read_audit completion is a prerequisite of `ImplementationDone` for in-scope tasks.
- `task_spec §13` (Pre-Archive Self-Check): pre-archive review must verify the read_audit section is non-empty for in-scope tasks.

## 8. Grandfather And Non-Applicability Rules
- Tasks predating `2026-04-08` are not retro-audited.
- Doc-only / spec-only / config-only tasks (`A0`, `A1_Spec_Only`, `A1_Config_Only_Change`) may use `read_audit: not_applicable_doc_only`.
- Tasks where the agent never reads any source file for the change (rare, e.g., procedure-only updates) may use `read_audit: not_applicable_no_source_read`.
- Any non-applicable status must be explicitly written, not silently omitted.

## 9. Template Binding
- Snapshot field skeleton: `master_spec/read_audit_spec/READ_AUDIT_TEMPLATE.md`

## 10. Change Log
- 2026-04-08: Initial spec created under `task/GovernanceAuditCleanup_2026_04_08.md`. Adoption date set to the same day. Bootstrap/exemption clauses defined.
