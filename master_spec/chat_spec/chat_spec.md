# Chat Spec (Session Resume And Task Continuity)

## Metadata
- Path: `master_spec/chat_spec/chat_spec.md`
- Owner: Shanlan
- Last updated: 2026-04-10

## 1. Purpose
- Define chat/session-level behavior so execution remains consistent after chat restart or context reset.

## 2. Resume Detection Rule
- At the start of each new chat session, agent must run a task continuity check before implementation.
- At the start of each new chat session, agent must also confirm repository governance state is not `initial-only`.

## 3. Continuity Check (Mandatory)
0. Confirm governance state:
  - if project is still `initial-only` (only `AGENTS.md` or incomplete required governance roots), run initialization flow from `master_spec/initial_spec/initial_spec.md` first.
  - if governance state is already initialized, continue with normal continuity checks below.
1. Scan active task files under `task/*.md` (exclude templates).
2. Detect unfinished tasks by `Current Phase` not equal to `Archived` (or equivalent completed terminal state).
3. If unfinished tasks exist:
  - summarize unfinished tasks and blocking conditions first
  - ask whether to continue one of them or start a new task in parallel
4. If no unfinished tasks exist:
  - proceed with normal task classification.

## 4. Read Order Impact
- Continuity check is a pre-gate and must run before code-change execution.
- This does not replace acceptance/task-spec read requirements; it only front-loads resume safety.

## 5. Acceptance
- For resumed sessions, agent output includes:
  - governance state result (`initial-only` / `initialized`)
  - unfinished task list
  - selected continuation decision
  - next actionable step

## 6. User Communication Style (Plain Language Rule, Mandatory)

- **Target audience**: the user is a project lead, not a line reader. Chat replies must be understandable on first read without expanding acronyms or re-reading sentences.
- **Hard rules for chat replies (this does NOT apply to `task/**`, `master_spec/**`, or other doc files — those stay in formal English per the `feedback_doc_language.md` rule)**:
  1. **No jargon dumps**. Do not chain more than two technical terms in one sentence. If a term cannot be avoided, gloss it in the same sentence in parentheses.
  2. **Short sentences**. Target ≤ 25 Chinese characters or ≤ 20 English words per sentence in normal prose.
  3. **One idea per bullet**. If a bullet has ";" or "，" more than once, split it.
  4. **Numbers and file names are OK** (e.g. md5 hashes, line numbers, paths). The rule is about sentence structure, not content.
  5. **State the ask first, the reasoning second**. When asking the user to decide, the question must appear before the rationale, not after a wall of context.
  6. **Default-recommended path must be visually distinct**. Use bold or a `推荐` marker on the default choice in any Q&A block.
  7. **When the user says "听不懂" / "说人话" / "看不懂" or equivalent**, the next reply must:
     - drop all acronyms not glossed in the previous 3 messages
     - collapse any table into ≤ 5 bullets
     - restate the top-level goal in one sentence before any detail
     - end with a single concrete question or default choice the user can accept with one word
- **Language selection**: Chat replies follow the user's last message language (Chinese → Chinese, English → English). Mixed language is allowed only for proper nouns, file paths, code identifiers, and numeric evidence.
- **Escalation**: if the user repeats "听不懂" / equivalent within the same task, stop producing new content and ask one clarifying question about *which specific piece* is unclear, rather than re-explaining everything.
- **Non-goal**: this rule does NOT lower the rigor of `task/**` plan files, acceptance criteria, or post-execution reviews. Formal docs remain formal; only chat replies are plain-language-gated.

## 7. Persistent Chat Status (Mandatory)

### 7.1 Authoritative Source Of Per-Task Runtime State (Migration Window)

The **task file** (`task/<task>.md` Metadata → `### Runtime State` block) is the **single source of truth** for all per-task runtime fields. The former `chat_status.md` has been replaced by `chat_index.md` (thin index, see §7.2) as of ST-02.

| Per-Task Runtime Field | Authoritative Location |
|---|---|
| `Acceptance State` | task file `### Runtime State` |
| `Acceptance Evidence Path` | task file `### Runtime State` |
| `Last Build Exit Code` | task file `### Runtime State` |
| `Last Runtime Exit Code` | task file `### Runtime State` |
| `Release Pipeline State` | task file `### Runtime State` |
| `Comment Review State` | task file `### Runtime State` |
| `Comment Review Decision Latest` | task file `### Runtime State` |
| `Archive Ready` | task file `### Runtime State` |
| `Last Verified At` | task file `### Runtime State` |
| `Owning Chat ID` | task file `### Runtime State` (see §7.3.1) |
| `Last Heartbeat At` | task file `### Runtime State` (see §7.3.2) |

Project-global field `governance_status` lives in `chat_index.md` `## Project State`.

Agent update rule:
- When updating per-task runtime state, write to the **task file** (authoritative).
- Update `chat_index.md` Active Task Index row (phase snapshot, owning chat, last heartbeat) at phase transitions and heartbeat updates.
- On conflict, trust the task file.

Chat identity, heartbeat, stale detection, and takeover protocol are defined in §7.3.

### 7.2 Chat Index (replaces legacy `chat_status.md` as of ST-02)

- Index file path: `master_spec/chat_spec/chat_index.md`
- Agent must update this file at:
  1. task creation (add row to Active Task Index),
  2. task phase transition (update Phase column),
  3. task archive (remove row from Active Task Index, update Last Archived Task).
- **Schema**:
  - `## Project State` — project-global fields (`governance_status`).
  - `## Active Task Index` — one row per live task under `task/`:
    | Column | Source |
    |---|---|
    | Task | task file path |
    | Phase | task file `Current Phase` (snapshot; authoritative value is in the task file per §7.1) |
    | Last Verified | task file `Last Verified At` |
    | Owning Chat | task file `Owning Chat ID` (snapshot; see §7.3.1) |
    | Last Heartbeat | task file `Last Heartbeat At` (snapshot; see §7.3.2) |
  - `## Last Archived Task` — one-line summary of the most recently archived task.
- **Per-task runtime fields** (acceptance_state, last_build_exit_code, last_runtime_exit_code, release_pipeline_state, comment_review_state, comment_review_decision_latest, archive_ready, last_verified_at) live **exclusively** in the task file `### Runtime State` block (per §7.1). They are NOT duplicated in the index.
- **Field intent** (for per-task fields in task file `### Runtime State`):
  - `Release Pipeline State`: `not_started` / `in_progress` / `blocked` / `completed` / `not_applicable`
  - `Acceptance State`: `not_run` / `passed` / `partial_pass` / `failed` / `not_applicable`
    - `not_run`: acceptance commands have not been executed yet
    - `passed`: all Pass/Fail criteria passed
    - `partial_pass`: some criteria failed but disposition was approved by user (Known-limitation or Criterion-revision)
    - `failed`: one or more criteria failed with no approved disposition
    - `not_applicable`: task type has no executable acceptance commands (e.g., A0 documentation tasks)
  - `Comment Review State`: `clear` / `pending_review_exists` / `blocked` / `not_applicable`
  - `Archive Ready`: `yes` / `no` / `not_applicable`
- Closeout rule:
  - For code-change tasks, the task file `### Runtime State` must reflect the final release/closeout state before the last push.
  - The chat index Active Task Index row must be removed (or moved to Last Archived Task) on archive.

### 7.3 Chat Identity And Takeover Protocol (added by ST-03)

#### 7.3.1 Chat ID Schema

Each chat session is identified by a unique `chat_id`:
- **Format**: `chat-<YYYYMMDD>-<HHMM>-<3char>` where `<3char>` is a random lowercase alphanumeric suffix or a user-supplied alias.
- **Generation timing**: at the first task-state write in a new session. Read-only sessions do not require a chat_id.
- **Storage**:
  - Task file `### Runtime State` → `Owning Chat ID` (authoritative, per §7.1).
  - `chat_index.md` Active Task Index → `Owning Chat` column (snapshot).
- A single chat session may own multiple tasks simultaneously.

#### 7.3.2 Heartbeat Semantics

- **Field**: `Last Heartbeat At` — ISO-8601 timestamp (`YYYY-MM-DDTHH:MM`) of the last meaningful state write.
- **Update triggers** (any of these):
  - Task phase transition (e.g., `PlanCreated` → `ReviewApproved`).
  - Acceptance state change.
  - Execution Update note added.
  - Pass/Fail criterion filled.
- **Not updated on**: read-only operations, trivial formatting edits, or changes to unrelated files.
- **Storage**:
  - Task file `### Runtime State` → `Last Heartbeat At` (authoritative).
  - `chat_index.md` Active Task Index → `Last Heartbeat` column (snapshot).

#### 7.3.3 Stale Threshold

- A task is **stale** when: `now - Last Heartbeat At > stale_threshold`.
- **Default threshold**: 4 hours.
- **Configuration**: `project_profile.yaml` → `chat.stale_threshold_hours` (integer, in hours). If the key is absent, use the default (4).
- **Detection timing**: during §3 Continuity Check at the start of each new session.

#### 7.3.4 Takeover Protocol (Hard Gate)

On session resume, the agent scans the Active Task Index and evaluates each active task:

1. **Same chat_id as current session** → no action needed, continue normally.
2. **Different chat_id, task is STALE** (heartbeat exceeded threshold):
   - Agent presents: `[STALE] Task "<task>" was last touched by <chat_id> at <timestamp>. Take over? (Y/N)`
   - On user approval: update `Owning Chat ID` to current session, reset `Last Heartbeat At`, log takeover event in task `## Execution Update`.
   - On user decline: leave task untouched; agent does not modify it.
3. **Different chat_id, task is ACTIVE** (heartbeat within threshold):
   - Agent presents: `[ACTIVE] Task "<task>" is held by <chat_id> (last heartbeat <timestamp>). This session appears to still be alive. Force takeover requires explicit user approval.`
   - On user approval: same as stale takeover, but agent logs `forced takeover (task was not stale)` in Execution Update.
   - On user decline: leave task untouched.
4. **Grandfathered task** (see §7.3.5): treated as stale by default.

**Silent takeover is forbidden.** The agent must never reassign `Owning Chat ID` without explicit user confirmation, regardless of staleness.

#### 7.3.5 Grandfather Rules

- Tasks created before ST-03 adoption carry: `Owning Chat ID: grandfathered` and `Last Heartbeat At: n/a`.
- Grandfathered tasks are treated as **stale by default** during takeover evaluation.
- A new session can claim a grandfathered task with a single confirmation prompt (same flow as stale takeover in §7.3.4 case 2).
- Once claimed, the task follows normal heartbeat rules going forward (chat_id set, heartbeat updated on writes).
