#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Example tool script for a PAI skill

.DESCRIPTION
    Detailed description of what this tool does

.PARAMETER InputPath
    Description of this parameter

.PARAMETER OutputPath
    Description of this parameter

.EXAMPLE
    ./example-tool.ps1 -InputPath "input.txt" -OutputPath "output.txt"

.NOTES
    Cross-platform: Works on Windows and Linux
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$InputPath,
    
    [Parameter()]
    [string]$OutputPath = "output.txt"
)

# Main logic here
Write-Host "Processing $InputPath..."

# Your code here

Write-Host "✅ Complete! Output saved to $OutputPath"
