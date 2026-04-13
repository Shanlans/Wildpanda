---
name: readme-update
description: Keep README.md and README_zh.md in sync with the current framework state. Use when releasing, contributing, adding/changing skills, or when the user asks to update the README.
---

# README Update

Keep `README.md` (English) and `README_zh.md` (Chinese) accurate and in sync with the current framework state.

## Trigger / 触发条件

- **Automatic / 自动**:
  - During `governance-release` Step 9 (CHANGELOG update): after writing CHANGELOG, run this skill to sync READMEs before the release commit.
    在 governance-release 第 9 步写完 CHANGELOG 后，执行此 skill 同步 README，然后再提交发布。
  - During `governance-contribute` Step 8 (README Check): if contributed changes affect skills, triggers, features, or compatibility, run this skill.
    在 governance-contribute 第 8 步 README 检查中，如果贡献的变更影响技能、触发器、特性或兼容性，执行此 skill。
- **Manual / 手动**: user wants to update README content.
  用户主动要求更新 README 内容。
- **Keyword triggers / 关键词触发**:
  - "更新 readme" / "update readme"
  - "同步 readme" / "sync readme"
  - "刷新 readme" / "refresh readme"

## What This Skill Owns

This skill is the single owner of README content updates. Other skills (governance-release, governance-contribute) delegate README changes to this skill instead of editing READMEs directly.

### Owned Files
- `README.md` (English)
- `README_zh.md` (Chinese)

### Owned Sections
All sections in both READMEs, specifically:
- Version display line
- Feature descriptions
- Command Reference table (skill trigger phrases)
- Skills table
- Compatibility table
- How It Works diagram
- Governance Lifecycle diagram
- Repository Structure listing
- Key Design Decisions
- Star History / analytics embed

## Update Checklist

When triggered, execute the following checks in order. Skip items that have no changes.

### 1. Version Line
- Read `VERSION` file.
- Update the version display line in both READMEs:
  - EN: `> **Current version: v<version>**`
  - ZH: `> **当前版本：v<version>**`

### 2. Command Reference Table
- Scan all `skill/*/SKILL.md` files.
- For each skill, extract the **Keyword triggers** section.
- Rebuild the Command Reference table in both READMEs:
  - EN: `## 💬 Command Reference` — English trigger phrases
  - ZH: `## 💬 指令参考` — Chinese trigger phrases with English alternatives
- If a new skill was added, add its row.
- If a skill was removed, remove its row.
- If trigger phrases changed, update the corresponding row.
- Preserve the `???` strict validation row (not from any skill file).

### 3. Skills Table
- Scan all `skill/*/SKILL.md` files.
- For each skill, extract: name, description (from frontmatter), trigger summary.
- Rebuild the Skills table in both READMEs:
  - EN: `## 🔧 Skills`
  - ZH: `## 🔧 技能`
- Match skill count and descriptions to actual skill files.

### 4. Feature Sections
- If the triggering change adds or removes a major capability (new spec, new governance rule, new skill category), update the corresponding feature section.
- Do NOT rewrite feature sections for minor changes (typo fixes, formatting).
- When in doubt, present the proposed change to user before writing.

### 5. Repository Structure
- If new top-level directories or skill directories were added/removed, update the Repository Structure section in both READMEs.

### 6. Compatibility Table
- If new tool dependencies or platform support changed, update the Compatibility table.

### 7. Diagram Updates
- If the governance flow changed (new gates, new steps), update the How It Works diagram.
- If the lifecycle changed (new sync/contribute/release steps), update the Governance Lifecycle diagram.
- Diagrams must use English labels in box content for alignment. Chinese README uses English labels with Chinese annotations after arrows (`←`).

### 8. Bilingual Sync
- Every change made to `README.md` must have a corresponding change in `README_zh.md`, and vice versa.
- Content must be semantically equivalent, not machine-translated.
- Verify both files have the same section count and order.

## Execution Rules

1. **Always update both READMEs together.** Never update one without the other.
2. **Version line is mandatory on every release.** Even if nothing else changed.
3. **Command Reference rebuild is mandatory when any skill trigger changes.** Scan all skills, not just the changed one.
4. **Do not add branding for specific LLM tools.** Keep descriptions generic ("LLM coding agents").
5. **Comment signature references use `@<owner>-comment`**, not hardcoded names.
6. **Diagram alignment**: use English text inside boxes. Chinese README annotates with `←` arrows.
7. **Star History / analytics embeds**: do not modify unless user explicitly requests.
8. **Present changes to user before writing** if the update touches feature descriptions or design decisions (sections that require judgment). Version line, command table, and skills table can be updated without confirmation.

## Integration with Other Skills

### governance-release
- governance-release Step 9 calls this skill after updating CHANGELOG.
- This skill updates version line and any README content affected by the release.
- Changes are included in the same release commit.

### governance-contribute
- governance-contribute Step 8 (README Check) calls this skill if contributed files include skill changes, spec changes, or feature additions.
- This skill updates affected README sections.
- Changes are included in the same contribute commit.

### New skill creation
- When a new skill is created (new `skill/*/SKILL.md`), this skill must be called to:
  1. Add the skill to the Skills table.
  2. Add the skill's trigger phrases to the Command Reference table.
  3. Add the skill directory to Repository Structure (if not already listed generically).
  4. Update feature sections if the new skill represents a new capability category.

## Deliverables
- Updated `README.md`
- Updated `README_zh.md`
- Both files in sync with current framework state
