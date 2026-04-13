<p align="center">
  <img src="assets/logo.png" alt="Wildpanda Logo" width="120" />
</p>

<h1 align="center">Wildpanda</h1>

<p align="center">
  <strong>A governance framework for AI coding agents.</strong><br>
  <strong>AI 编程 Agent 的治理框架。</strong><br><br>
  Drop it into any repository and get structured task management,<br>
  multi-session safety, and one-command bootstrap — out of the box.<br>
  放入任何代码仓库，即可获得结构化任务管理、多会话安全和一键引导。
</p>

<p align="center">
  <a href="https://github.com/Shanlans/Wildpanda/releases/latest"><img src="https://img.shields.io/github/v/release/Shanlans/Wildpanda?style=for-the-badge&color=brightgreen&label=version" alt="Latest Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/Shanlans/Wildpanda?style=for-the-badge" alt="License"></a>
  <a href="https://github.com/Shanlans/Wildpanda/stargazers"><img src="https://img.shields.io/github/stars/Shanlans/Wildpanda?style=for-the-badge&color=yellow" alt="Stars"></a>
  <a href="https://github.com/Shanlans/Wildpanda/pulls"><img src="https://img.shields.io/github/issues-pr/Shanlans/Wildpanda?style=for-the-badge&color=blue" alt="PRs"></a>
</p>

<p align="center">
  <a href="#-why--为什么">Why / 为什么</a> •
  <a href="#-what-you-get--你会得到什么">What You Get</a> •
  <a href="#-quick-start--快速开始">Quick Start</a> •
  <a href="#-how-it-works--工作原理">How It Works</a> •
  <a href="#-skills--技能">Skills</a> •
  <a href="#-governance-lifecycle--治理生命周期">Lifecycle</a> •
  <a href="#-license--许可证">License</a>
</p>

---

Built for [Claude Code](https://claude.ai/claude-code). Works with any LLM-based coding agent that reads markdown specs.

为 [Claude Code](https://claude.ai/claude-code) 构建。兼容任何能读取 Markdown 规范的 LLM 编程 Agent。

## 🤔 Why / 为什么

AI coding agents are powerful but **stateless**. Every new chat session starts from scratch — no memory of what was done, what's in progress, or what another session is working on.

AI 编程 Agent 能力很强但**无状态**。每次新会话都从零开始——不记得做过什么、正在做什么、其他会话在做什么。

| Problem / 问题 | What happens / 后果 |
|---|---|
| 🔄 **Lost context / 丢失上下文** | Agent repeats work or contradicts previous decisions / Agent 重复工作或与之前决策矛盾 |
| ⚡ **Race conditions / 竞争条件** | Two sessions edit the same file, one overwrites the other / 两个会话编辑同一文件，互相覆盖 |
| 🚫 **No quality gate / 无质量关卡** | Changes ship without build verification or acceptance criteria / 变更未经构建验证或验收标准就上线 |
| 📉 **Drift / 规则漂移** | Project rules live in the developer's head, not in the repo / 项目规则只在开发者脑中，不在代码库里 |

**Wildpanda solves this** by putting governance into the repository itself — as markdown specs that the agent reads on every session start.

**Wildpanda** 通过将治理规则放进代码仓库——以 Markdown 规范的形式，让 Agent 在每次会话启动时读取。

## 🎯 What You Get / 你会得到什么

| Capability / 能力 | Description / 描述 |
|---|---|
| 📋 **Task Lifecycle / 任务生命周期** | State machine: `PlanCreated` → `ReviewApproved` → `ImplementationInProgress` → `AcceptancePassed` → `Archived`. Every task has pass/fail criteria and mandatory conclusion. / 状态机驱动，每个任务都有通过/失败标准和强制结论。 |
| 🔒 **Multi-Tenancy / 多会话安全** | Chat identity (`chat_id`), heartbeat timestamps, stale detection (default 4h), and a hard-gate takeover protocol. / 会话标识、心跳时间戳、4 小时超时检测、强制接管协议。 |
| ✅ **Acceptance Profiles / 验收配置** | `A0` docs / `A1` spec / `A2` code (build + smoke) / `A3` release. Each profile defines exactly what "done" means. / 四种验收等级，明确定义"完成"的标准。 |
| 🔄 **Session Continuity / 会话连续性** | Every new chat reads `chat_index.md` → discovers active tasks → checks for stale sessions → resumes where things left off. / 每次新会话自动发现活跃任务、检测过期会话、从上次中断处继续。 |
| 🚀 **Bootstrap / 一键引导** | One command sets up governance in a new repo. Fill a JSON template, run the script, done. / 填写 JSON 模板，运行脚本，完成。 |
| 📖 **Spec-First / 规范优先** | Agent reads specs before writing code. Flow specs document call chains. Comment specs enforce review. / Agent 先读规范再写代码。 |
| 🔍 **Call Graph / 调用图分析** | Tool-first call relationship analysis. Agent uses static analysis tools instead of manually reading code. / 工具优先的调用关系分析，Agent 使用静态分析工具而非手动读代码。 |

## ⚡ Quick Start / 快速开始

### Option A: Bootstrap script (recommended) / 方案 A：引导脚本（推荐）

```bash
# 1. Clone Wildpanda / 克隆 Wildpanda
git clone https://github.com/Shanlans/Wildpanda.git wildpanda-seed

# 2. Copy into your project / 复制到你的项目
cp -r wildpanda-seed/AGENTS.md .
cp -r wildpanda-seed/master_spec/ .
cp -r wildpanda-seed/skill/ .

# 3. Fill your project facts / 填写项目信息
cp master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json my-input.json
# Edit my-input.json: project name, build command, smoke test, etc.
# 编辑 my-input.json：项目名、构建命令、冒烟测试等

# 4. Run bootstrap / 运行引导
powershell -ExecutionPolicy Bypass \
  -File skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1 \
  -InputFile my-input.json
```

### Option B: Manual setup / 方案 B：手动设置

1. Copy `AGENTS.md`, `master_spec/`, and `skill/` into your repo root. / 复制到仓库根目录。
2. Copy `master_spec/initial_spec/starter_instance/*` into corresponding `master_spec/` subdirs. / 复制启动模板到对应子目录。
3. Create `project_profile.yaml` from `master_spec/project_profile_template.yaml`. / 从模板创建项目配置。
4. Create empty `task/` and `task/Achieve/` directories. / 创建空的任务目录。
5. Start a Claude Code session — the agent detects governance and follows the specs. / 启动 Claude Code 会话，Agent 自动检测治理规范并遵循。

## 🔁 How It Works / 工作原理

<pre>
┌─────────────────────────────────────────────────────────────┐
│          Agent Session Start / Agent 会话启动                │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
                 ┌─────────────────────┐
                 │  Read AGENTS.md     │ ← mandatory read order
                 │  读取治理规范        │   强制读取顺序
                 └────────┬────────────┘
                          ▼
              ┌───────────────────────┐
              │  Continuity Check     │
              │  连续性检查            │
              │  • chat_index.md      │ ← discover tasks / 发现任务
              │  • stale detection    │ ← heartbeat > 4h? / 心跳超时？
              │  • governance sync    │ ← upstream updates? / 上游更新？
              └───────────┬───────────┘
                          ▼
            ┌─────────────────────────────┐
            │     Task Lifecycle           │
            │     任务生命周期              │
            │  Plan → Review → Implement  │
            │       → Accept → Archive    │
            └─────────────┬───────────────┘
                          ▼
              ┌───────────────────────┐
              │  Acceptance Gate      │
              │  验收关卡              │
              │  • Build pass? / 构建？│
              │  • Smoke test? / 冒烟？│
              │  • Criteria met?/达标？│
              └───────────┬───────────┘
                          ▼
              ┌───────────────────────┐
              │  Session End          │
              │  会话结束              │
              │  Heartbeat stops      │ ← next session detects
              │  心跳停止              │   下次会话检测超时
              └───────────────────────┘
</pre>

## 🔧 Skills / 技能

| Skill / 技能 | Purpose / 用途 | Trigger / 触发方式 |
|---|---|---|
| **bootstrap-governance** | Set up governance in a new repo / 在新仓库初始化治理 | Auto (new project) / Manual: "初始化治理" "bootstrap governance" |
| **governance-sync** | Pull updates from upstream Wildpanda / 从上游拉取更新 | Auto (session start) / Manual: "检查治理更新" "sync governance" |
| **governance-contribute** | Contribute improvements back via PR / 通过 PR 回馈改进 | Manual: "agent 更新" "contribute back" |
| **governance-release** | Package merged PRs into a release / 打包发布新版本 | Manual: "agent 正式发布" "prepare release" |
| **call-graph** | Query function call relationships / 查询函数调用关系 | Auto (when tracing calls) / Manual: "查调用关系" "call graph" |
| **flow-discovery** | Discover and document call flows / 发现并记录调用流程 | Auto (empty flow catalog) / Manual: "分析 flow" "discover flow" |

## 🔄 Governance Lifecycle / 治理生命周期

```
Upstream (Wildpanda)               Consuming Project / 消费项目
上游 (Wildpanda)
┌───────────────┐                  ┌───────────────┐
│  Latest       │───── sync ──────▶│ Pull updates  │
│  最新版本      │     同步          │ 拉取更新       │
│               │                  │               │
│  master       │◀── contribute ───│ Push changes  │
│               │    贡献 (PR)      │ 推送改进       │
│               │                  │               │
│  release PR   │◀── release ──────│ Package new   │
│  发布 PR       │    发布           │ version       │
│  (maintainer  │                  │ 打包新版本      │
│   merges+tag) │                  │               │
└───────────────┘                  └───────────────┘
```

## 📁 Repository Structure / 仓库结构

```
AGENTS.md                              # Agent entry point / Agent 入口
VERSION                                # Framework version / 框架版本 (semver)
CHANGELOG.md                           # Release history / 发布历史

master_spec/                           # Governance specs / 治理规范
├── project_profile_template.yaml      # Instance config template / 实例配置模板
├── chat_spec/chat_spec.md             # Session resume, multi-tenancy / 会话恢复、多租户
├── task_spec/task_spec.md             # Task lifecycle / 任务生命周期
├── coding_spec/coding_spec.md         # Coding style / 编码风格
├── comment_spec/comment_spec.md       # Comment review / 注释审查
├── read_audit_spec/read_audit_spec.md # Read audit / 读取审计
├── skill_spec/skill_spec.md           # Skill routing / 技能路由
├── acceptance_spec/                   # Acceptance profiles / 验收配置
├── procedure_spec/                    # Procedures / 流程定义
├── flow_spec/                         # Flow templates / 流程模板
└── initial_spec/                      # Bootstrap & boundary / 引导与边界

skill/                                 # Skills / 技能
├── bootstrap-governance/              # 🚀 Bootstrap / 初始化引导
├── governance-sync/                   # 🔄 Sync / 同步
├── governance-contribute/             # 📤 Contribute / 贡献
├── governance-release/                # 📦 Release / 发布
├── call-graph/                        # 🔍 Call graph analysis / 调用图分析
└── flow-discovery/                    # 🗺️ Flow discovery / 流程发现
```

## 🏗️ Key Design Decisions / 核心设计决策

- **Task file = single source of truth. / 任务文件 = 唯一真相源。** Runtime state lives in `task/<task>.md`. / 运行时状态在任务文件中。
- **Silent takeover forbidden. / 禁止静默接管。** Agent must ask before claiming another session's task. / Agent 接管其他会话的任务前必须询问。
- **Template vs instance separation. / 模板与实例分离。** Reusable rules in template specs, project values in `project_profile.yaml`. / 通用规则在模板中，项目配置在 profile 中。
- **Spec-first, not code-first. / 规范优先，非代码优先。** Flow specs before code changes. / 先更新流程规范，再改代码。
- **Tool-first, not manual-first. / 工具优先，非手动优先。** Use static analysis tools for call tracing, not manual code reading. / 用静态分析工具查调用关系，不手动读代码。
- **PR-only policy. / 仅 PR 策略。** After v1.1.0, all changes go through pull requests. / v1.1.0 后所有变更必须通过 PR。

## 🔧 Compatibility / 兼容性

| | |
|---|---|
| **Primary target / 主要目标** | Claude Code (Anthropic) |
| **Also works with / 也兼容** | Any LLM coding agent that reads markdown / 任何能读 Markdown 的 LLM Agent |
| **OS / 操作系统** | Windows (PowerShell bootstrap), Linux/macOS (manual or adapt scripts) |
| **Dependencies / 依赖** | None for core / 核心无依赖 — pure markdown + YAML |
| **Governance skills / 治理技能** | Require [GitHub CLI (`gh`)](https://cli.github.com/) |
| **Call graph / 调用图** | Require [Universal Ctags](https://ctags.io/) or language-specific tools / 需要 ctags 或语言专用工具 |

## 📄 License / 许可证

[MIT](LICENSE) — Copyright (c) 2026 Shanlan
