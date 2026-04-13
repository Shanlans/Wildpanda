---
name: flow-discovery
description: Automatically discover and document the primary call flow of a project using the call-graph skill. Use when flow_catalog is empty or when modified files are not covered by any existing flow.
---

# Flow Discovery

Discover the primary call flow of a project and generate flow spec documentation. This skill uses the **call-graph** skill for all call relationship analysis.

## Dependency

- **Requires**: `skill/call-graph/SKILL.md`
- Flow-discovery does NOT read code directly. All call chain tracing is delegated to the call-graph skill.
- If call-graph pre-check fails (tool not installed), flow-discovery also stops.

## Prerequisites

### call-graph skill must pass pre-check
- `project_profile.yaml` must have `call_graph` section configured.
- Static analysis tool must be installed and working.
- See `skill/call-graph/SKILL.md` → Prerequisites for details.

### flow_discovery configuration
- `project_profile.yaml` must have `flow_discovery` section (see Configuration below).
- If missing → prompt user to configure, **stop**.

## Configuration

### `project_profile.yaml` — `flow_discovery` section

```yaml
flow_discovery:
  max_depth: 3                     # max call chain depth (passed to call-graph Q4)
  entry_from: "test_entry"         # "test_entry" (use paths.test_entry) or "manual"
  entry_points:                    # manual entry points (used when entry_from: "manual")
    - "src/main.cpp::main"
```

- `max_depth`: how many levels to trace. Default: 3.
- `entry_from`: where to find entry points.
  - `"test_entry"`: use `paths.test_entry` from project_profile.yaml.
  - `"manual"`: use `entry_points` list.
- Language, tool, and exclude patterns are inherited from the `call_graph` section — no duplication.

## Trigger / 触发条件

- **Automatic / 自动**: during mandatory read order (AGENTS.md §3 step 14), when:
  在 AGENTS.md §3 step 14 读 flow_catalog 时，满足以下条件自动触发：
  - A) `flow_catalog.md` has no active entries (empty catalog) / flow catalog 为空
  - B) task involves code changes to files not covered by any existing flow / 修改的文件不在任何已有 flow 覆盖范围
- **Manual / 手动**: user invokes directly. / 用户直接调用。
- **Keyword triggers / 关键词触发**:
  - "分析 flow" / "analyze flow"
  - "梳理调用链" / "trace call chain"
  - "发现 flow" / "discover flow"
  - "生成 flow spec" / "generate flow spec"
  - "自动识别主流程" / "auto-detect main flow"

## Not Triggered When

- Task is A0 (documentation only) or A1 (spec only) — no code changes.
- flow_catalog.md already has active flows covering the modified files.
- `flow_discovery` section is not configured in project_profile.yaml (prompt to configure, do not auto-run).

## Discovery Flow

### Step 1: Determine Entry Points
- If `entry_from: "test_entry"`:
  - Read `project_profile.yaml` → `paths.test_entry` → list of entry files.
  - Use call-graph **Q1 (Find Definition)** to locate `main()` or equivalent in each file.
- If `entry_from: "manual"`:
  - Use `entry_points` list directly.
  - Validate each entry exists via call-graph Q1.
- If no entry points found → ask user to specify, **stop**.

### Step 2: Trace Call Chain
- For each entry point, invoke call-graph **Q4 (Trace Call Chain)** with `max_depth`.
- Collect the full indented call tree output.
- If multiple entry points produce overlapping call trees, merge them.

### Step 3: Identify Pipeline Stages
- Analyze the level-1 calls (direct children of entry) as candidate pipeline stages.
- Group into logical stages based on call order:
  - e.g., `Init → Load → Preprocess → Process → Postprocess → Output`
- Heuristics for stage identification:
  - Level-1 functions called sequentially from entry = distinct stages
  - Functions with clearly different concerns (I/O, computation, cleanup) = stage boundaries
- If pipeline structure is unclear → present flat call tree instead.

### Step 4: Present to User
Display:
- Entry point(s) found
- Call tree (from call-graph Q4 output):
  ```
  main() [main.cpp:10]
  ├── Init() [app.cpp:25]
  │   ├── LoadConfig() [config.cpp:12]
  │   └── InitModules() [modules.cpp:8]
  ├── Process() [pipeline.cpp:50]
  │   ├── Preprocess() [preprocess.cpp:15]
  │   ├── CoreAlgorithm() [algo.cpp:100]
  │   └── Postprocess() [postprocess.cpp:30]
  └── Cleanup() [app.cpp:200]
  ```
- Suggested pipeline stages
- Suggested flow name
- Any call-graph limitations noted (`[virtual]`, `[function pointer]`, etc.)
- Ask: "Create flow spec from this analysis? (Y/N)"
- If user declines → **end**.

### Step 5: Generate Flow Spec
- Create `master_spec/flow_spec/<flow_name>.flow.md` using FLOW_TEMPLATE.md structure:
  - Metadata: flow name, entry, path, owner, date
  - Primary Call Path: stage summary from Step 3
  - Function-Level Call Path: call tree from Step 2
- Display draft to user for review before writing.

### Step 6: Update Flow Catalog
- Add entry to `master_spec/flow_spec/flow_catalog.md`:
  ```
  | F<next_id> | <flow_name> | <scope_description> | master_spec/flow_spec/<flow_name>.flow.md | active |
  ```

### Step 7: Cleanup
- Call-graph index cleanup is handled by the call-graph skill.
- No additional cleanup needed.

## Important Notes
- This skill generates flow documentation only. It does not modify source code.
- All call relationship analysis is delegated to the call-graph skill. Flow-discovery never reads source code directly for call tracing.
- The generated flow spec is a starting point based on static analysis. User review is mandatory.
- All generated files are instance-owned (flow specs and catalog entries are project-specific).
- `max_depth: 3` keeps the initial analysis manageable. Deeper levels can be added incrementally.
- If the call-graph skill reports limitations (virtual dispatch, function pointers), these are noted in the flow spec for manual review.
