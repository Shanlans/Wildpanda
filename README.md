<p align="center">
  <img src="assets/logo.png" alt="Wildpanda Logo" width="120" />
</p>

<h1 align="center">Wildpanda</h1>

<p align="center">
  <strong>A governance framework for AI coding agents.</strong><br><br>
  Drop it into any repository and get structured task management,<br>
  multi-session safety, and one-command bootstrap — out of the box.
</p>

<p align="center">
  <a href="https://github.com/Shanlans/Wildpanda/releases/latest"><img src="https://img.shields.io/github/v/release/Shanlans/Wildpanda?style=for-the-badge&color=brightgreen&label=version" alt="Latest Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/Shanlans/Wildpanda?style=for-the-badge" alt="License"></a>
  <a href="https://github.com/Shanlans/Wildpanda/stargazers"><img src="https://img.shields.io/github/stars/Shanlans/Wildpanda?style=for-the-badge&color=yellow" alt="Stars"></a>
  <a href="https://github.com/Shanlans/Wildpanda/pulls"><img src="https://img.shields.io/github/issues-pr/Shanlans/Wildpanda?style=for-the-badge&color=blue" alt="PRs"></a>
</p>

<p align="center">
  <a href="README_zh.md">🇨🇳 中文</a> | <strong>🇬🇧 English</strong>
</p>

<p align="center">
  <a href="#-why">Why</a> •
  <a href="#-features">Features</a> •
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-how-it-works">How It Works</a> •
  <a href="#-skills">Skills</a> •
  <a href="#-governance-lifecycle">Lifecycle</a> •
  <a href="#-license">License</a>
</p>

---

Built for [Claude Code](https://claude.ai/claude-code). Works with any LLM-based coding agent that reads markdown specs.

> **Current version: v1.3.1**

## 🤔 Why

AI coding agents are powerful but **stateless**. Every new chat session starts from scratch — no memory of what was done, what's in progress, or what another session is working on.

| Problem | What happens |
|---|---|
| 🔄 **Lost context** | Agent repeats work or contradicts previous decisions |
| ⚡ **Race conditions** | Two sessions edit the same file, one overwrites the other |
| 🚫 **No quality gate** | Changes ship without build verification or acceptance criteria |
| 📉 **Drift** | Project rules live in the developer's head, not in the repo |

**Wildpanda solves this** by putting governance into the repository itself — as markdown specs that the agent reads on every session start.

## 🎯 Features

### Task Lifecycle & State Machine

A 7-state hard-gate progression ensures no step is skipped:

```
PlanCreated → ReviewApproved → ImplementationDone → AcceptancePassed
  → ProcedureCompleted → PostReviewUpdated → Archived
```

- **Pass/fail criteria** — every task requires measurable, falsifiable acceptance criteria before execution begins.
- **Failure disposition** — when criteria fail, agent must perform root-cause analysis and classify: `RCA-inline`, `RCA-subtask`, `Criterion-revision`, or `Known-limitation`.
- **Mandatory conclusion** — tasks cannot archive without outcome, evidence, risk assessment, and next-action fields.
- **Multi-task decomposition** — master task with subtask index, per-subtask status tracking, and staged acceptance.
- **Effect-quality overlay** — visual/quality tasks get extra gates: A/B test, path-hit verification, user validation, rollback on failure.

### Multi-Session Safety

Every session gets a unique `chat_id`. Every task tracks its owning session.

- **Heartbeat & stale detection** — `Last Heartbeat At` timestamp updated on state writes. Default stale threshold: 4 hours (configurable).
- **Hard-gate takeover protocol** — when a new session finds another session's task, it must ask the user before claiming it. No silent takeover.
- **Chat index** — `chat_index.md` provides a thin index of all active tasks, phases, and owning sessions. New sessions discover work instantly.
- **Governance sync check** — at session start, automatically compares local framework version with upstream. Notifies if update available.

### Acceptance Profiles

Four reusable profiles define what "done" means for different change types:

| Profile | Scope | Validation |
|---|---|---|
| **A0** Documentation | Markdown / spec updates | No build required |
| **A1** Spec / Config | Config or spec changes | Minimal validation |
| **A2** Code Change | Algorithm / library code | Full build + smoke test |
| **A3** Release | Release procedure | Full release validation |

### Code Change Governance

- **Comment coverage trigger** — if agent reads a source function and finds missing/non-compliant comments, it must complete them in the same task. Progressive coverage, not retroactive bulk.
- **Function-level comment template** — standard `@codex-comment` format: input/output interface, key steps, key params, state/dependencies.
- **Comment review workflow** — 3-state review: `approved` → `pending` → rework. User can reject and force re-verification.
- **Memory & resource cleanup rules** — new/delete pairing, RAII preference, cross-stage lifecycle context.
- **Read audit trail** — per-task record of which files were read, why, and what was done about it. Gate blocks `ImplementationDone` if audit is empty.

### Spec-First & Flow Documentation

Code changes that affect documented flows must update the flow spec **before** implementation.

- **Flow discovery** — if no flows exist or modified files aren't covered, the `flow-discovery` skill auto-traces call chains and generates flow specs.
- **Call-graph-first** — agent must use static analysis tools (ctags, cscope, pyan3, madge, go-callgraph) instead of manually reading code. Supports 5 query types: find definition, find callers, find callees, trace call chain, impact analysis.
- **Multi-language support** — C/C++, Python, Java, JavaScript/TypeScript, Go, Rust.

### Bootstrap & Initialization

- **One-command setup** — fill a JSON template with project facts, run the bootstrap script, get a fully governed repo.
- **Governance state detection** — session start auto-detects if governance is missing or incomplete, triggers bootstrap.
- **Template vs instance separation** — reusable rules live in template specs; project-specific values live in `project_profile.yaml`. Sync never overwrites instance files.

### Governance Drift Prevention

- **Rule reconfirmation gate** — after every archived or stopped task, agent must re-read `AGENTS.md` before next execution.
- **Task governance decision** — before any work, agent must classify: `continue-tracked-task`, `new-task-required`, or `non-task-request`.
- **Build spec-binding handshake** — before executing build commands, agent must state which env spec, acceptance profile, and command source it's using.
- **Spec change scoping** — new rules classified as `baseline` (goes to `master_spec/`) or `task-specific` (stays in `task/`). Default: task-specific.

### Safety & Scope Boundaries

- **Repository-scoped** — all file operations stay inside the current repo. System dirs and user profile dirs are off-limits.
- **Third-party exclusion** — vendor/3rdparty code excluded from review and editing unless user explicitly overrides.
- **Forbidden commands** — destructive operations (`git reset --hard`, `rm -rf`, privilege escalation) blocked without explicit approval.
- **Change discipline** — minimal targeted edits, preserve style, report build results.

### Plain-Language Communication

- Short sentences, one idea per bullet, no jargon dumps.
- State the ask first, reasoning second.
- Default-recommended path bolded.
- Follow user's language (Chinese → Chinese, English → English).

## ⚡ Quick Start

### Option A: Bootstrap script (recommended)

```bash
# 1. Clone Wildpanda
git clone https://github.com/Shanlans/Wildpanda.git wildpanda-seed

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
2. Copy `master_spec/initial_spec/starter_instance/*` into corresponding `master_spec/` subdirs.
3. Create `project_profile.yaml` from `master_spec/project_profile_template.yaml`.
4. Create empty `task/` and `task/Achieve/` directories.
5. Start a Claude Code session — the agent detects governance and follows the specs.

## 🔁 How It Works

<pre>
┌─────────────────────────────────────────────┐
│          Agent Session Start                │
└──────────────────────┬──────────────────────┘
                       ▼
             ┌─────────────────────┐
             │  Read AGENTS.md     │ ← mandatory read order
             └────────┬────────────┘
                      ▼
          ┌───────────────────────┐
          │  Continuity Check     │
          │  • chat_index.md      │ ← discover tasks
          │  • stale detection    │ ← heartbeat > 4h?
          │  • governance sync    │ ← upstream updates?
          └───────────┬───────────┘
                      ▼
          ┌───────────────────────┐
          │  Governance Decision  │
          │  • continue task?     │
          │  • new task?          │
          │  • non-task request?  │
          └───────────┬───────────┘
                      ▼
        ┌─────────────────────────────┐
        │     Task Lifecycle           │
        │  Plan → Review → Implement  │
        │       → Accept → Archive    │
        └─────────────┬───────────────┘
                      ▼
          ┌───────────────────────┐
          │  Acceptance Gate      │
          │  • Build pass?        │
          │  • Smoke test?        │
          │  • Criteria met?      │
          │  • Read audit done?   │
          │  • Comments reviewed? │
          └───────────┬───────────┘
                      ▼
          ┌───────────────────────┐
          │  Rule Reconfirmation  │
          │  Re-read AGENTS.md    │ ← prevent drift
          └───────────┬───────────┘
                      ▼
          ┌───────────────────────┐
          │  Session End          │
          │  Heartbeat stops      │ ← next session detects
          └───────────────────────┘
</pre>

## 🔧 Skills

| Skill | Purpose | Trigger |
|---|---|---|
| **bootstrap-governance** | Set up governance in a new repo | Auto (new project) / Manual: "bootstrap governance" |
| **governance-sync** | Pull updates from upstream Wildpanda | Auto (session start) / Manual: "sync governance" |
| **governance-contribute** | Contribute improvements back via PR | Manual: "contribute back" |
| **governance-release** | Package merged PRs into a release | Manual: "prepare release" |
| **call-graph** | Query function call relationships | Auto (when tracing calls) / Manual: "call graph" |
| **flow-discovery** | Discover and document call flows | Auto (empty flow catalog) / Manual: "discover flow" |

## 🔄 Governance Lifecycle

```
Upstream (Wildpanda)               Consuming Project
┌───────────────┐                  ┌───────────────┐
│  Latest       │───── sync ──────▶│ Pull updates  │
│               │                  │               │
│  master       │◀── contribute ───│ Push changes  │
│               │    (PR)          │               │
│  release PR   │◀── release ──────│ Package new   │
│  (maintainer  │                  │ version       │
│   merges+tag) │                  │               │
└───────────────┘                  └───────────────┘
```

## 📁 Repository Structure

```
AGENTS.md                              # Agent entry point
VERSION                                # Framework version (semver)
CHANGELOG.md                           # Release history

master_spec/                           # Governance specs
├── project_profile_template.yaml      # Instance config template
├── chat_spec/chat_spec.md             # Session continuity, multi-tenancy
├── task_spec/task_spec.md             # Task lifecycle, state machine
├── coding_spec/coding_spec.md         # Coding style, memory rules
├── comment_spec/comment_spec.md       # Comment coverage, review workflow
├── read_audit_spec/read_audit_spec.md # Read audit trail
├── skill_spec/skill_spec.md           # Skill routing, release pipeline
├── acceptance_spec/                   # Acceptance profiles (A0-A3)
├── procedure_spec/                    # Operational procedures
├── flow_spec/                         # Flow templates, catalog
└── initial_spec/                      # Bootstrap, boundary, propagation

skill/                                 # Skills
├── bootstrap-governance/              # 🚀 Bootstrap
├── governance-sync/                   # 🔄 Sync
├── governance-contribute/             # 📤 Contribute
├── governance-release/                # 📦 Release
├── call-graph/                        # 🔍 Call graph analysis
└── flow-discovery/                    # 🗺️ Flow discovery
```

## 🏗️ Key Design Decisions

- **Task file = single source of truth.** Runtime state lives in `task/<task>.md`.
- **Silent takeover forbidden.** Agent must ask before claiming another session's task.
- **Template vs instance separation.** Reusable rules in template specs, project values in `project_profile.yaml`.
- **Spec-first, not code-first.** Flow specs before code changes.
- **Tool-first, not manual-first.** Use static analysis tools for call tracing, not manual code reading.
- **PR-only policy.** After v1.1.0, all changes go through pull requests.
- **Gate-driven, not trust-driven.** Every transition requires evidence, not just agent assertion.

## 🔧 Compatibility

| | |
|---|---|
| **Primary target** | Claude Code (Anthropic) |
| **Also works with** | Any LLM coding agent that reads markdown |
| **OS** | Windows (PowerShell bootstrap), Linux/macOS (manual or adapt scripts) |
| **Dependencies** | None for core — pure markdown + YAML |
| **Governance skills** | Require [GitHub CLI (`gh`)](https://cli.github.com/) |
| **Call graph** | Require [Universal Ctags](https://ctags.io/) or language-specific tools |

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Shanlans/Wildpanda&type=Date)](https://star-history.com/#Shanlans/Wildpanda&Date)

## 📄 License

[MIT](LICENSE) — Copyright (c) 2026 Shanlan
