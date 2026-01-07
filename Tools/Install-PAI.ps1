#!/usr/bin/env pwsh
<#
.SYNOPSIS
    PAI - Personal AI Infrastructure Windows Native Installer
.DESCRIPTION
    Windows-native PowerShell installer for PAI
    Uses PAI_DIR environment variable for path resolution
.PARAMETER InstallDir
    Optional installation directory path
#>

[CmdletBinding()]
param(
    [string]$InstallDir = ""
)

#region Main Installation Function
function Start-PAIInstallation {
    [CmdletBinding()]
    param(
        [string]$InstallDir
    )
    
    try {
        Show-InstallationHeader
        
        if (-not (Test-Prerequisites)) {
            Write-Host "[*] Installing prerequisites..." -ForegroundColor Yellow
            Install-Prerequisites
        }
        
        $paiDirectory = Set-PAIDirectory -InstallDir $InstallDir
        
        Invoke-TypeScriptInstaller -PAIDirectory $paiDirectory
        
        Complete-Installation -PAIDirectory $paiDirectory
        
        Write-Host ""
        Write-Host "[OK] PAI Installation completed successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "Installation failed: $($_.Exception.Message)"
        return $false
    }
}
#endregion

#region Helper Functions
function Show-InstallationHeader {
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║           PAI - Personal AI Infrastructure                   ║" -ForegroundColor Cyan
    Write-Host "║                 Windows Native Installer                     ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Test-Prerequisites {
    Write-Host "[*] Validating Prerequisites..." -ForegroundColor Cyan
    
    $psVersion = $PSVersionTable.PSVersion
    if ($psVersion.Major -ge 7) {
        Write-Host "   [OK] PowerShell $psVersion" -ForegroundColor Green
    } else {
        Write-Host "   [!] PowerShell $psVersion (7.0+ required)" -ForegroundColor Red
        return $false
    }
    
    if ($IsWindows -or $env:OS -eq "Windows_NT") {
        Write-Host "   [OK] Windows detected" -ForegroundColor Green
    } else {
        Write-Host "   [!] This installer is Windows-only" -ForegroundColor Red
        return $false
    }
    
    try {
        $bunVersion = & bun --version 2>$null
        if ($bunVersion) {
            Write-Host "   [OK] Bun $bunVersion detected" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "   [!] Bun not found" -ForegroundColor Yellow
        return $false
    }
    
    return $false
}

function Install-Prerequisites {
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction SilentlyContinue
        
        Write-Host "   [*] Installing Bun..." -ForegroundColor Yellow
        $bunInstallScript = Invoke-WebRequest -Uri "https://bun.sh/install" -UseBasicParsing
        $bunInstallScript.Content | Invoke-Expression
        
        $env:PATH += ";$($env:USERPROFILE)\.bun\bin"
        
        $bunVersion = & bun --version 2>$null
        if ($bunVersion) {
            Write-Host "   [OK] Bun $bunVersion installed" -ForegroundColor Green
        } else {
            throw "Bun installation verification failed"
        }
    }
    catch {
        Write-Error "Failed to install Bun: $($_.Exception.Message)"
        throw
    }
}

function Set-PAIDirectory {
    [CmdletBinding()]
    param(
        [string]$InstallDir
    )
    
    Write-Host "[*] Configuring PAI Directory..." -ForegroundColor Cyan
    
    $existingPAIDir = $env:PAI_DIR
    if ($existingPAIDir -and -not $InstallDir) {
        Write-Host "   [?] Found existing PAI_DIR: $existingPAIDir" -ForegroundColor White
        $choice = Read-Host "   Use existing path? (Y/n)"
        if ($choice -ne 'n') {
            $InstallDir = $existingPAIDir
        }
    }
    
    if (-not $InstallDir) {
        Write-Host ""
        Write-Host "   Select installation location:" -ForegroundColor White
        Write-Host "   1. $($env:USERPROFILE)\.claude" -ForegroundColor Gray
        Write-Host "   2. $($env:OneDrive)\PAI" -ForegroundColor Gray
        Write-Host "   3. Custom path" -ForegroundColor Gray
        Write-Host ""
        
        $selection = Read-Host "   Enter selection (1-3)"
        
        switch ($selection) {
            "1" { $InstallDir = "$($env:USERPROFILE)\.claude" }
            "2" { $InstallDir = "$($env:OneDrive)\PAI" }
            "3" { 
                $InstallDir = Read-Host "   Enter custom path"
                if ([string]::IsNullOrEmpty($InstallDir)) {
                    throw "Custom path cannot be empty"
                }
            }
            default { $InstallDir = "$($env:USERPROFILE)\.claude" }
        }
    }
    
    $InstallDir = $InstallDir -replace '/', '\'
    
    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
        Write-Host "   [OK] Created directory: $InstallDir" -ForegroundColor Green
    }
    
    $env:PAI_DIR = $InstallDir
    
    try {
        [Environment]::SetEnvironmentVariable("PAI_DIR", $InstallDir, "User")
        Write-Host "   [OK] PAI_DIR set to: $InstallDir" -ForegroundColor Green
    }
    catch {
        Write-Warning "   [!] Could not set permanent environment variable: $($_.Exception.Message)"
        Write-Host "   [?] PAI_DIR is set for current session only" -ForegroundColor Yellow
    }
    
    return $InstallDir
}

function Invoke-TypeScriptInstaller {
    [CmdletBinding()]
    param(
        [string]$PAIDirectory
    )
    
    Write-Host "[*] Invoking TypeScript installer..." -ForegroundColor Cyan
    
    try {
        $paiRoot = Split-Path -Parent $PSScriptRoot
        
        $bundlesPath = Join-Path $paiRoot "Bundles\PAI\install.ts"
        
        if (-not (Test-Path $bundlesPath)) {
            throw "Cannot find install.ts at: $bundlesPath"
        }
        
        Write-Host "   [OK] Found install.ts" -ForegroundColor Green
        
        $tsPath = $PAIDirectory.Replace('\', '/')
        
        $bunCommand = "bun run Bundles/PAI/install.ts --install-dir=$tsPath"
        
        Write-Host "   [*] Launching interactive installer in new window..." -ForegroundColor Yellow
        Write-Host "   [*] Command: $bunCommand" -ForegroundColor White
        Write-Host ""
        
        $process = Start-Process -FilePath "pwsh.exe" `
            -ArgumentList "-NoExit", "-Command", "cd '$paiRoot'; $bunCommand; Write-Host ''; Write-Host '[*] Press any key to close this window...'; `$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); exit" `
            -Wait `
            -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Host ""
            Write-Host "   [OK] TypeScript installer completed" -ForegroundColor Green
        } else {
            throw "TypeScript installer failed with exit code $($process.ExitCode)"
        }
        
        if (-not (Test-Path $PAIDirectory)) {
            throw "Installation directory was not created: $PAIDirectory"
        }
        
        Write-Host "   [OK] Installation directory verified" -ForegroundColor Green
    }
    catch {
        Write-Error "TypeScript installer failed: $($_.Exception.Message)"
        throw
    }
}

function Complete-Installation {
    [CmdletBinding()]
    param(
        [string]$PAIDirectory
    )
    
    Write-Host "[*] Verifying installation..." -ForegroundColor Cyan
    
    $expectedItems = @("settings.json", "skills", "agents")
    foreach ($item in $expectedItems) {
        $path = Join-Path $PAIDirectory $item
        if (Test-Path $path) {
            Write-Host "   [OK] Found: $item" -ForegroundColor Green
        } else {
            Write-Host "   [!] Missing: $item" -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "----------------------------------------" -ForegroundColor Cyan
    Write-Host "Next Steps:" -ForegroundColor White
    Write-Host "  1. Configure API keys as environment variables" -ForegroundColor Gray
    Write-Host "  2. Customize settings.json in: $PAIDirectory" -ForegroundColor Gray
    Write-Host "  3. Add PAI directory to your AI client:" -ForegroundColor Gray
    Write-Host "     - Cherry Studio: Add to Knowledge Base" -ForegroundColor DarkGray
    Write-Host "     - Claude Desktop: Set working directory" -ForegroundColor DarkGray
    Write-Host "  4. Environment variable: PAI_DIR=$PAIDirectory" -ForegroundColor Gray
    Write-Host "----------------------------------------" -ForegroundColor Cyan
}
#endregion

try {
    $result = Start-PAIInstallation -InstallDir $InstallDir
    return $result
}
catch {
    Write-Error "Fatal error during installation: $($_.Exception.Message)"
    return $false
}
