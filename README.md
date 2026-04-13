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
  <a href="#-what-you-get">What You Get</a> •
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-how-it-works">How It Works</a> •
  <a href="#-skills">Skills</a> •
  <a href="#-governance-lifecycle">Lifecycle</a> •
  <a href="#-license">License</a>
</p>

---

Built for [Claude Code](https://claude.ai/claude-code). Works with any LLM-based coding agent that reads markdown specs.

## 🤔 Why

AI coding agents are powerful but **stateless**. Every new chat session starts from scratch — no memory of what was done, what's in progress, or what another session is working on.

| Problem | What happens |
|---|---|
| 🔄 **Lost context** | Agent repeats work or contradicts previous decisions |
| ⚡ **Race conditions** | Two sessions edit the same file, one overwrites the other |
| 🚫 **No quality gate** | Changes ship without build verification or acceptance criteria |
| 📉 **Drift** | Project rules live in the developer's head, not in the repo |

**Wildpanda solves this** by putting governance into the repository itself — as markdown specs that the agent reads on every session start.

## 🎯 What You Get

| Capability | Description |
|---|---|
| 📋 **Task Lifecycle** | State machine: `PlanCreated` → `ReviewApproved` → `ImplementationInProgress` → `AcceptancePassed` → `Archived`. Every task has pass/fail criteria and mandatory conclusion. |
| 🔒 **Multi-Tenancy** | Chat identity (`chat_id`), heartbeat timestamps, stale detection (default 4h), and a hard-gate takeover protocol. |
| ✅ **Acceptance Profiles** | `A0` docs / `A1` spec / `A2` code (build + smoke) / `A3` release. Each profile defines exactly what "done" means. |
| 🔄 **Session Continuity** | Every new chat reads `chat_index.md` → discovers active tasks → checks for stale sessions → resumes where things left off. |
| 🚀 **Bootstrap** | One command sets up governance in a new repo. Fill a JSON template, run the script, done. |
| 📖 **Spec-First** | Agent reads specs before writing code. Flow specs document call chains. Comment specs enforce review. |
| 🔍 **Call Graph** | Tool-first call relationship analysis. Agent uses static analysis tools instead of manually reading code. |

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
├── chat_spec/chat_spec.md             # Session resume, multi-tenancy
├── task_spec/task_spec.md             # Task lifecycle
├── coding_spec/coding_spec.md         # Coding style
├── comment_spec/comment_spec.md       # Comment review
├── read_audit_spec/read_audit_spec.md # Read audit
├── skill_spec/skill_spec.md           # Skill routing
├── acceptance_spec/                   # Acceptance profiles
├── procedure_spec/                    # Procedures
├── flow_spec/                         # Flow templates
└── initial_spec/                      # Bootstrap & boundary

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

## 🔧 Compatibility

| | |
|---|---|
| **Primary target** | Claude Code (Anthropic) |
| **Also works with** | Any LLM coding agent that reads markdown |
| **OS** | Windows (PowerShell bootstrap), Linux/macOS (manual or adapt scripts) |
| **Dependencies** | None for core — pure markdown + YAML |
| **Governance skills** | Require [GitHub CLI (`gh`)](https://cli.github.com/) |
| **Call graph** | Require [Universal Ctags](https://ctags.io/) or language-specific tools |

## 📄 License

[MIT](LICENSE) — Copyright (c) 2026 Shanlan
