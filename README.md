# Coding Agent Governance Framework

A reusable governance system for AI coding agents (Claude Code, etc.) that provides structured task lifecycle management, multi-tenancy support, and repository bootstrap tooling.

## What This Is

A set of spec files, templates, and bootstrap scripts that give an AI coding agent:

- **Task lifecycle** — state machine from PlanCreated to Archived with acceptance gates
- **Multi-tenancy** — chat identity, heartbeat, stale detection, takeover protocol
- **Acceptance profiles** — A0 (docs) / A1 (spec) / A2 (code) / A3 (release) with pass/fail criteria
- **Session continuity** — resume detection, task index, conflict priority
- **Bootstrap** — one-command setup for new repositories

## Quick Start

```powershell
# 1. Clone into your project
git clone <this-repo> governance-seed

# 2. Copy template files into your project root
cp -r governance-seed/AGENTS.md .
cp -r governance-seed/master_spec/ .
cp -r governance-seed/skill/ .

# 3. Fill the input template with your project facts
cp master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json my-project-input.json
# Edit my-project-input.json with your project name, build commands, etc.

# 4. Run bootstrap
powershell -ExecutionPolicy Bypass -File skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1 -InputFile my-project-input.json
```

## Structure

```
AGENTS.md                          # Entry point (hybrid: template structure + instance paths)
VERSION                            # Framework version
CHANGELOG.md                       # Framework changelog
master_spec/
  project_profile_template.yaml    # Project config template
  chat_spec/chat_spec.md           # Session/task continuity rules
  task_spec/                       # Task lifecycle, templates
  coding_spec/                     # Coding style governance
  comment_spec/                    # Comment review governance
  read_audit_spec/                 # Source read audit trail
  skill_spec/                      # Skill registration
  acceptance_spec/                 # Acceptance profile/catalog templates
  procedure_spec/                  # Procedure templates + bootstrap procedures
  flow_spec/                       # Algorithm flow templates
  initial_spec/
    initial_spec.md                # Bootstrap trigger + propagation rules
    governance_template_boundary.md # Template vs instance ownership
    starter_instance/              # Instance-owned file skeletons
    NEW_PROJECT_BOOTSTRAP_*.md/json # Bootstrap input/checklist/manifest
skill/bootstrap-governance/        # Bootstrap scripts
```

## Versioning

- Version file: `VERSION`
- Changelog: `CHANGELOG.md`
- Consumer projects record `governance.framework_version` in their `project_profile.yaml`

## License

Private. Contact repository owner for usage terms.
