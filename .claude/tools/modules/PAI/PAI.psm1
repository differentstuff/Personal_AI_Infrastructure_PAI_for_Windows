#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Personal AI Infrastructure (PAI) PowerShell Module

.DESCRIPTION
    Core functions for managing PAI configuration, skills, and agents
#>

# Module variables
$script:PAI_ROOT = $null
$script:PAI_CONFIG = $null

#region Helper Functions

function Get-PAIRoot {
    <#
    .SYNOPSIS
        Get the PAI root directory
    #>
    if ($null -eq $script:PAI_ROOT) {
        # Try environment variable first
        if ($env:PAI_ROOT) {
            $script:PAI_ROOT = $env:PAI_ROOT
        }
        # Try to find .claude directory
        elseif (Test-Path "$HOME\.claude\settings.json") {
            $script:PAI_ROOT = "$HOME\.claude"
        }
        else {
            throw "PAI root directory not found. Set PAI_ROOT environment variable."
        }
    }
    return $script:PAI_ROOT
}

function Resolve-PAIPath {
    <#
    .SYNOPSIS
        Resolve PAI path with variable substitution
    #>
    param([string]$Path)
    
    $paiRoot = Get-PAIRoot
    $resolved = $Path -replace '\$\{PAI_ROOT\}', $paiRoot
    $resolved = $resolved -replace '\$\{TEMP_DIR\}', $env:TEMP
    
    # Convert to platform-appropriate path separator
    if ($IsLinux) {
        $resolved = $resolved -replace '\\', '/'
    }
    
    return $resolved
}

#endregion

#region Public Functions

function Get-PAIConfig {
    <#
    .SYNOPSIS
        Load PAI configuration from settings.json
    
    .DESCRIPTION
        Reads and parses the PAI settings.json file with path resolution
    
    .EXAMPLE
        $config = Get-PAIConfig
        $config.identity.user_name
    #>
    [CmdletBinding()]
    param()
    
    if ($null -eq $script:PAI_CONFIG) {
        $paiRoot = Get-PAIRoot
        $settingsFile = Join-Path $paiRoot "settings.json"
        
        if (-not (Test-Path $settingsFile)) {
            throw "Settings file not found: $settingsFile"
        }
        
        $script:PAI_CONFIG = Get-Content $settingsFile -Raw | ConvertFrom-Json
    }
    
    return $script:PAI_CONFIG
}

function Get-PAISkills {
    <#
    .SYNOPSIS
        Get list of available PAI skills
    
    .DESCRIPTION
        Scans the skills directory and returns skill metadata
    
    .PARAMETER Name
        Filter by skill name
    
    .EXAMPLE
        Get-PAISkills
    
    .EXAMPLE
        Get-PAISkills -Name "CORE"
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Name
    )
    
    $config = Get-PAIConfig
    $skillsPath = Resolve-PAIPath $config.paths.skills_dir
    
    if (-not (Test-Path $skillsPath)) {
        Write-Warning "Skills directory not found: $skillsPath"
        return @()
    }
    
    $skillDirs = Get-ChildItem -Path $skillsPath -Directory
    
    if ($Name) {
        $skillDirs = $skillDirs | Where-Object { $_.Name -eq $Name }
    }
    
    $skills = foreach ($dir in $skillDirs) {
        $skillMd = Join-Path $dir.FullName "SKILL.md"
        
        $skill = [PSCustomObject]@{
            Name = $dir.Name
            Path = $dir.FullName
            HasMetadata = Test-Path $skillMd
            Metadata = $null
        }
        
        if ($skill.HasMetadata) {
            $content = Get-Content $skillMd -Raw
            
            # Parse basic metadata
            $metadata = @{
                Description = if ($content -match '(?m)^Description:\s*(.+)$') { $matches[1] } else { $null }
                Version = if ($content -match '(?m)^Version:\s*(.+)$') { $matches[1] } else { $null }
            }
            
            $skill.Metadata = $metadata
        }
        
        $skill
    }
    
    return $skills
}

function Get-PAIAgent {
    <#
    .SYNOPSIS
        Load a PAI agent configuration
    
    .DESCRIPTION
        Reads an agent markdown file and returns its content
    
    .PARAMETER Name
        Agent name (e.g., "assistant", "engineer", "researcher")
    
    .EXAMPLE
        Get-PAIAgent -Name "engineer"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )
    
    $config = Get-PAIConfig
    $agentsPath = Resolve-PAIPath $config.paths.agents_dir
    $agentFile = Join-Path $agentsPath "$Name.md"
    
    if (-not (Test-Path $agentFile)) {
        Write-Error "Agent not found: $Name"
        return $null
    }
    
    $content = Get-Content $agentFile -Raw
    
    return [PSCustomObject]@{
        Name = $Name
        Path = $agentFile
        Content = $content
    }
}

function Test-PAIEnvironment {
    <#
    .SYNOPSIS
        Validate PAI environment setup
    
    .DESCRIPTION
        Checks that all required directories and files exist
    
    .EXAMPLE
        Test-PAIEnvironment
    #>
    [CmdletBinding()]
    param()
    
    Write-Host "🔍 Validating PAI Environment..." -ForegroundColor Cyan
    
    $checks = @()
    
    # Check PAI root
    try {
        $paiRoot = Get-PAIRoot
        $checks += [PSCustomObject]@{ Item = "PAI Root"; Status = "✅"; Path = $paiRoot }
    } catch {
        $checks += [PSCustomObject]@{ Item = "PAI Root"; Status = "❌"; Path = $_.Exception.Message }
    }
    
    # Check settings.json
    try {
        $config = Get-PAIConfig
        $checks += [PSCustomObject]@{ Item = "settings.json"; Status = "✅"; Path = "Found" }
    } catch {
        $checks += [PSCustomObject]@{ Item = "settings.json"; Status = "❌"; Path = "Missing" }
    }
    
    # Check .env
    $envFile = Join-Path $paiRoot ".env"
    if (Test-Path $envFile) {
        $checks += [PSCustomObject]@{ Item = ".env"; Status = "✅"; Path = "Found" }
    } else {
        $checks += [PSCustomObject]@{ Item = ".env"; Status = "⚠️ "; Path = "Missing (run Initialize-PAI.ps1)" }
    }
    
    # Check directories
    $dirs = @("skills", "agents", "hooks", "tools", "templates")
    foreach ($dir in $dirs) {
        $dirPath = Join-Path $paiRoot $dir
        if (Test-Path $dirPath) {
            $checks += [PSCustomObject]@{ Item = "$dir/"; Status = "✅"; Path = "Exists" }
        } else {
            $checks += [PSCustomObject]@{ Item = "$dir/"; Status = "❌"; Path = "Missing" }
        }
    }
    
    # Display results
    $checks | Format-Table -AutoSize
    
    $failed = $checks | Where-Object { $_.Status -eq "❌" }
    if ($failed.Count -eq 0) {
        Write-Host "✨ PAI environment is healthy!" -ForegroundColor Green
        return $true
    } else {
        Write-Host "⚠️  Some checks failed. Run Initialize-PAI.ps1 to fix." -ForegroundColor Yellow
        return $false
    }
}

#endregion

# Export module members
Export-ModuleMember -Function @(
    'Get-PAIConfig',
    'Get-PAISkills',
    'Get-PAIAgent',
    'Test-PAIEnvironment'
)
