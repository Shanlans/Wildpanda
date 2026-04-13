---
name: call-graph
description: Query function call relationships using static analysis tools. Use whenever you need to answer "who calls X" or "what does X call" — prefer this over reading code manually.
---

# Call Graph

Query function call relationships using static analysis tools. This is a low-level utility skill — other skills (e.g., flow-discovery) and the agent's own problem-solving should use it instead of manually reading code to trace calls.

## Priority Rule

**Tool-first, not code-first.** When the agent needs to understand call relationships (debugging, impact analysis, refactoring, flow tracing, or any code investigation), it must:
1. Use this skill if a supported tool is configured and available.
2. Only fall back to manual code reading if the tool is not installed AND the user declines to install it.

This rule applies to all contexts: task execution, problem-solving, code review, and flow analysis.

## Prerequisites

### Static Analysis Tool (at least one required)

#### Supported Tools

| Tool | Languages | Capability | Install |
|---|---|---|---|
| **Universal Ctags** | C/C++, Python, Java, JS/TS, Go, Rust, 40+ more | Symbol index — find definitions, references, and call sites | Windows: `winget install universal-ctags.ctags`; Linux: `sudo apt install universal-ctags`; macOS: `brew install universal-ctags` |
| **cscope** | C/C++ (best), Java (limited) | Call graph — "who calls X" and "X calls who" | Windows: MSYS2/Git Bash; Linux: `sudo apt install cscope`; macOS: `brew install cscope` |
| **pyan3** | Python | Static call graph for Python | `pip install pyan3` |
| **madge** | JS/TS | Module dependency graph (import/require) | `npm install -g madge` |
| **go callgraph** | Go | Call graph for Go programs | `go install golang.org/x/tools/cmd/callgraph@latest` |

#### Language-Tool Matrix

| Language | Primary Tool | Secondary Tool |
|---|---|---|
| C/C++ | ctags + cscope | ctags only |
| Python | ctags + pyan3 | ctags only |
| Java | ctags | — |
| JavaScript/TypeScript | ctags + madge | ctags only |
| Go | ctags + go callgraph | ctags only |
| Rust | ctags | — |
| Other | ctags | — |

### Pre-Check (mandatory before any query)
1. Read `project_profile.yaml` → `call_graph` section.
   - If missing → prompt user to configure (see Configuration), **stop**.
2. Detect configured tool on PATH.
   - Not found → display install command for detected OS, ask user to install, **stop**.
3. Verify tool:
   - ctags: `ctags --version` (must show "Universal Ctags")
   - cscope: `cscope --version`
   - Other: `<tool> --version`
   - Fails → suggest reinstall, **stop**.

## Configuration

### `project_profile.yaml` — `call_graph` section

```yaml
call_graph:
  language: "cpp"                  # cpp / python / java / js / ts / go / rust
  tool: "ctags"                    # ctags / cscope / pyan3 / madge / go-callgraph
  source_dirs:                     # directories to index (relative to repo root)
    - "src"
    - "lib"
  exclude_patterns:                # paths to skip
    - "3rdparty/**"
    - "test/**"
    - "vendor/**"
    - "node_modules/**"
  index_cache: true                # reuse index if source unchanged (default: true)
```

- `language`: determines call pattern recognition.
- `tool`: which analysis tool to use.
- `source_dirs`: scope of analysis. If omitted, defaults to repo root.
- `exclude_patterns`: reuse `exclusions.third_party` if not specified separately.
- `index_cache`: if true, reuse `.tags` / `.cscope.out` between queries in the same session. Rebuild if source files changed.

## Trigger / 触发条件

- **Automatic / 自动**: whenever the agent needs call relationship information during any task (see Priority Rule above).
  agent 在任何任务中需要查调用关系时自动使用（见上方优先规则）。
- **Manual / 手动**: user invokes directly.
  用户直接调用。
- **Called by other skills / 被其他 skill 调用**: flow-discovery uses this skill for its call chain tracing.
  flow-discovery 通过此 skill 追踪调用链。
- **Keyword triggers / 关键词触发**:
  - "查调用关系" / "show call graph"
  - "谁调用了" / "who calls"
  - "调用了什么" / "what does it call"
  - "调用链" / "call chain"
  - "函数调用分析" / "function call analysis"
  - "show callers" / "show callees" / "trace calls"

## Supported Queries

### Q1: Find Definition
- **Question**: "Where is function X defined?"
- **ctags**: `grep "^X\t" .tags` → file, line, kind
- **cscope**: `cscope -d -L1 X` → definition location
- **Output**: `X defined at file.cpp:123`

### Q2: Find Callers (who calls X)
- **Question**: "Who calls function X?" / "谁调用了 X"
- **ctags**: search for `X(` pattern across indexed files (approximate)
- **cscope**: `cscope -d -L3 X` → list of callers with file:line
- **Output**:
  ```
  Callers of X():
    A() [fileA.cpp:45]
    B() [fileB.cpp:120]
    C() [fileC.cpp:88]
  ```

### Q3: Find Callees (what does X call)
- **Question**: "What does function X call?" / "X 调用了什么"
- **ctags**: read function body, match symbols against index
- **cscope**: `cscope -d -L2 X` → list of functions called by X
- **Output**:
  ```
  X() calls:
    foo() [util.cpp:30]
    bar() [helper.cpp:55]
    baz() [core.cpp:200]
  ```

### Q4: Trace Call Chain (depth-limited)
- **Question**: "Trace calls from X, 3 levels deep"
- **Method**: recursive Q3, up to specified depth
- **Output**: indented call tree
  ```
  X() [main.cpp:10]
  ├── A() [mod.cpp:25]
  │   ├── A1() [util.cpp:40]
  │   └── A2() [util.cpp:60]
  ├── B() [core.cpp:100]
  │   └── B1() [core.cpp:150]
  └── C() [io.cpp:30]
  ```

### Q5: Impact Analysis
- **Question**: "What is affected if I change function X?"
- **Method**: Q2 (callers) recursively upward, up to specified depth
- **Output**: reverse call tree showing all paths that reach X

## Execution

### Step 1: Build or Reuse Index
- If `index_cache: true` and index exists and source files unchanged → reuse.
- Otherwise build:
  - **ctags**: `ctags -R --fields=+niKS --extras=+q --exclude=<patterns> -o .tags <source_dirs>`
  - **cscope**: `find <source_dirs> -name "*.c" -o -name "*.cpp" -o -name "*.h" | cscope -R -b -i- -f .cscope.out`
  - **pyan3**: runs per-query, no persistent index
  - **madge**: runs per-query
  - **go callgraph**: runs per-query

### Step 2: Execute Query
- Run the appropriate query command (see Supported Queries above).
- Parse tool output into structured format.
- Filter out excluded paths and standard library symbols.

### Step 3: Present Results
- Display results in the format shown above.
- For large result sets (>20 entries), summarize and ask if user wants full list.
- Note any limitations:
  - `[virtual]` — C++ virtual method, actual target depends on runtime type
  - `[macro]` — call through macro expansion, may not be fully resolved
  - `[function pointer]` — indirect call, static analysis cannot resolve target
  - `[template]` — C++ template instantiation, multiple possible targets

### Step 4: Cleanup (session end or on request)
- If `index_cache: false`, remove temporary index files:
  - `.tags`
  - `.cscope.out`, `.cscope.po.out`, `.cscope.in.out`
- If `index_cache: true`, keep for reuse. Warn user if index is stale (source modified after index creation).

## Important Notes
- Static analysis tools provide best-effort results. They do not execute code.
- Virtual dispatch, function pointers, and runtime polymorphism cannot be fully resolved by static analysis. Agent should note these as limitations.
- For C++ projects, ctags + cscope together give the best coverage. ctags alone can find definitions but is weaker at finding callers.
- Index files can be large for big projects. The `exclude_patterns` configuration is important for keeping analysis tractable.
- This skill is a utility — it answers specific questions. It does not generate documentation. For flow documentation, use the flow-discovery skill.
