# Read Audit Template

<!--
Append this section to the active task file (`task/<task>.md`) under a top-level
`## Read Audit` heading. For large read sets (more than ~30 distinct files),
move the table to a sibling file `task/<task>.read_audit.md` and reference it
from the task file.

Required fields per `master_spec/read_audit_spec/read_audit_spec.md §4`.
-->

## Read Audit
- task_ref: `task/<your-task>.md`
- last_updated_at: `<YYYY-MM-DD>`
- read_purpose (default): `<analysis | debug | validation | implementation reference | call-chain trace>`

### Read Set
| # | Path | Range / Function | Purpose | Read Trigger Outcome |
|---|---|---|---|---|
| 1 | `<file path>` | `whole_file` / `lines:<a>-<b>` / `function:<name>` | `<short purpose>` | `comment_added` / `comment_already_complete` / `not_in_comment_scope` |
| 2 | | | | |

### Non-Applicable Status (use only when applicable)
- `read_audit: not_applicable_doc_only` — task acceptance profile is `A0` / `A1_Spec_Only` / `A1_Config_Only_Change`
- `read_audit: not_applicable_no_source_read` — no in-repo source file was read for this task
- `read_audit: not_applicable_pre_adoption` — task created before `2026-04-08` adoption date
