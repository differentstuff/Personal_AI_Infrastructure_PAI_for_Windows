#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Initialize Personal AI Infrastructure (PAI)

.DESCRIPTION
    Sets up PAI for first-time use:
    - Creates .env from template (optional)
    - Configures paths
    - Validates prerequisites
    - Windows 11 + PowerShell 7.5 optimized

.EXAMPLE
    ./Initialize-PAI.ps1

.NOTES
    Platform: Windows 11
    PowerShell: 7.5+
    API keys should be set as system environment variables, not in .env
#>

[CmdletBinding()]
param()

# Ensure we're in the PAI root directory
$PAI_ROOT = Split-Path -Parent $PSScriptRoot
Push-Location $PAI_ROOT

Write-Host "🚀 Initializing Personal AI Infrastructure (PAI)" -ForegroundColor Cyan
Write-Host ""

# Platform info
Write-Host "📋 Platform Detection:" -ForegroundColor Yellow
Write-Host "   OS: Windows"
Write-Host "   PowerShell: $($PSVersionTable.PSVersion)"
Write-Host "   PAI Root: $PAI_ROOT"
Write-Host ""

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Warning "PowerShell 7.0+ recommended. You have $($PSVersionTable.PSVersion)"
    Write-Host "Install: https://aka.ms/install-powershell"
}

# Create .env if it doesn't exist (optional, for Claude Code)
if (-not (Test-Path ".env")) {
    Write-Host "📝 Creating .env file (optional, for Claude Code)..." -ForegroundColor Green
    Copy-Item ".env.example" ".env"
    
    # Set PAI_ROOT in .env (replace %USERPROFILE% with actual path)
    $userProfile = $env:USERPROFILE
    (Get-Content ".env") -replace '%USERPROFILE%\\.', $userProfile | Set-Content ".env"
    
    Write-Host "   ✅ Created .env (API keys should be system env vars!)" -ForegroundColor Green
} else {
    Write-Host "   ⏭️  .env already exists" -ForegroundColor Gray
}

# Create history directory
if (-not (Test-Path "history")) {
    New-Item -ItemType Directory -Path "history" | Out-Null
    Write-Host "   ✅ Created history directory" -ForegroundColor Green
}

# Create temp directory
if (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" | Out-Null
    Write-Host "   ✅ Created C:\Temp" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎯 Configuration:" -ForegroundColor Yellow
Write-Host "   settings.json - Your identity and preferences"
Write-Host "   .env          - Optional (Claude Code compatibility)"
Write-Host "   System Env    - API keys (recommended)"
Write-Host "   settings.*.example.json - GUI-specific configs"
Write-Host ""

# Check for Python (optional but useful)
$pythonInstalled = $null -ne (Get-Command python -ErrorAction SilentlyContinue) -or 
                   $null -ne (Get-Command python3 -ErrorAction SilentlyContinue)

if ($pythonInstalled) {
    $pythonVersion = if (Get-Command python -ErrorAction SilentlyContinue) {
        python --version
    } else {
        python3 --version
    }
    Write-Host "   ✅ Python detected: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Python not found (optional, but useful for advanced features)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✨ PAI Initialized Successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📚 Next Steps:" -ForegroundColor Cyan
Write-Host "   1. Set API keys as system environment variables (recommended)"
Write-Host "   2. Customize settings.json"
Write-Host "   3. Connect your AI client (Cherry Studio, LibreChat, etc.)"
Write-Host "   4. Run: ./tools/Get-SkillIndex.ps1"
Write-Host ""
Write-Host "📖 Documentation: README.md" -ForegroundColor Gray
Write-Host ""

Pop-Location
