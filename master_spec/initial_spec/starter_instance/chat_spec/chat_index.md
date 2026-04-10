# Chat Index

## Project State
- governance_status: `initialized`

## Active Task Index

| Task | Phase | Last Verified | Owning Chat | Last Heartbeat |
|---|---|---|---|---|

## Last Archived Task
- (none)

## Update Rule
- Agent updates this index at: task creation, task phase transition, task archive.
- Per-task runtime state lives in the task file itself (authoritative per chat_spec §7.1). This index holds only a phase snapshot for cross-task overview.
- On session resume, agent reads this index to discover active tasks, then reads each task file for full state.
