param(
    [string]$InputFile,
    [string]$RepoName,
    [string]$RepoId,
    [string]$RepoRoot,
    [string]$FullBuildCommand,
    [string]$RuntimeSmokeCommand,
    [string]$RuntimeWorkdir,
    [string[]]$TestEntry,
    [string[]]$ThirdPartyExclusions,
    [string[]]$SkillRegistry,
    [string[]]$ReleasePipeline,
    [string]$DefaultAcceptanceProfile = "A1_Spec_Only",
    [string]$Owner = "Codex",
    [string]$BootstrapDate,
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-ScriptPath {
    param([string]$RelativePath)

    return Join-Path $PSScriptRoot $RelativePath
}

function Normalize-List {
    param([object]$Items)

    $normalized = @()
    if ($null -eq $Items) {
        return @()
    }

    foreach ($item in @($Items)) {
        if ($null -eq $item) {
            continue
        }
        $itemText = [string]$item
        if ([string]::IsNullOrWhiteSpace($itemText)) {
            continue
        }
        foreach ($part in ($itemText -split ',')) {
            $trimmed = $part.Trim()
            if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
                $normalized += $trimmed
            }
        }
    }
    return @($normalized | Select-Object -Unique)
}

function Read-InputFile {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    $resolved = Resolve-Path -LiteralPath $Path
    $raw = Get-Content -LiteralPath $resolved -Raw
    return ($raw | ConvertFrom-Json)
}

function Select-Value {
    param(
        [object]$CliValue,
        [object]$FileValue,
        [object]$DefaultValue = $null
    )

    if ($CliValue -is [System.Array]) {
        if ($CliValue.Count -gt 0) {
            return $CliValue
        }
    }
    elseif ($null -ne $CliValue -and -not [string]::IsNullOrWhiteSpace([string]$CliValue)) {
        return $CliValue
    }

    if ($FileValue -is [System.Array]) {
        if ($FileValue.Count -gt 0) {
            return $FileValue
        }
    }
    elseif ($null -ne $FileValue -and -not [string]::IsNullOrWhiteSpace([string]$FileValue)) {
        return $FileValue
    }

    return $DefaultValue
}

function Assert-MinimumInput {
    param(
        [string]$ResolvedRepoName,
        [string]$ResolvedRepoId,
        [string]$ResolvedRepoRoot,
        [string]$ResolvedFullBuildCommand,
        [string]$ResolvedRuntimeSmokeCommand,
        [string]$ResolvedRuntimeWorkdir,
        [string[]]$TestEntryList,
        [string[]]$ThirdPartyList,
        [string[]]$SkillList,
        [string[]]$PipelineList
    )

    if ([string]::IsNullOrWhiteSpace($ResolvedRepoName)) {
        throw "Repository name is required."
    }
    if ([string]::IsNullOrWhiteSpace($ResolvedRepoId)) {
        throw "Repository id is required."
    }
    if ([string]::IsNullOrWhiteSpace($ResolvedRepoRoot)) {
        throw "Repository root is required."
    }
    if ([string]::IsNullOrWhiteSpace($ResolvedFullBuildCommand)) {
        throw "Full build command is required."
    }
    if ([string]::IsNullOrWhiteSpace($ResolvedRuntimeSmokeCommand)) {
        throw "Runtime smoke command is required."
    }
    if ([string]::IsNullOrWhiteSpace($ResolvedRuntimeWorkdir)) {
        throw "Runtime workdir is required."
    }
    if ($TestEntryList.Count -eq 0) {
        throw "At least one test entry is required."
    }
    if ($ThirdPartyList.Count -eq 0) {
        throw "At least one third-party exclusion path is required."
    }
    if ($SkillList.Count -eq 0) {
        throw "At least one skill entry is required."
    }
    if ($PipelineList.Count -eq 0) {
        throw "At least one release pipeline step is required."
    }
}


function Assert-CommandEscaping {
    param(
        [string]$ResolvedFullBuildCommand,
        [string]$ResolvedRuntimeSmokeCommand
    )

    # Guard against double-escaped quotes from JSON input (e.g. \\\"...\\\"),
    # which would be written into YAML as literal backslash+quote and break execution.
    if ($ResolvedFullBuildCommand.Contains('\\"')) {
        throw 'full_build_command contains literal \\". Use JSON with one quote-escape level, e.g. "\"C:\\Program Files (x86)\\...\\MSBuild.exe\" .\\Your.sln ...".'
    }
    if ($ResolvedRuntimeSmokeCommand.Contains('\\"')) {
        throw 'runtime_smoke_command contains literal \\". Use JSON with one quote-escape level and plain relative paths.'
    }
}
$bootstrapInput = Read-InputFile -Path $InputFile
$inputRepoName = if ($null -ne $bootstrapInput) { $bootstrapInput.repo_name } else { $null }
$inputRepoId = if ($null -ne $bootstrapInput) { $bootstrapInput.repo_id } else { $null }
$inputRepoRoot = if ($null -ne $bootstrapInput) { $bootstrapInput.repo_root } else { $null }
$inputFullBuildCommand = if ($null -ne $bootstrapInput) { $bootstrapInput.full_build_command } else { $null }
$inputRuntimeSmokeCommand = if ($null -ne $bootstrapInput) { $bootstrapInput.runtime_smoke_command } else { $null }
$inputRuntimeWorkdir = if ($null -ne $bootstrapInput) { $bootstrapInput.runtime_workdir } else { $null }
$inputTestEntry = if ($null -ne $bootstrapInput) { $bootstrapInput.test_entry } else { @() }
$inputThirdPartyExclusions = if ($null -ne $bootstrapInput) { $bootstrapInput.third_party_exclusions } else { @() }
$inputSkillRegistry = if ($null -ne $bootstrapInput) { $bootstrapInput.skill_registry } else { @() }
$inputReleasePipeline = if ($null -ne $bootstrapInput) { $bootstrapInput.release_pipeline } else { @() }
$inputDefaultAcceptanceProfile = if ($null -ne $bootstrapInput) { $bootstrapInput.default_acceptance_profile } else { $null }
$inputOwner = if ($null -ne $bootstrapInput) { $bootstrapInput.owner } else { $null }
$inputBootstrapDate = if ($null -ne $bootstrapInput) { $bootstrapInput.bootstrap_date } else { $null }

$RepoName = [string](Select-Value -CliValue $RepoName -FileValue $inputRepoName)
$RepoId = [string](Select-Value -CliValue $RepoId -FileValue $inputRepoId)
$RepoRoot = [string](Select-Value -CliValue $RepoRoot -FileValue $inputRepoRoot)
$FullBuildCommand = [string](Select-Value -CliValue $FullBuildCommand -FileValue $inputFullBuildCommand)
$RuntimeSmokeCommand = [string](Select-Value -CliValue $RuntimeSmokeCommand -FileValue $inputRuntimeSmokeCommand)
$RuntimeWorkdir = [string](Select-Value -CliValue $RuntimeWorkdir -FileValue $inputRuntimeWorkdir)
$TestEntry = Normalize-List -Items (Select-Value -CliValue $TestEntry -FileValue $inputTestEntry -DefaultValue @())
$ThirdPartyExclusions = Normalize-List -Items (Select-Value -CliValue $ThirdPartyExclusions -FileValue $inputThirdPartyExclusions -DefaultValue @())
$SkillRegistry = Normalize-List -Items (Select-Value -CliValue $SkillRegistry -FileValue $inputSkillRegistry -DefaultValue @())
$ReleasePipeline = Normalize-List -Items (Select-Value -CliValue $ReleasePipeline -FileValue $inputReleasePipeline -DefaultValue @())
$DefaultAcceptanceProfile = [string](Select-Value -CliValue $DefaultAcceptanceProfile -FileValue $inputDefaultAcceptanceProfile -DefaultValue 'A1_Spec_Only')
$Owner = [string](Select-Value -CliValue $Owner -FileValue $inputOwner -DefaultValue 'Codex')
$BootstrapDate = [string](Select-Value -CliValue $BootstrapDate -FileValue $inputBootstrapDate -DefaultValue (Get-Date -Format 'yyyy-MM-dd'))
$resolvedForce = $Force.IsPresent
if (-not $resolvedForce -and $null -ne $bootstrapInput -and $null -ne ${bootstrapInput}.force) {
    $resolvedForce = [bool]${bootstrapInput}.force
}

Assert-CommandEscaping -ResolvedFullBuildCommand $FullBuildCommand -ResolvedRuntimeSmokeCommand $RuntimeSmokeCommand
Assert-MinimumInput -ResolvedRepoName $RepoName -ResolvedRepoId $RepoId -ResolvedRepoRoot $RepoRoot -ResolvedFullBuildCommand $FullBuildCommand -ResolvedRuntimeSmokeCommand $RuntimeSmokeCommand -ResolvedRuntimeWorkdir $RuntimeWorkdir -TestEntryList $TestEntry -ThirdPartyList $ThirdPartyExclusions -SkillList $SkillRegistry -PipelineList $ReleasePipeline

$resolvedRepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$initializer = Resolve-ScriptPath 'initialize-bootstrap-artifacts.ps1'
if (-not (Test-Path -LiteralPath $initializer)) {
    throw "Missing bootstrap initializer script: $initializer"
}

Write-Host '[bootstrap-governance] Starting new-repository bootstrap'
if (-not [string]::IsNullOrWhiteSpace($InputFile)) {
    Write-Host "[bootstrap-governance] InputFile=$InputFile"
}
Write-Host "[bootstrap-governance] RepoName=$RepoName RepoId=$RepoId RepoRoot=$resolvedRepoRoot"

& $initializer `
    -RepoName $RepoName `
    -RepoId $RepoId `
    -RepoRoot $resolvedRepoRoot `
    -Owner $Owner `
    -BootstrapDate $BootstrapDate `
    -ProjectProfilePath 'project_profile.yaml' `
    -BootstrapTaskPath 'task/Governance_New_Project_Bootstrap.md' `
    -BootstrapManifestPath 'task/Governance_New_Project_Bootstrap.manifest.md' `
    -ChatStatusPath 'master_spec/chat_spec/chat_status.md' `
    -CommentStatusPath 'master_spec/comment_spec/comment_status.md' `
    -TestEntry $TestEntry `
    -SkillRegistry $SkillRegistry `
    -ReleasePipeline $ReleasePipeline `
    -ThirdPartyExclusions $ThirdPartyExclusions `
    -DefaultAcceptanceProfile $DefaultAcceptanceProfile `
    -FullBuildCommand $FullBuildCommand `
    -RuntimeSmokeCommand $RuntimeSmokeCommand `
    -RuntimeWorkdir $RuntimeWorkdir `
    -Force:([bool]$resolvedForce)

Write-Host '[bootstrap-governance] New-repository bootstrap complete.'


