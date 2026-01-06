#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Install PAI Bundle for Windows

.DESCRIPTION
    Windows-native bundle installer:
    - Validates prerequisites (PowerShell 7.5+, Windows 11)
    - Detects existing AI installations
    - Creates backup of current .claude folder
    - Installs PAI bundle to chosen workspace
    - Sets up environment variables
    - Configures Windows security policies

.PARAMETER WorkspacePath
    Target workspace directory (defaults to OneDrive\.claude)

.EXAMPLE
    .\Install-PAI.ps1
    .\Install-PAI.ps1 -WorkspacePath "C:\MyPAISetup"

.NOTES
    Platform: Windows 11
    PowerShell: 7.5+
    Dependencies: None (Windows-native)
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$WorkspacePath = ""
)

$ErrorActionPreference = "Stop"

# Fancy header
function Write-Header {
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║           PAI - Personal AI Infrastructure v2.0.0          ║" -ForegroundColor Cyan
    Write-Host "║                Windows Native Bundle Installer               ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# Validate prerequisites
function Test-Prerequisites {
    Write-Host "[*] Validating Prerequisites..." -ForegroundColor Yellow
    
    # Check OS
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    if ($osInfo.Caption -notlike "*Windows 11*") {
        Write-Warning "Windows 11 is recommended. You have: $($osInfo.Caption)"
    } else {
        Write-Host "   [OK] Windows 11 detected" -ForegroundColor Green
    }
    
    # Check PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 7 -or ($PSVersionTable.PSVersion.Major -eq 7 -and $PSVersionTable.PSVersion.Minor -lt 5)) {
        Write-Error "PowerShell 7.5+ is required. You have $($PSVersionTable.PSVersion)"
        Write-Host "Install: https://aka.ms/install-powershell"
        exit 1
    }
    Write-Host "   [OK] PowerShell $($PSVersionTable.PSVersion) detected" -ForegroundColor Green
    
    # Check administrator privileges
    $currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "Some operations require administrator privileges"
        Write-Host "   [OK] Running in user mode (will request elevation if needed)" -ForegroundColor Yellow
    } else {
        Write-Host "   [OK] Running as Administrator" -ForegroundColor Green
    }
    
    Write-Host ""
}

# Detect existing installations
function Find-ExistingInstallations {
    Write-Host "[*] Detecting Existing AI System Installations..." -ForegroundColor Yellow
    
    $installations = @()
    
    # Check common locations
    $commonPaths = @(
        "$env:USERPROFILE\.claude",
        "$env:OneDrive\.claude",
        "$env:USERPROFILE\.config\claude",
        "C:\.claude"
    )
    
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $installations += @{
                Path = $path
                Size = (Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
            }
            Write-Host "   [Folder] Found: $path ($(('{0:N2}' -f $installations[-1].Size)) MB)" -ForegroundColor Yellow
        }
    }
    
    if ($installations.Count -eq 0) {
        Write-Host "   [OK] No existing installations found" -ForegroundColor Green
    } else {
        Write-Host "   [!] Found $($installations.Count) existing installation(s)" -ForegroundColor Yellow
    }
    
    Write-Host ""
    return $installations
}

# Determine workspace path
function Get-WorkspacePath {
    if (-not $WorkspacePath) {
        $defaultPath = "$env:OneDrive\.claude"
        if (-not (Test-Path $env:OneDrive)) {
            $defaultPath = "$env:USERPROFILE\.claude"
        }
        
        Write-Host "[Workspace] Workspace Configuration:" -ForegroundColor Yellow
        Write-Host "   Default workspace: $defaultPath"
        $choice = Read-Host "   Use default workspace? (Y/n)"
        
        if ($choice -notmatch "^[Nn]") {
            $WorkspacePath = $defaultPath
        } else {
            $WorkspacePath = Read-Host "   Enter custom workspace path"
        }
    }
    
    # Normalize path
    $WorkspacePath = $WorkspacePath.TrimEnd('\')
    
    Write-Host "   [>] Selected workspace: $WorkspacePath" -ForegroundColor Green
    Write-Host ""
    return $WorkspacePath
}

# Create backup if needed
function Backup-ExistingInstallation {
    param($workspacePath, $existingInstallations)
    
    if ($existingInstallations.Count -gt 0) {
        Write-Host "[Backup] Backup Configuration:" -ForegroundColor Yellow
        
        foreach ($install in $existingInstallations) {
            if ($install.Path -eq $workspacePath) {
                Write-Host "   [Processing] Installation exists in target workspace"
                $backupPath = "$workspacePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                Write-Host "   [Package] Creating backup: $backupPath"
                
                try {
                    Copy-Item -Path $install.Path -Destination $backupPath -Recurse -Force
                    Write-Host "   [OK] Backup created successfully" -ForegroundColor Green
                } catch {
                    Write-Error "Failed to create backup: $_"
                    exit 1
                }
            }
        }
        Write-Host ""
    }
}

# Install PAI bundle
function Install-PAIBundle {
    param($workspacePath)
    
    Write-Host "[Starting] Installing PAI Bundle..." -ForegroundColor Yellow
    
    # Get current script directory
    $scriptDir = Split-Path -Parent $PSScriptRoot
    $bundlePath = Join-Path $scriptDir "Bundles\PAI"
    
    if (-not (Test-Path $bundlePath)) {
        Write-Error "Bundle not found: $bundlePath"
        exit 1
    }
    
    # Create workspace directory
    if (-not (Test-Path $workspacePath)) {
        Write-Host "   [Folder] Creating workspace directory..."
        New-Item -ItemType Directory -Path $workspacePath -Force | Out-Null
    }
    
    # Copy bundle contents
    Write-Host "   [Package] Copying PAI files..."
    Copy-Item -Path "$bundlePath\*" -Destination $workspacePath -Recurse -Force
    
    Write-Host "   [OK] Bundle installed to: $workspacePath" -ForegroundColor Green
    Write-Host ""
}

# Configure environment variables
function Set-EnvironmentVariables {
    param($workspacePath)
    
    Write-Host "[Config] Environment Configuration..." -ForegroundColor Yellow
    
    # Set PAI_ROOT system variable
    try {
        $envVarName = "PAI_ROOT"
        $envVarValue = $workspacePath
        
        # Check if administrat
        if ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent().IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            [System.Environment]::SetEnvironmentVariable($envVarName, $envVarValue, [System.EnvironmentVariableTarget]::User)
            Write-Host "   [OK] Set user environment variable: $envVarName = $envVarValue" -ForegroundColor Green
        } else {
            # Set for current session only
            $env:PAI_ROOT = $envVarValue
            Write-Host "   [!] Set session variable only (run as Admin for permanent): $envVarName = $envVarValue" -ForegroundColor Yellow
        }
    } catch {
        Write-Warning "Could not set environment variable: $_"
    }
    
    Write-Host ""
}

# Configure Windows security
function Set-WindowsSecurity {
    param($workspacePath)
    
    Write-Host "[Security] Windows Security Configuration..." -ForegroundColor Yellow
    
    try {
        # Add exclusion to Windows Defender if possible
        if ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent().IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            try {
                Add-MpPreference -ExclusionPath $workspacePath -ErrorAction SilentlyContinue
                Write-Host "   [OK] Added Windows Defender exclusion" -ForegroundColor Green
            } catch {
                Write-Warning "Could not set Windows Defender exclusion"
            }
        }
        
        # Set execution policy if needed
        $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
        if ($currentPolicy -eq "Restricted") {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Host "   [OK] Updated execution policy to RemoteSigned" -ForegroundColor Green
        } else {
            Write-Host "   [OK] Execution policy already set: $currentPolicy" -ForegroundColor Green
        }
        
    } catch {
        Write-Warning "Could not configure security settings: $_"
    }
    
    Write-Host ""
}

# Interactive configuration
function Start-InteractiveConfig {
    param($workspacePath)
    
    Write-Host "[Config] Interactive Configuration..." -ForegroundColor Yellow
    
    # User name
    $defaultName = $env:USERNAME
    $userName = Read-Host "   Enter your name [$defaultName]"
    if (-not $userName) { $userName = $defaultName }
    
    # Timezone
    $timezone = [TimeZoneInfo]::Local.DisplayName
    $userTimezone = Read-Host "   Enter your timezone [$timezone]"
    if (-not $userTimezone) { $userTimezone = $timezone }
    
    # Update settings.json
    $settingsPath = Join-Path $workspacePath "settings.json"
    if (Test-Path $settingsPath) {
        try {
            $settings = Get-Content $settingsPath | ConvertFrom-Json
            $settings.user_name = $userName
            $settings.timezone = $userTimezone
            $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath
            Write-Host "   [OK] Updated configuration" -ForegroundColor Green
        } catch {
            Write-Warning "Could not update settings: $_"
        }
    }
    
    Write-Host ""
}

# Create shortcuts
function New-Shortcuts {
    param($workspacePath)
    
    Write-Host "[Shortcuts] Creating Shortcuts..." -ForegroundColor Yellow
    
    try {
        $desktopPath = [Environment]::GetFolderPath("Desktop")
        $startMenuPath = [Environment]::GetFolderPath("Programs")
        
        # Desktop shortcut
        $desktopShortcut = Join-Path $desktopPath "PAI.lnk"
        if (-not (Test-Path $desktopShortcut)) {
            $shell = New-Object -ComObject WScript.Shell
            $shortcut = $shell.CreateShortcut($desktopShortcut)
            $shortcut.TargetPath = "powershell.exe"
            $shortcut.Arguments = "-NoExit -Command `"cd '$workspacePath'; Write-Host 'PAI Environment Ready!' -ForegroundColor Green`""
            $shortcut.WorkingDirectory = $workspacePath
            $shortcut.Description = "PAI - Personal AI Infrastructure"
            $shortcut.Save()
            Write-Host "   [OK] Desktop shortcut created" -ForegroundColor Green
        }
        
    } catch {
        Write-Warning "Could not create shortcuts: $_"
    }
    
    Write-Host ""
}

# Final initialization
function Initialize-PAI {
    param($workspacePath)
    
    Write-Host "[Processing] Final Initialization..." -ForegroundColor Yellow
    
    try {
        Set-Location $workspacePath
        & "$workspacePath\tools\Initialize-PAI.ps1"
        Write-Host "   [OK] PAI initialized successfully" -ForegroundColor Green
    } catch {
        Write-Warning "Could not run initialization: $_"
    }
    
    Write-Host ""
}

# Main execution
try {
    Write-Header
    
    Test-Prerequisites
    $existingInstallations = Find-ExistingInstallations
    $workspacePath = Get-WorkspacePath
    Backup-ExistingInstallation -workspacePath $workspacePath -existingInstallations $existingInstallations
    Install-PAIBundle -workspacePath $workspacePath
    Set-EnvironmentVariables -workspacePath $workspacePath
    Start-InteractiveConfig -workspacePath $workspacePath
    Set-WindowsSecurity -workspacePath $workspacePath
    New-Shortcuts -workspacePath $workspacePath
    Initialize-PAI -workspacePath $workspacePath
    
    Write-Host "[SUCCESS] Installation Complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "[Next Steps]" -ForegroundColor Cyan
    Write-Host "   1. Restart PowerShell to ensure environment variables are loaded"
    Write-Host "   2. Set your API keys as system environment variables:"
    Write-Host "      ANTHROPIC_API_KEY=your_key_here"
    Write-Host "      OPENAI_API_KEY=your_key_here"
    Write-Host "   3. Configure your AI client (Cherry Studio, Claude Code, etc.)"
    Write-Host "   4. Start using PAI!"
    Write-Host ""
    Write-Host "[Docs] Documentation available at: $workspacePath\\README.md" -ForegroundColor Gray
    
} catch {
    Write-Error "Installation failed: $_"
    exit 1
}