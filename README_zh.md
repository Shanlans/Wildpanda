<p align="center">
  <img src="assets/logo.png" alt="Wildpanda Logo" width="120" />
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
  <a href="#-你会得到什么">你会得到什么</a> •
  <a href="#-快速开始">快速开始</a> •
  <a href="#-工作原理">工作原理</a> •
  <a href="#-技能">技能</a> •
  <a href="#-治理生命周期">生命周期</a> •
  <a href="#-许可证">许可证</a>
</p>

---

为 [Claude Code](https://claude.ai/claude-code) 构建。兼容任何能读取 Markdown 规范的 LLM 编程 Agent。

## 🤔 为什么

AI 编程 Agent 能力很强但**无状态**。每次新会话都从零开始——不记得做过什么、正在做什么、其他会话在做什么。

| 问题 | 后果 |
|---|---|
| 🔄 **丢失上下文** | Agent 重复工作或与之前决策矛盾 |
| ⚡ **竞争条件** | 两个会话编辑同一文件，互相覆盖 |
| 🚫 **无质量关卡** | 变更未经构建验证或验收标准就上线 |
| 📉 **规则漂移** | 项目规则只在开发者脑中，不在代码库里 |

**Wildpanda** 通过将治理规则放进代码仓库——以 Markdown 规范的形式，让 Agent 在每次会话启动时读取。

## 🎯 你会得到什么

| 能力 | 描述 |
|---|---|
| 📋 **任务生命周期** | 状态机驱动：`PlanCreated` → `ReviewApproved` → `ImplementationInProgress` → `AcceptancePassed` → `Archived`。每个任务都有通过/失败标准和强制结论。 |
| 🔒 **多会话安全** | 会话标识（`chat_id`）、心跳时间戳、4 小时超时检测、强制接管协议。 |
| ✅ **验收配置** | `A0` 文档 / `A1` 规范 / `A2` 代码（构建 + 冒烟）/ `A3` 发布。四种验收等级，明确定义"完成"的标准。 |
| 🔄 **会话连续性** | 每次新会话自动读取 `chat_index.md` → 发现活跃任务 → 检测过期会话 → 从上次中断处继续。 |
| 🚀 **一键引导** | 填写 JSON 模板，运行脚本，完成。 |
| 📖 **规范优先** | Agent 先读规范再写代码。流程规范记录调用链，注释规范强制审查。 |
| 🔍 **调用图分析** | 工具优先的调用关系分析，Agent 使用静态分析工具而非手动读代码。 |

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
├── chat_spec/chat_spec.md             # 会话恢复、多租户
├── task_spec/task_spec.md             # 任务生命周期
├── coding_spec/coding_spec.md         # 编码风格
├── comment_spec/comment_spec.md       # 注释审查
├── read_audit_spec/read_audit_spec.md # 读取审计
├── skill_spec/skill_spec.md           # 技能路由
├── acceptance_spec/                   # 验收配置
├── procedure_spec/                    # 流程定义
├── flow_spec/                         # 流程模板
└── initial_spec/                      # 引导与边界

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

## 🔧 兼容性

| | |
|---|---|
| **主要目标** | Claude Code (Anthropic) |
| **也兼容** | 任何能读 Markdown 的 LLM Agent |
| **操作系统** | Windows（PowerShell 引导）、Linux/macOS（手动或适配脚本） |
| **依赖** | 核心无依赖 — 纯 markdown + YAML |
| **治理技能** | 需要 [GitHub CLI (`gh`)](https://cli.github.com/) |
| **调用图** | 需要 [Universal Ctags](https://ctags.io/) 或语言专用工具 |

## 📄 许可证

[MIT](LICENSE) — Copyright (c) 2026 Shanlan
