# Coding Spec Governance

## Metadata
- Path: `master_spec/coding_spec/coding_spec.md`
- Owner: Shanlan
- Last updated: 2026-03-06

## 1. Purpose
- Define repository-level coding style and implementation rules.
- Keep coding constraints decoupled from task-specific validation requirements.

## 2. Scope
- Applies to all code changes under repository source modules.
- This file governs baseline coding style only.
- Task-specific requirements must stay in `task/**` and must not pollute this baseline spec.

## 3. Baseline Style Rules
1. Keep changes minimal and local.
2. Preserve existing module architecture and call chain unless task explicitly requires refactor.
3. Reuse existing naming and data-flow conventions in touched files.
4. Keep APIs backward-compatible unless interface change is explicitly approved.

## 4. Code Writing Rules
1. Naming and readability
- Use meaningful names for new variables/functions.
- Avoid one-letter identifiers except short loop indices.
- Prefer explicit constants over magic numbers when reused.

2. Cross-platform compatibility (mandatory)
- New/modified code must compile on both Android toolchain and MSVC toolchain.
- Avoid MSVC-only secure CRT APIs in cross-platform code paths, including but not limited to:
  - `fopen_s`
  - `strcpy_s` / `strncpy_s`
  - `sprintf_s` / `snprintf_s` variants that are not portable across target toolchains
- Prefer portable alternatives (or local wrappers) that are available on both Android and MSVC.
- If platform-specific implementation is unavoidable, isolate it behind explicit platform macros and provide both branches.

3. Control flow
- Favor early-return for invalid states.
- Keep branch logic deterministic and testable.
- Avoid introducing hidden side effects in utility functions.

4. Logging and debug behavior
- Debug output must be gated by existing switches/flags.
- Temporary forced debug logic must be removable and recorded in task file.
- Runtime dump paths and filenames should be stable and traceable.

5. Error handling
- Validate pointers/sizes/ranges before use.
- Fail fast on invalid inputs; avoid silent fallback unless required by legacy behavior.

6. Memory and resource cleanup (mandatory)
- Do not use `new` followed by pointer overwrite in the same scope (for example `p = new T; p = Func();`), which causes leaks.
- Any heap object created by `new/new[]` must have a clear ownership rule and matching `delete/delete[]` on all paths.
- Prefer RAII (`std::unique_ptr`, stack object, container-managed lifetime) over raw `new/delete` in new code.
- For functions with multiple early returns, use one unified cleanup path or RAII guards to avoid path-specific leaks.
- Temporary image/buffer objects must be released immediately after last use.
- For image-like members/containers (for example `CGrayImage`, `CMultiChannelImage`, mask/grid buffers), if downstream functions no longer consume them in current flow, call `Clear()` promptly to release memory/state.
- Class members should be explicitly `Clear()`/reset when it is confirmed they are no longer used by subsequent context in the current flow, to prevent stale data carry-over.

7. Member usage context definition (for cleanup decision)
- Cross-stage: member data passed from one pipeline stage to a later stage in the same request path.
- Cross-function: member data read/written by multiple functions (including callee chains), not only the current function.
- Cross-file: member data consumed by functions implemented in other translation units/modules.
- Cleanup decision rule:
  - If member data is still needed by any cross-stage / cross-function / cross-file consumer, do not clear early.
  - Once confirmed no subsequent consumer exists in current execution context, clear/reset immediately.
  - Verification must follow real object/dataflow, not variable-name matching only.
  - When formal parameter names and actual argument names differ, trace ownership/lifetime through caller-callee dataflow before deciding whether `Clear()/reset/delete` is required.

8. Image-class cleanup scope (mandatory)
- The following image/data-array classes are under mandatory lifecycle check for timely `Clear()` when confirmed no longer needed in subsequent context (cross-stage / cross-function / cross-file):
  - `CBGRImage`
  - `CGrayImageShort`
  - `CGrayImage`
  - `CLabelImage32`
  - `CYUV422Image`
  - `CMultiChannelImage`
  - `CMultiChannelImage_WORD`
  - `CMultiChannelImage_BYTE`
  - `CCFAImage`
  - `CMultiChannelImage_FLOAT`
  - `CImageDataArray_BYTE`
  - `CImageDataArray_WORD`
  - `CImageDataArray_SHORT`
  - `CImageDataArray_DWORD`
  - `CImageDataArray_Int32`
  - `CImageDataArray_UInt32`
  - `CImageDataArray_UInt64`
  - `CImageDataArray_Int64`
  - `CBasicImageArray_FLOAT`
  - `CYUV420Image`
  - `CYUV420ImageV2`
  - `CYUV444Image`
  - `CY4UVImage`
- Rule:
  - If these objects are context-local and confirmed unused afterwards, call `Clear()` as soon as practical.
  - If they are still consumed by downstream context, keep them alive and defer cleanup.
  - For class members reused across requests/stages, enforce explicit `Clear()/reset` at the confirmed terminal point of their usage chain.

## 5. Comment Rules Binding
- This coding spec does not replace `master_spec/comment_spec/comment_spec.md`.
- Function comment requirements, templates, and review workflow are governed only by comment spec.
- Agent-authored function comments must keep `@codex-comment` signature per comment spec.

## 6. Formatting and Consistency
- Keep line endings/encoding consistent with original file.
- Do not run broad auto-format over unrelated code.
- Avoid unrelated whitespace churn in review-sensitive files.

## 7. Baseline vs Task-Specific Boundary
- Baseline constraints:
  - reusable coding style and implementation rules in this file.
- Task-specific constraints:
  - experiment-only knobs, one-off evidence dumps, temporary debug branches in `task/**`.
- If a rule is task-specific, do not add it to this baseline coding spec.

## 8. Change Log
- 2026-03-06: Initial coding style/rule governance spec created.
- 2026-03-06: Added mandatory Android + MSVC compatibility rule; prohibited MSVC-only secure CRT usage in cross-platform paths.
- 2026-03-06: Added mandatory memory/resource cleanup rules (new/delete pairing, no overwrite-after-new, image/member Clear timing, early-return unified cleanup).
- 2026-03-06: Added explicit image-class cleanup scope list and mandatory Clear timing rule with cross-stage/cross-function/cross-file context check.

