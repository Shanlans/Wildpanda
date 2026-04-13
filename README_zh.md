<p align="center">
  <img src="assets/logo.png" alt="Wildpanda Logo" width="240" />
</p>

<h1 align="center">Wildpanda</h1>

<p align="center">
  <strong>AI 编程 Agent 的治理框架。</strong><br><br>
  放入任何代码仓库，即可获得结构化任务管理、<br>
  多会话安全和一键引导。
</p>

<p align="center">
  <a href="https://github.com/Shanlans/Wildpanda/releases/latest"><img src="https://img.shields.io/github/v/release/Shanlans/Wildpanda?style=for-the-badge&color=brightgreen&label=version" alt="Latest Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/Shanlans/Wildpanda?style=for-the-badge" alt="License"></a>
  <a href="https://github.com/Shanlans/Wildpanda/stargazers"><img src="https://img.shields.io/github/stars/Shanlans/Wildpanda?style=for-the-badge&color=yellow" alt="Stars"></a>
  <a href="https://github.com/Shanlans/Wildpanda/pulls"><img src="https://img.shields.io/github/issues-pr/Shanlans/Wildpanda?style=for-the-badge&color=blue" alt="PRs"></a>
</p>

<p align="center">
  <strong>🇨🇳 中文</strong> | <a href="README.md">🇬🇧 English</a>
</p>

<p align="center">
  <a href="#-为什么">为什么</a> •
  <a href="#-特性">特性</a> •
  <a href="#-快速开始">快速开始</a> •
  <a href="#-工作原理">工作原理</a> •
  <a href="#-技能">技能</a> •
  <a href="#-治理生命周期">生命周期</a> •
  <a href="#-许可证">许可证</a>
</p>

---

为 [Claude Code](https://claude.ai/claude-code) 构建。兼容任何能读取 Markdown 规范的 LLM 编程 Agent。

> **当前版本：v1.3.1**

## 🤔 为什么

AI 编程 Agent 能力很强但**无状态**。每次新会话都从零开始——不记得做过什么、正在做什么、其他会话在做什么。

| 问题 | 后果 |
|---|---|
| 🔄 **丢失上下文** | Agent 重复工作或与之前决策矛盾 |
| ⚡ **竞争条件** | 两个会话编辑同一文件，互相覆盖 |
| 🚫 **无质量关卡** | 变更未经构建验证或验收标准就上线 |
| 📉 **规则漂移** | 项目规则只在开发者脑中，不在代码库里 |

**Wildpanda** 通过将治理规则放进代码仓库——以 Markdown 规范的形式，让 Agent 在每次会话启动时读取。

## 🎯 特性

### 任务生命周期与状态机

7 个硬关卡的状态机，确保不跳过任何步骤：

```
PlanCreated → ReviewApproved → ImplementationDone → AcceptancePassed
  → ProcedureCompleted → PostReviewUpdated → Archived
```

- **通过/失败标准** — 每个任务在执行前必须定义可度量、可证伪的验收标准。
- **失败处置** — 标准未通过时，Agent 必须进行根因分析并分类：`RCA-inline`（当前任务修复）、`RCA-subtask`（新子任务）、`Criterion-revision`（标准误定）、`Known-limitation`（已知限制）。
- **强制结论** — 归档前必须填写：结果、证据、风险评估、下一步行动。
- **多任务分解** — 主任务 + 子任务索引，逐子任务独立验收和回滚。
- **效果质量叠加层** — 视觉/质量类任务额外增加：A/B 测试、路径命中验证、用户确认、失败回滚。

### 多会话安全

每个会话有唯一 `chat_id`，每个任务追踪归属会话。

- **心跳与超时检测** — 状态写入时更新 `Last Heartbeat At` 时间戳，默认 4 小时超时（可配置）。
- **硬关卡接管协议** — 新会话发现其他会话的任务时，必须询问用户才能接管。禁止静默接管。
- **会话索引** — `chat_index.md` 记录所有活跃任务、阶段、归属会话，新会话即时发现工作状态。
- **治理同步检查** — 会话启动时自动比较本地框架版本与上游，有更新时通知用户。

### 验收配置

四种可复用的验收等级，定义不同变更类型的"完成"标准：

| 等级 | 范围 | 验证方式 |
|---|---|---|
| **A0** 文档 | Markdown / 规范更新 | 无需构建 |
| **A1** 规范 / 配置 | 配置或规范变更 | 最小验证 |
| **A2** 代码变更 | 算法 / 库代码 | 完整构建 + 冒烟测试 |
| **A3** 发布 | 发布流程 | 完整发布验证 |

### 代码变更治理

- **注释覆盖触发** — Agent 读取源函数时发现注释缺失/不合规，必须在当前任务中补全。渐进式覆盖，非一次性补全。
- **函数级注释模板** — 标准 `@codex-comment` 格式：输入/输出接口、关键步骤、关键参数、状态/依赖。
- **注释审查工作流** — 三状态审查：`approved` → `pending` → 返工。用户可拒绝并要求重新验证。
- **内存与资源清理规则** — new/delete 配对、RAII 优先、跨阶段生命周期上下文。
- **读取审计追踪** — 每任务记录读取了哪些文件、原因、处理结果。审计为空时阻止状态推进。

### 规范优先与流程文档

修改已文档化流程中的函数时，必须**先更新流程规范，再写实现代码**。

- **流程自动发现** — 如果没有已有流程或修改的文件未被覆盖，`flow-discovery` 技能自动追踪调用链并生成流程规范。
- **调用图优先** — Agent 必须使用静态分析工具（ctags、cscope、pyan3、madge、go-callgraph）而非手动读代码。支持 5 种查询：查定义、查调用者、查被调用者、追踪调用链、影响分析。
- **多语言支持** — C/C++、Python、Java、JavaScript/TypeScript、Go、Rust。

### 引导与初始化

- **一键搭建** — 填写 JSON 模板，运行引导脚本，即得完整治理仓库。
- **治理状态检测** — 会话启动时自动检测治理结构是否缺失或不完整，触发引导。
- **模板与实例分离** — 通用规则在模板规范中，项目特有值在 `project_profile.yaml` 中。同步不覆盖实例文件。

### 治理漂移防护

- **规则重确认关卡** — 每个任务归档或停止后，Agent 必须重新读取 `AGENTS.md` 才能开始下一项工作。
- **任务治理决策** — 开始任何工作前，Agent 必须分类：`continue-tracked-task`（继续已有任务）、`new-task-required`（需要新任务）、`non-task-request`（非任务请求）。
- **构建规范绑定握手** — 执行构建命令前，Agent 必须声明使用哪个环境规范、验收等级和命令来源。
- **规范变更作用域** — 新规则分类为 `baseline`（进 `master_spec/`）或 `task-specific`（留在 `task/`）。默认：task-specific。

### 安全与作用域边界

- **仓库作用域** — 所有文件操作限于当前仓库内。系统目录和用户配置目录禁止访问。
- **第三方排除** — vendor / 3rdparty 代码默认排除在审查和编辑范围外，除非用户明确覆盖。
- **禁止命令** — 破坏性操作（`git reset --hard`、`rm -rf`、提权）未经明确批准不得执行。
- **变更纪律** — 最小定向编辑，保持风格一致，报告构建结果。

### 简明对话

- 短句子，一个要点一个列表项，不堆砌术语。
- 先说结论，再说原因。
- 推荐选项加粗标注。
- 跟随用户语言（中文 → 中文，英文 → 英文）。

## ⚡ 快速开始

### 方案 A：引导脚本（推荐）

```bash
# 1. 克隆 Wildpanda
git clone https://github.com/Shanlans/Wildpanda.git wildpanda-seed

# 2. 复制到你的项目
cp -r wildpanda-seed/AGENTS.md .
cp -r wildpanda-seed/master_spec/ .
cp -r wildpanda-seed/skill/ .

# 3. 填写项目信息
cp master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json my-input.json
# 编辑 my-input.json：项目名、构建命令、冒烟测试等

# 4. 运行引导
powershell -ExecutionPolicy Bypass \
  -File skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1 \
  -InputFile my-input.json
```

### 方案 B：手动设置

1. 复制 `AGENTS.md`、`master_spec/` 和 `skill/` 到仓库根目录。
2. 复制 `master_spec/initial_spec/starter_instance/*` 到对应子目录。
3. 从 `master_spec/project_profile_template.yaml` 创建 `project_profile.yaml`。
4. 创建空的 `task/` 和 `task/Achieve/` 目录。
5. 启动 Claude Code 会话，Agent 自动检测治理规范并遵循。

## 🔁 工作原理

<pre>
┌─────────────────────────────────────┐
│        Agent 会话启动                │
└──────────────────┬──────────────────┘
                   ▼
         ┌─────────────────────┐
         │  读取 AGENTS.md     │ ← 强制读取顺序
         └────────┬────────────┘
                  ▼
      ┌───────────────────────┐
      │  连续性检查            │
      │  • chat_index.md      │ ← 发现任务
      │  • 超时检测            │ ← 心跳 > 4h？
      │  • 治理同步            │ ← 上游更新？
      └───────────┬───────────┘
                  ▼
      ┌───────────────────────┐
      │  治理决策              │
      │  • 继续已有任务？       │
      │  • 创建新任务？         │
      │  • 非任务请求？         │
      └───────────┬───────────┘
                  ▼
    ┌─────────────────────────────┐
    │     任务生命周期              │
    │  计划 → 审查 → 实现          │
    │       → 验收 → 归档          │
    └─────────────┬───────────────┘
                  ▼
      ┌───────────────────────┐
      │  验收关卡              │
      │  • 构建通过？           │
      │  • 冒烟测试？           │
      │  • 标准达标？           │
      │  • 读取审计完成？        │
      │  • 注释已审查？         │
      └───────────┬───────────┘
                  ▼
      ┌───────────────────────┐
      │  规则重确认            │
      │  重读 AGENTS.md        │ ← 防止漂移
      └───────────┬───────────┘
                  ▼
      ┌───────────────────────┐
      │  会话结束              │
      │  心跳停止              │ ← 下次会话检测超时
      └───────────────────────┘
</pre>

## 🔧 技能

| 技能 | 用途 | 触发方式 |
|---|---|---|
| **bootstrap-governance** | 在新仓库初始化治理 | 自动（新项目）/ 手动："初始化治理" |
| **governance-sync** | 从上游拉取更新 | 自动（会话启动）/ 手动："检查治理更新" |
| **governance-contribute** | 通过 PR 回馈改进 | 手动："agent 更新" |
| **governance-release** | 打包发布新版本 | 手动："agent 正式发布" |
| **call-graph** | 查询函数调用关系 | 自动（追踪调用时）/ 手动："查调用关系" |
| **flow-discovery** | 发现并记录调用流程 | 自动（flow catalog 为空）/ 手动："分析 flow" |

## 🔄 治理生命周期

```
上游 (Wildpanda)                    消费项目
┌───────────────┐                  ┌───────────────┐
│  最新版本      │───── 同步 ──────▶│ 拉取更新       │
│               │                  │               │
│  master       │◀── 贡献 (PR) ────│ 推送改进       │
│               │                  │               │
│  发布 PR       │◀── 发布 ─────────│ 打包新版本      │
│  (维护者合并    │                  │               │
│   + 打 tag)   │                  │               │
└───────────────┘                  └───────────────┘
```

## 📁 仓库结构

```
AGENTS.md                              # Agent 入口
VERSION                                # 框架版本 (semver)
CHANGELOG.md                           # 发布历史

master_spec/                           # 治理规范
├── project_profile_template.yaml      # 实例配置模板
├── chat_spec/chat_spec.md             # 会话连续性、多租户
├── task_spec/task_spec.md             # 任务生命周期、状态机
├── coding_spec/coding_spec.md         # 编码风格、内存规则
├── comment_spec/comment_spec.md       # 注释覆盖、审查工作流
├── read_audit_spec/read_audit_spec.md # 读取审计追踪
├── skill_spec/skill_spec.md           # 技能路由、发布管线
├── acceptance_spec/                   # 验收配置 (A0-A3)
├── procedure_spec/                    # 操作流程
├── flow_spec/                         # 流程模板、目录
└── initial_spec/                      # 引导、边界、传播

skill/                                 # 技能
├── bootstrap-governance/              # 🚀 初始化引导
├── governance-sync/                   # 🔄 同步
├── governance-contribute/             # 📤 贡献
├── governance-release/                # 📦 发布
├── call-graph/                        # 🔍 调用图分析
└── flow-discovery/                    # 🗺️ 流程发现
```

## 🏗️ 核心设计决策

- **任务文件 = 唯一真相源。** 运行时状态在 `task/<task>.md` 中。
- **禁止静默接管。** Agent 接管其他会话的任务前必须询问。
- **模板与实例分离。** 通用规则在模板中，项目配置在 `project_profile.yaml` 中。
- **规范优先，非代码优先。** 先更新流程规范，再改代码。
- **工具优先，非手动优先。** 用静态分析工具查调用关系，不手动读代码。
- **仅 PR 策略。** v1.1.0 后所有变更必须通过 PR。
- **关卡驱动，非信任驱动。** 每次状态推进都需要证据，不靠 Agent 自述。

## 🔧 兼容性

| | |
|---|---|
| **主要目标** | Claude Code (Anthropic) |
| **也兼容** | 任何能读 Markdown 的 LLM Agent |
| **操作系统** | Windows（PowerShell 引导）、Linux/macOS（手动或适配脚本） |
| **依赖** | 核心无依赖 — 纯 markdown + YAML |
| **治理技能** | 需要 [GitHub CLI (`gh`)](https://cli.github.com/) |
| **调用图** | 需要 [Universal Ctags](https://ctags.io/) 或语言专用工具 |

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Shanlans/Wildpanda&type=Date)](https://star-history.com/#Shanlans/Wildpanda&Date)

## 📄 许可证

[MIT](LICENSE) — Copyright (c) 2026 Shanlan
