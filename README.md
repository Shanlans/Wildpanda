# Wildpanda

A governance framework for AI coding agents. Drop it into any repository and get structured task management, multi-session safety, and one-command bootstrap — out of the box.

Built for [Claude Code](https://claude.ai/claude-code). Works with any LLM-based coding agent that reads markdown specs.

## Why

AI coding agents are powerful but stateless. Every new chat session starts from scratch — no memory of what was done, what's in progress, or what another session is working on. This leads to:

- **Lost context** — agent repeats work or contradicts previous decisions
- **Race conditions** — two sessions edit the same file, one overwrites the other
- **No quality gate** — changes ship without build verification or acceptance criteria
- **Drift** — project rules live in the developer's head, not in the repo

Wildpanda solves this by putting governance into the repository itself — as markdown specs that the agent reads on every session start.

## What You Get

| Capability | Description |
|---|---|
| **Task Lifecycle** | State machine: `PlanCreated` → `ReviewApproved` → `ImplementationInProgress` → `AcceptancePassed` → `Archived`. Every task has pass/fail criteria, post-execution review, and mandatory conclusion. |
| **Multi-Tenancy** | Chat identity (`chat_id`), heartbeat timestamps, stale detection (default 4h), and a hard-gate takeover protocol. Two sessions can never silently fight over the same task. |
| **Acceptance Profiles** | `A0` (docs only) / `A1` (spec only) / `A2` (code change — build + smoke test required) / `A3` (release procedure). Each profile defines exactly what "done" means. |
| **Session Continuity** | On every new chat, the agent reads `chat_index.md` to discover active tasks, checks for stale sessions, and resumes where things left off. |
| **Bootstrap** | One command sets up governance in a new repo. Fill a JSON template with your project facts, run the script, done. |
| **Spec-First Discipline** | Agent must read specs before writing code. Flow specs document call chains. Comment specs enforce review. Read audit tracks what the agent actually looked at. |

## Quick Start

### Option A: Bootstrap script (recommended)

```bash
# 1. Clone Wildpanda
git clone https://github.com/<your-username>/Wildpanda.git wildpanda-seed

# 2. Copy into your project
cp -r wildpanda-seed/AGENTS.md .
cp -r wildpanda-seed/master_spec/ .
cp -r wildpanda-seed/skill/ .

# 3. Fill your project facts
cp master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json my-input.json
# Edit my-input.json: project name, build command, smoke test, etc.

# 4. Run bootstrap
powershell -ExecutionPolicy Bypass \
  -File skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1 \
  -InputFile my-input.json
```

### Option B: Manual setup

1. Copy `AGENTS.md`, `master_spec/`, and `skill/` into your repo root.
2. Copy `master_spec/initial_spec/starter_instance/*` into the corresponding `master_spec/` subdirectories.
3. Create `project_profile.yaml` from `master_spec/project_profile_template.yaml`.
4. Create empty `task/` and `task/Achieve/` directories.
5. Start a Claude Code session — the agent will detect governance and follow the specs.

## Repository Structure

```
AGENTS.md                              # Agent entry point — read order, conflict priority, safety rules
VERSION                                # Framework version (semver)
CHANGELOG.md                          # What changed in each version

master_spec/
  project_profile_template.yaml        # Template for project_profile.yaml (instance config)
  chat_spec/
    chat_spec.md                       # Session resume, continuity check, multi-tenancy protocol
  task_spec/
    task_spec.md                       # Task lifecycle rules, decomposition, acceptance binding
    TASK_TEMPLATE.md                   # Single task template (11-field Runtime State block)
    MASTER_TASK_TEMPLATE.md            # Multi-subtask master template
  coding_spec/
    coding_spec.md                     # Coding style, memory lifecycle
  comment_spec/
    comment_spec.md                    # Comment coverage, review workflow
  read_audit_spec/
    read_audit_spec.md                 # Per-task source read audit
    READ_AUDIT_TEMPLATE.md
  skill_spec/
    skill_spec.md                      # Skill registration and routing
  acceptance_spec/
    ACCEPTANCE_PROFILE_TEMPLATE.md     # Template for new acceptance profiles
    ACCEPTANCE_CATALOG_TEMPLATE.md
  procedure_spec/
    PROCEDURE_TEMPLATE.md              # Template for new procedures
    New_Project_Governance_Bootstrap.procedure.md
    New_Project_Instance_Generation.procedure.md
    Task_Closeout_And_Archive.procedure.md
  flow_spec/
    FLOW_TEMPLATE.md                   # Template for algorithm flow docs
  initial_spec/
    initial_spec.md                    # Bootstrap trigger and propagation rules
    governance_template_boundary.md    # Template-owned vs instance-owned classification
    starter_instance/                  # Skeleton files for new projects
    NEW_PROJECT_BOOTSTRAP_CHECKLIST.md
    NEW_PROJECT_BOOTSTRAP_MANIFEST_TEMPLATE.md
    NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json

skill/
  bootstrap-governance/
    SKILL.md                           # Bootstrap skill definition
    scripts/
      bootstrap-new-repository.ps1     # One-command bootstrap
      initialize-bootstrap-artifacts.ps1
```

## How It Works

1. **Agent starts a session** → reads `AGENTS.md` → follows mandatory read order through specs
2. **Continuity check** → reads `chat_index.md` → finds active tasks → checks for stale sessions
3. **Task execution** → agent follows task lifecycle: plan → review → implement → accept → archive
4. **Acceptance gate** → profile-specific checks (build? smoke test? manual review?) must pass before archive
5. **Session ends** → heartbeat stops; next session detects staleness and can take over with user approval

## Key Design Decisions

- **Task file is the single source of truth.** Runtime state lives in `task/<task>.md`, not in a global status file. This eliminates the double-write problem.
- **Silent takeover is forbidden.** If another session owns a task, the agent must ask before claiming it.
- **Template vs instance separation.** Reusable rules live in template-owned specs. Project-specific values live in `project_profile.yaml`. No coupling.
- **Spec-first, not code-first.** The agent reads flow specs before writing code. Changes to behavior require updating the flow spec first.

## Versioning

- `VERSION` file contains the current semver
- `CHANGELOG.md` documents every release
- Consumer projects record which version they use: `governance.framework_version` in `project_profile.yaml`

## Compatibility

- **Primary target**: Claude Code (Anthropic)
- **Also works with**: Any LLM coding agent that can read markdown files and follow structured instructions
- **OS**: Windows (PowerShell bootstrap scripts), Linux/macOS (manual setup or adapt scripts)
- **No runtime dependencies**: Pure markdown + YAML + two PowerShell scripts

## License

[MIT](LICENSE)
