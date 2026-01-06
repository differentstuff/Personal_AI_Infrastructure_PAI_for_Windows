# Check PAI State

A diagnostic tool for checking PAI installation status on Windows.

## Usage

Run this diagnostic check to verify your PAI installation:

```powershell
# Navigate to your PAI workspace
cd $env:PAI_Root\.claude

# Check installation state
Get-ChildItem -Recurse -Depth 2 | Where-Object { $_.Extension -eq '.md' } | Select-Object FullName

# Verify pack installation
Test-Path .\skills\CORE
Test-Path .\agents
Test-Path .\tools
```

## What It Checks

### Essential Components

- ✅ **Skills Directory**: `.claude/skills/CORE/` - Core system foundation
  - Constitution.md - PAI constitution and principles
  - SkillSystem.md - Skill management system

- ✅ **Agents Directory**: `.claude/agents/` - AI agent definitions
  - assistant.md - General assistance agent
  - engineer.md - Technical/engineering agent
  - researcher.md - Research and analysis agent

- ✅ **Tools Directory**: `.claude/tools/` - PowerShell utilities
  - Initialize-PAI.ps1 - Installation script
  - modules/PAI/PAI.psm1 - PowerShell module

- ✅ **Configuration Files**:
  - settings.json - PAI configuration
  - .env - Environment variables (API keys, paths)

### Optional Components

- 📁 **Commands Directory**: `.claude/commands/` - Quick command templates
- 📁 **Templates Directory**: `.claude/templates/` - Reusable patterns
- 📁 **MCP Servers**: `.claude/mcp-servers/` - MCP integration
- 📁 **History Directory**: `.claude/history/` - Session logs

## Common Issues

### Issue: Missing `.env` file

**Symptom**: API keys not configured

**Solution**:
```powershell
# Copy example
Copy-Item .env.example .env

# Edit with your API keys
notepad .env
```

### Issue: Agents not visible in AI client

**Symptom**: Agents don't appear in Cherry Studio/Claude Code

**Solution**:
```powershell
# Verify agents directory exists
Test-Path .\agents

# Check individual agent files
Get-ChildItem .\agents\ -Filter *.md

# Verify agent format (each should have proper frontmatter)
Get-Content .\agents\assistant.md -TotalCount 5
```

### Issue: PowerShell module not loading

**Symptom**: `Get-PAIConfig` command not found

**Solution**:
```powershell
# Import module manually
Import-Module .\tools\modules\PAI\PAI.psm1

# Or add to PowerShell profile:
# Add-Content $PROFILE "`nImport-Module `$env:PAI_Root\.claude\tools\modules\PAI\PAI.psm1"
```

## Verification Commands

### Full Installation Check

```powershell
function Test-PAIInstallation {
    $errors = @()
    $workspace = $env:PAI_Root + '\.claude'
    
    # Check core components
    $requiredPaths = @(
        "$workspace\skills\CORE\Constitution.md",
        "$workspace\skills\CORE\SkillSystem.md",
        "$workspace\agents\assistant.md",
        "$workspace\agents\engineer.md",
        "$workspace\agents\researcher.md",
        "$workspace\tools\Initialize-PAI.ps1",
        "$workspace\settings.json",
        "$workspace\.env"
    )
    
    Write-Host "🔍 Checking PAI Installation..." -ForegroundColor Cyan
    Write-Host "   Workspace: $workspace`n" -ForegroundColor Gray
    
    foreach ($path in $requiredPaths) {
        if (Test-Path $path) {
            Write-Host "   ✅ $path" -ForegroundColor Green
        } else {
            Write-Host "   ❌ $path" -ForegroundColor Red
            $errors += $path
        }
    }
    
    if ($errors.Count -eq 0) {
        Write-Host "`n🎉 All required components present!" -ForegroundColor Green
    } else {
        Write-Host "`n⚠️  Missing $($errors.Count) components" -ForegroundColor Yellow
    }
}

# Run check
Test-PAIInstallation
```

## Get PAI Configuration

```powershell
# If modules are working
Get-PAIConfig

# Manual check
Get-Content .\settings.json | ConvertFrom-Json | ConvertTo-Json -Depth 10

# Check environment variables
Get-Content .\.env
```

## Update Status

Check if your installation is up-to-date with the repository:

```powershell
# Compare with repository version
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2

# Check latest changes
git log --oneline -10

# Update if needed
git pull origin main

# Run bundle installer
bun run Bundles/PAI/install.ts
```

## Troubleshooting

### Permissions Issues

If you see "Access Denied" errors, ensure you're running PowerShell with appropriate permissions:

```powershell
# Check execution policy
Get-ExecutionPolicy -Scope CurrentUser

# Set to allow scripts (if needed)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Path Issues

Verify `$PAI_DIR` is set correctly:

```powershell
# Check if PAI_DIR environment variable exists
Get-ChildItem Env:PAI_DIR

# Set if missing
[Environment]::SetEnvironmentVariable("PAI_DIR", "$env:PAI_Root\.claude", "User")

# Restart PowerShell to apply changes
```

## Support

If issues persist:

1. Check the [PAI Architecture Documentation](../docs/ARCHITECTURE.md)
2. Review the [Bundle README](../Bundles/PAI/README.md)
3. Check installation logs in `history/` directory

---

Last updated: 2025-01-15  
Platform: Windows 10/11 + PowerShell 7.5+
Runtime: Bun 1.1+
