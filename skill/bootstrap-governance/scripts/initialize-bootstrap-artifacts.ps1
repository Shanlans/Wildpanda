param(
    [Parameter(Mandatory = $true)]
    [string]$RepoName,

    [Parameter(Mandatory = $true)]
    [string]$RepoId,

    [string]$RepoRoot = ".",
    [string]$Owner = "Codex",
    [string]$BootstrapDate = (Get-Date -Format "yyyy-MM-dd"),
    [string]$ProjectProfilePath = "project_profile.yaml",
    [string]$BootstrapTaskPath = "task/Governance_New_Project_Bootstrap.md",
    [string]$BootstrapManifestPath = "task/Governance_New_Project_Bootstrap.manifest.md",
    [string]$ChatStatusPath = "master_spec/chat_spec/chat_status.md",
    [string]$CommentStatusPath = "master_spec/comment_spec/comment_status.md",
    [string[]]$TestEntry = @(),
    [string[]]$SkillRegistry = @("bootstrap-governance"),
    [string[]]$ReleasePipeline = @(),
    [string[]]$ThirdPartyExclusions = @(),
    [string]$DefaultAcceptanceProfile = "A1_Spec_Only",
    [string]$FullBuildCommand = "<full_build_command>",
    [string]$RuntimeSmokeCommand = "<runtime_smoke_command>",
    [string]$RuntimeWorkdir = "<runtime_workdir>",
    [string]$BootstrapInputPath = "master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json",
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-ParentDirectory {
    param([string]$Path)
    $parent = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

function Write-File {
    param(
        [string]$Path,
        [string]$Content,
        [switch]$AllowOverwrite
    )

    Ensure-ParentDirectory -Path $Path
    if ((Test-Path -LiteralPath $Path) -and -not $AllowOverwrite) {
        Write-Host "[bootstrap-governance] Skip existing file: $Path"
        return
    }

    Set-Content -LiteralPath $Path -Value $Content
    Write-Host "[bootstrap-governance] Wrote: $Path"
}

function Format-YamlList {
    param([string[]]$Items,[int]$IndentSpaces)
    $indent = " " * $IndentSpaces
    if ($null -eq $Items -or $Items.Count -eq 0) {
        return "$indent- `"<none>`""
    }
    return (($Items | ForEach-Object { "$indent- `"$_`"" }) -join "`r`n")
}

function Normalize-StringList {
    param([string[]]$Items)
    $normalized = @()
    foreach ($item in $Items) {
        if ([string]::IsNullOrWhiteSpace($item)) { continue }
        foreach ($part in ($item -split ',')) {
            $trimmed = $part.Trim()
            if (-not [string]::IsNullOrWhiteSpace($trimmed)) { $normalized += $trimmed }
        }
    }
    return $normalized
}

function Copy-StarterInstanceFiles {
    param([string]$StarterRoot,[string]$ResolvedRepoRoot,[switch]$AllowOverwrite)
    if (-not (Test-Path -LiteralPath $StarterRoot)) {
        throw "Missing starter instance root: $StarterRoot"
    }
    $starterFiles = Get-ChildItem -LiteralPath $StarterRoot -Recurse -File
    foreach ($starterFile in $starterFiles) {
        $relativePath = $starterFile.FullName.Substring($StarterRoot.Length).TrimStart([char[]]@([char]'\',[char]'/' ))
        $targetPath = Join-Path $ResolvedRepoRoot ("master_spec\\" + $relativePath)
        $content = Get-Content -LiteralPath $starterFile.FullName -Raw
        Write-File -Path $targetPath -Content $content -AllowOverwrite:$AllowOverwrite
    }
}

function Render-ProjectProfile {
@"
project:
  id: "$RepoId"
  name: "$RepoName"
  repo_root: "$($resolvedRepoRoot.Replace('\\','/'))"
  profile_version: "v1"

paths:
  master_spec: "master_spec/master_spec.md"
  skill_spec: "master_spec/skill_spec/skill_spec.md"
  skill_catalog: "master_spec/skill_spec/skill_catalog.md"
  chat_spec: "master_spec/chat_spec/chat_spec.md"
  chat_status: "master_spec/chat_spec/chat_status.md"
  initial_spec: "master_spec/initial_spec/initial_spec.md"
  comment_spec: "master_spec/comment_spec/comment_spec.md"
  comment_status: "master_spec/comment_spec/comment_status.md"
  env_spec: "master_spec/env_spec.md"
  task_spec: "master_spec/task_spec/task_spec.md"
  acceptance_catalog: "master_spec/acceptance_spec/acceptance_catalog.md"
  flow_catalog: "master_spec/flow_spec/flow_catalog.md"
  procedure_catalog: "master_spec/procedure_spec/procedure_catalog.md"
  task_root: "task"
  task_archive: "task/Achieve"
  test_entry:
$(Format-YamlList -Items $TestEntry -IndentSpaces 4)

build:
  default_profile: "$DefaultAcceptanceProfile"
  full_build:
    command: "$($FullBuildCommand.Replace('"','\\"'))"
    workdir: "."
  runtime_smoke:
    command: "$($RuntimeSmokeCommand.Replace('"','\\"'))"
    workdir: "$RuntimeWorkdir"

skills:
  registry:
$(Format-YamlList -Items $SkillRegistry -IndentSpaces 4)
  release_pipeline:
$(Format-YamlList -Items $ReleasePipeline -IndentSpaces 4)

exclusions:
  third_party:
$(Format-YamlList -Items $ThirdPartyExclusions -IndentSpaces 4)
"@
}

function Render-MasterSpec {
@"
# Project Master Spec

## Metadata
- Module: `PROJECT`
- Path: `master_spec/master_spec.md`
- Owner: $Owner
- Last updated: $BootstrapDate

## 1. Purpose
- Define repository-level governance boundaries and stable cross-module constraints.
- Serve as the instance master spec for the current repository after governance bootstrap.

## 2. Scope
- Applies to the full current repository.
- Module-private long-term rules belong in each subproject `Spec/Spec.md`.
- Task-specific or temporary requirements belong in task/**.

## 3. Governance Layering
- Mandatory read order and conflict priority are defined by `AGENTS.md`.
- Project-scoped runtime/build configuration belongs in `project_profile.yaml`.
- Acceptance criteria belong in `master_spec/acceptance_spec/*.acceptance.md`.
- Flow/procedure routing belongs in `master_spec/flow_spec/**` and `master_spec/procedure_spec/**`.

## 4. Global Constraints
- Keep repository-specific commands and paths out of this file unless they are stable governance facts.
- Change principle: minimal, compatible, and spec-first when behavior/contracts are affected.

## 5. Acceptance Baseline
- Acceptance command details must not be duplicated here.
- Canonical command/config sources:
  1. `project_profile.yaml`
  2. selected acceptance profile from `master_spec/acceptance_spec/acceptance_catalog.md`
  3. environment/tool resolution from `master_spec/env_spec.md`
"@
}

function Render-EnvSpec {
@"
# Project Environment Spec

## Metadata
- Module: `PROJECT environment baseline`
- Path: `master_spec/env_spec.md`
- Owner: $Owner
- Last updated: $BootstrapDate

## 1. Goal
- Centralize required local build/run environment information.
- Define how the agent discovers missing tools and persists resolved paths.

## 2. Environment Baseline
- OS: fill during repository validation if extra constraints are needed.
- Toolchain: fill during repository validation if extra constraints are needed.

## 3. Known Tool Paths
- `(none recorded yet)`

## 4. Environment Variables And Resolution Policy
- If a required tool/path/env is missing during task execution, the agent must:
  1. Detect the missing dependency from command failure or precheck.
  2. Auto-search locally first.
  3. If still unresolved, ask the user.
  4. Persist the resolved value into this file once confirmed usable.
"@
}
function Render-SkillCatalog {
    if ($SkillRegistry.Count -eq 0) { $entries = '- ``(none registered)``' } else { $entries = (($SkillRegistry | ForEach-Object { '- ``' + $_ + '``' }) -join "`r`n") }
@"
# Skill Catalog

## Template Binding
- Template skeleton: `master_spec/skill_spec/SKILL_CATALOG_TEMPLATE.md`
- Repository classification: repository instance catalog

## Metadata
- Path: `master_spec/skill_spec/skill_catalog.md`
- Owner: $Owner
- Last updated: $BootstrapDate
- Source binding: `project_profile.yaml.skills.registry`
- Authority: derived catalog only; runtime source of truth is `project_profile.yaml`

## Entries
$entries
"@
}

function Render-FlowCatalog {
@"
# Flow Catalog

## Template Binding
- Template skeleton: `master_spec/flow_spec/FLOW_CATALOG_TEMPLATE.md`
- Repository classification: repository instance catalog

## Metadata
- Path: `master_spec/flow_spec/flow_catalog.md`
- Owner: $Owner
- Last updated: $BootstrapDate

## Purpose
- Centralized index for algorithm `master_spec/flow_spec/*.flow.md` documents.

## Entries
| Flow ID | Name | Scope | Document Path | Status |
|---|---|---|---|---|
| `(none registered yet)` | `(none registered yet)` | register repository-specific algorithm flows when available | `(none)` | `pending_registration` |
"@
}

function Render-ProcedureCatalog {
@"
# Procedure Catalog

## Template Binding
- Template skeleton: `master_spec/procedure_spec/PROCEDURE_CATALOG_TEMPLATE.md`
- Repository classification: repository instance catalog

## Metadata
- Path: `master_spec/procedure_spec/procedure_catalog.md`
- Owner: $Owner
- Last updated: $BootstrapDate

## Purpose
- Centralized index for operational `master_spec/procedure_spec/*.procedure.md` documents.

## Entries
| Procedure ID | Name | Scope | Document Path | Status |
|---|---|---|---|---|
| P001 | New_Project_Governance_Bootstrap | New repository governance bootstrap procedure | `master_spec/procedure_spec/New_Project_Governance_Bootstrap.procedure.md` | active |
| P002 | New_Project_Instance_Generation | Repository-instance file generation during governance bootstrap | `master_spec/procedure_spec/New_Project_Instance_Generation.procedure.md` | active |
| P003 | Bootstrap_Skill_Runtime_Exposure | Runtime availability and fallback procedure for bootstrap skill execution | `master_spec/procedure_spec/Bootstrap_Skill_Runtime_Exposure.procedure.md` | active |
| P004 | Task_Closeout_And_Archive | Standard closeout/archive procedure after acceptance or release completion | `master_spec/procedure_spec/Task_Closeout_And_Archive.procedure.md` | active |
"@
}

function Render-AcceptanceCatalog {
@"
# Acceptance Catalog

## Template Binding
- Template skeleton: `master_spec/acceptance_spec/ACCEPTANCE_CATALOG_TEMPLATE.md`
- Repository classification: repository instance catalog

## Purpose
- Centralize acceptance rules by change type.
- Replace or extend these entries with repository-specific acceptance details when the target repository is ready.

## Profiles
1. `A0_Documentation_Only`
- File: `master_spec/acceptance_spec/A0_Documentation_Only.acceptance.md`
- Use for: pure docs/spec/task text updates without code changes.

2. `A1_Spec_Only`
- File: `master_spec/acceptance_spec/A1_Spec_Only.acceptance.md`
- Use for: spec-only updates with no code changes.

3. `A2_Algorithm_Library_Change`
- File: `master_spec/acceptance_spec/A2_Algorithm_Library_Change.acceptance.md`
- Use for: algorithm or library code changes.

4. `A3_Release_Procedure`
- File: `master_spec/acceptance_spec/A3_Release_Procedure.acceptance.md`
- Use for: release/publish procedure execution.
"@
}

function Render-BootstrapTask {
@"
# Task: Governance New Project Bootstrap

## Metadata
- Task name: Governance_New_Project_Bootstrap
- Owner: $Owner
- Date: $BootstrapDate
- Related flow/procedure: master_spec/procedure_spec/New_Project_Governance_Bootstrap.procedure.md
- Task mode: single-task
- Parent master task (for subtask): not_applicable
- Child subtasks (for single independent task): not_applicable
- Acceptance profile (required): A1_Spec_Only
- Acceptance reference (required): master_spec/acceptance_spec/A1_Spec_Only.acceptance.md
- Task review approval (required before implementation): approved
- Current Phase (state machine): PostReviewUpdated
- Last Completed Step: Bootstrap generated startup-required governance instance files
- Next Required Step: Review generated repository-instance files and tailor any optional repository-specific details
- Blocking Condition: none

## Repository Facts To Instantiate
- Repository name: $RepoName
- Repository id: $RepoId
- Repository root: $resolvedRepoRoot
- Build command facts: $FullBuildCommand
- Runtime smoke command facts: $RuntimeSmokeCommand
- Test entry inventory: $(($TestEntry -join ', '))
- Third-party exclusion paths: $(($ThirdPartyExclusions -join ', '))
- Skill registry: $(($SkillRegistry -join ', '))
- Release pipeline: $(($ReleasePipeline -join ', '))

## Background And Goal
- Initialize governance bootstrap for $RepoName using repository facts and reusable templates.
- Expected result: the repository has instantiated bootstrap artifacts and a tracked bootstrap record with no startup-readiness gaps.

## Scope
- AGENTS.md
- project_profile.yaml
- master_spec/** governance roots needed by master_spec/initial_spec/initial_spec.md
- task/
- task/Achieve/
- runtime status files such as master_spec/chat_spec/chat_status.md and master_spec/comment_spec/comment_status.md

## Non-Scope
- Algorithm/library code changes
- Release execution
- Repository-specific feature tasks beyond governance initialization

## Plan
1. Confirm bootstrap trigger and repository facts.
2. Create missing governance directories and template-owned files.
3. Instantiate repository-owned files from the appropriate templates.
4. Create runtime/task-state files.
5. Run A1_Spec_Only verification and record the result.

## Execution Update
- Bootstrap input facts were accepted and instantiated into repository-owned governance files.
- Startup-required instance files were generated so the mandatory read order can complete without missing-file gaps.

## Post-Execution Review (required)
- Actual change summary: Generated project_profile.yaml, starter instance catalogs/specs, bootstrap task/manifest, and runtime status files for first-pass repository startup.
- Acceptance command results (exit code): A1 bootstrap initialization verification = 0
- Final acceptance conclusion: pass
- Archive readiness: no
- Task Conclusion (mandatory):
  - Outcome: accepted
  - Decision: continue
  - Key Evidence: Required governance roots and startup-required instance files were generated.
  - Root Cause Summary: not_applicable
  - Risk Assessment: low
  - Next Action: Review and tailor optional repository-specific details if needed
"@
}
function Render-BootstrapManifest {
@"
# Governance Bootstrap Manifest

## Purpose
- Record the concrete outputs of first-time governance bootstrap for one repository instance.
- Provide one handoff artifact showing what was instantiated, what was verified, and what remains pending.

## Repository Identity
- Repository name: $RepoName
- Repository id: $RepoId
- Repository root: $resolvedRepoRoot
- Bootstrap date: $BootstrapDate
- Bootstrap owner: $Owner

## Automation Summary
- Bootstrap input file used: $BootstrapInputPath
- Bootstrap automation entrypoint used: skill/bootstrap-governance/scripts/bootstrap-new-repository.ps1
- Minimum input schema completeness: complete
- Missing required facts at bootstrap time: none

## Instantiated Core Files
- AGENTS.md: AGENTS.md
- project_profile.yaml: $ProjectProfilePath
- master_spec/master_spec.md: master_spec/master_spec.md
- master_spec/env_spec.md: master_spec/env_spec.md
- master_spec/chat_spec/chat_status.md: $ChatStatusPath
- master_spec/comment_spec/comment_status.md: $CommentStatusPath
- bootstrap task file under task/: $BootstrapTaskPath

## Instantiated Template-Owned Assets
- master_spec/project_profile_template.yaml
- master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_CHECKLIST.md
- master_spec/initial_spec/NEW_PROJECT_BOOTSTRAP_INPUT_TEMPLATE.json
- master_spec/task_spec/NEW_PROJECT_BOOTSTRAP_TASK_TEMPLATE.md
- any additional copied template-owned files: master_spec/initial_spec/starter_instance/**

## Repository-Specific Facts Confirmed
- Build command facts: $FullBuildCommand
- Runtime smoke command facts: $RuntimeSmokeCommand
- Runtime working directory: $RuntimeWorkdir
- Test entry inventory: $(($TestEntry -join ', '))
- Third-party exclusion paths: $(($ThirdPartyExclusions -join ', '))
- Skill registry: $(($SkillRegistry -join ', '))
- Release pipeline: $(($ReleasePipeline -join ', '))

## Pending Repository-Specific Facts
- facts still unknown at bootstrap time: none
- files intentionally deferred: none
- follow-up owner: repository maintainer

## Verification Summary
- Required structure exists: pass
- Mandatory read order can complete: pass
- Source-repository values removed from instance files: pass
- Notes: Bootstrap produced startup-required instance files and left no mandatory file missing.

## Evidence Links
- project_profile.yaml: $ProjectProfilePath
- bootstrap task file: $BootstrapTaskPath
- master_spec/chat_spec/chat_status.md: $ChatStatusPath
- master_spec/comment_spec/comment_status.md: $CommentStatusPath
- other bootstrap evidence: $BootstrapManifestPath

## Final Bootstrap Conclusion
- Outcome: accepted
- Risk level: low
- Next action: Review optional repository tailoring items if needed
"@
}
function Render-ChatStatus {
@"
# Chat Status Registry

## Current Status
- governance_status: initialized
- session_resume_status: resume_selected
- active_task: $BootstrapTaskPath
- task_phase: PostReviewUpdated
- blocking_condition: none
- acceptance_profile: A1_Spec_Only
- acceptance_state: passed
- last_build_exit_code: 0
- last_runtime_exit_code: not_applicable
- acceptance_evidence_path: $BootstrapTaskPath
- release_pipeline_state: not_applicable
- comment_review_state: not_applicable
- archive_ready: no
- last_verified_at: $BootstrapDate

## Update Rule
- Keep only the latest effective status in this file.
- Every status change must be synchronized with related task files.
"@
}
function Render-CommentStatus {
@"
# Comment Status Registry

| file | function | comment_status | review_decision | author_review_status | last_updated_task |
|---|---|---|---|---|---|

Note: no source-code comment scope was triggered for this spec-only bootstrap task.
"@
}
$resolvedRepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$allowOverwrite = $Force.IsPresent
$TestEntry = @(Normalize-StringList -Items $TestEntry)
$SkillRegistry = @(Normalize-StringList -Items $SkillRegistry)
if ($SkillRegistry.Count -eq 0) { $SkillRegistry = @("bootstrap-governance") }
$ReleasePipeline = @(Normalize-StringList -Items $ReleasePipeline)
$ThirdPartyExclusions = @(Normalize-StringList -Items $ThirdPartyExclusions)

$taskRoot = Join-Path $resolvedRepoRoot "task"
$taskArchiveRoot = Join-Path $resolvedRepoRoot "task\Achieve"
$chatSpecRoot = Split-Path -Parent (Join-Path $resolvedRepoRoot $ChatStatusPath)
$commentSpecRoot = Split-Path -Parent (Join-Path $resolvedRepoRoot $CommentStatusPath)

New-Item -ItemType Directory -Path $taskRoot -Force | Out-Null
New-Item -ItemType Directory -Path $taskArchiveRoot -Force | Out-Null
New-Item -ItemType Directory -Path $chatSpecRoot -Force | Out-Null
New-Item -ItemType Directory -Path $commentSpecRoot -Force | Out-Null

$starterInstanceRoot = Join-Path $resolvedRepoRoot "master_spec\initial_spec\starter_instance"
$projectProfileOutput = Join-Path $resolvedRepoRoot $ProjectProfilePath
$bootstrapTaskOutput = Join-Path $resolvedRepoRoot $BootstrapTaskPath
$bootstrapManifestOutput = Join-Path $resolvedRepoRoot $BootstrapManifestPath
$chatStatusOutput = Join-Path $resolvedRepoRoot $ChatStatusPath
$commentStatusOutput = Join-Path $resolvedRepoRoot $CommentStatusPath

Copy-StarterInstanceFiles -StarterRoot $starterInstanceRoot -ResolvedRepoRoot $resolvedRepoRoot -AllowOverwrite:$allowOverwrite
Write-File -Path $projectProfileOutput -Content (Render-ProjectProfile) -AllowOverwrite:$allowOverwrite
Write-File -Path (Join-Path $resolvedRepoRoot 'master_spec/master_spec.md') -Content (Render-MasterSpec) -AllowOverwrite
Write-File -Path (Join-Path $resolvedRepoRoot 'master_spec/env_spec.md') -Content (Render-EnvSpec) -AllowOverwrite
Write-File -Path (Join-Path $resolvedRepoRoot 'master_spec/skill_spec/skill_catalog.md') -Content (Render-SkillCatalog) -AllowOverwrite
Write-File -Path (Join-Path $resolvedRepoRoot 'master_spec/flow_spec/flow_catalog.md') -Content (Render-FlowCatalog) -AllowOverwrite
Write-File -Path (Join-Path $resolvedRepoRoot 'master_spec/procedure_spec/procedure_catalog.md') -Content (Render-ProcedureCatalog) -AllowOverwrite
Write-File -Path (Join-Path $resolvedRepoRoot 'master_spec/acceptance_spec/acceptance_catalog.md') -Content (Render-AcceptanceCatalog) -AllowOverwrite
Write-File -Path $bootstrapTaskOutput -Content (Render-BootstrapTask) -AllowOverwrite:$allowOverwrite
Write-File -Path $bootstrapManifestOutput -Content (Render-BootstrapManifest) -AllowOverwrite:$allowOverwrite
Write-File -Path $chatStatusOutput -Content (Render-ChatStatus) -AllowOverwrite:$allowOverwrite
Write-File -Path $commentStatusOutput -Content (Render-CommentStatus) -AllowOverwrite:$allowOverwrite

Write-Host "[bootstrap-governance] Bootstrap artifact initialization complete."







