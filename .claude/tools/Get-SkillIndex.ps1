#!/usr/bin/env pwsh
<#
.SYNOPSIS
    List all available PAI skills

.DESCRIPTION
    Scans the skills directory and displays all available skills with their metadata

.EXAMPLE
    ./Get-SkillIndex.ps1

.EXAMPLE
    ./Get-SkillIndex.ps1 -Detailed

.NOTES
    Cross-platform: Works on Windows and Linux
#>

[CmdletBinding()]
param(
    [Parameter()]
    [switch]$Detailed
)

$PAI_ROOT = Split-Path -Parent $PSScriptRoot
$skillsDir = Join-Path $PAI_ROOT "skills"

Write-Host "📚 PAI Skills Index" -ForegroundColor Cyan
Write-Host "=" * 60
Write-Host ""

if (-not (Test-Path $skillsDir)) {
    Write-Warning "Skills directory not found: $skillsDir"
    exit 1
}

# Get all skill directories
$skills = Get-ChildItem -Path $skillsDir -Directory | Sort-Object Name

if ($skills.Count -eq 0) {
    Write-Host "No skills found in $skillsDir" -ForegroundColor Yellow
    exit 0
}

foreach ($skill in $skills) {
    $skillMd = Join-Path $skill.FullName "SKILL.md"
    
    # Skill name
    Write-Host "🔧 $($skill.Name)" -ForegroundColor Green
    
    if (Test-Path $skillMd) {
        $content = Get-Content $skillMd -Raw
        
        # Extract metadata (simple regex parsing)
        if ($content -match '(?m)^Name:\s*(.+)$') {
            Write-Host "   Name: $($matches[1])" -ForegroundColor Gray
        }
        
        if ($content -match '(?m)^Description:\s*(.+)$') {
            Write-Host "   Description: $($matches[1])" -ForegroundColor Gray
        }
        
        if ($Detailed) {
            if ($content -match '(?ms)## USE WHEN(.+?)##') {
                $useWhen = $matches[1].Trim()
                Write-Host "   Use When:" -ForegroundColor Gray
                $useWhen -split "`n" | ForEach-Object {
                    if ($_.Trim()) {
                        Write-Host "     • $($_.Trim())" -ForegroundColor DarkGray
                    }
                }
            }
        }
    } else {
        Write-Host "   ⚠️  No SKILL.md found" -ForegroundColor Yellow
    }
    
    Write-Host ""
}

Write-Host "=" * 60
Write-Host "Total Skills: $($skills.Count)" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Tip: Use -Detailed for more information" -ForegroundColor Gray
Write-Host ""
