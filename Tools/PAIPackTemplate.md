# PAI Pack Template

Specification for creating custom PAI packs on Windows.

## What is a Pack?

A **pack** is a self-contained, installable capability or feature. Unlike bundles, packs DO contain code that gets copied to the user's PAI workspace.

Think of packs like "apps" that you can install independently or as part of a bundle.

## Required Files

```
Packs/YourPack/
├── README.md              ← Pack overview (REQUIRED)
├── INSTALL.md             ← Installation instructions (REQUIRED)
├── VERIFY.md              ← Verification checklist (REQUIRED)
└── src/                   ← Source files (REQUIRED)
    ├── skills/            ← If pack provides skills
    ├── agents/            ← If pack provides agents
    ├── tools/             ← If pack provides tools
    ├── commands/          ← If pack provides commands
    └── install.ts         ← Installation script (OPTIONAL but recommended)
```

## README.md Template

```markdown
# Pack Name

One-line description of what this pack does.

## Overview

Detailed description of the pack's functionality, target users, and use cases.

## What This Pack Provides

- Feature 1 - Description
- Feature 2 - Description
- Feature 3 - Description

## Structure

```
src/
├── skills/          ← Skills this pack adds
├── agents/          ← Agents this pack adds
├── tools/           ← PowerShell tools this pack adds
└── commands/        ← Command templates this pack adds
```

## Installation

### Option 1: Install via Bundle

```powershell
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2
bun run Bundles/PAI/install.ts
```

### Option 2: Install Individually

```powershell
# Copy pack to workspace directly
Copy-Item -Recurse .\Packs\PackName\src\ $env:PAI_Root\.claude\
```

## Usage

Instructions on how to use the features this pack provides.

### Example: Using a Skill

```
# Agent knows about the new skill
Use the [SkillName] skill to do X, Y, Z.
```

### Example: Using a Tool

```powershell
# Import module and use
Import-Module $env:PAI_Root\.claude\tools\modules\PAI\PAI.psm1
Get-PAISkills
```

## Dependencies

List any requirements:
- PAI Core (must be installed first)
- PowerShell 7.5+
- Bun 1.1+ (for install script)
- API keys (if applicable)

## Configuration

If this pack requires configuration:

1. Copy `.env.example` to `.env`
2. Add required variables:
   ```
   FEATURE_API_KEY=your-key-here
   FEATURE_ENDPOINT=https://api.example.com
   ```

## Verification

After installation, verify with:

```powershell
# Check if files exist
Test-Path $env:PAI_Root\.claude\skills\YourSkill

# Check if agents exist
Get-ChildItem $env:PAI_Root\.claude\agents -Filter "*your-agent*"

# Run diagnostic
. C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2\Tools\CheckPAIState.md
```

## Troubleshooting

 common issues and solutions:

### Issue: Something went wrong

**Solution**: Steps to resolve the issue

## Credits

Based on original work by Daniel Miessler's PAI v2.
Adapted for Windows by [Your Name].

## License

MIT License
```

## INSTALL.md Template

```markdown
# Installation: Pack Name

Step-by-step guide for installing this pack.

## Prerequisites

Before installing, ensure you have:

- [x] Windows 10/11
- [x] PowerShell 7.5+ (`pwsh --version`)
- [x] Bun 1.1+ (`bun --version`)
- [x] PAI workspace initialized (`$env:PAI_Root\.claude`)

## Installation Steps

### Step 1: Verify Prerequisites

```powershell
# Check PowerShell version
pwsh --version

# Check Bun installation
bun --version

# Check PAI workspace
Test-Path $env:PAI_Root\.claude
```

### Step 2: Choose Installation Method

#### Method A: Bun Install Script (Recommended)

```powershell
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2

# Run pack's install script (if available)
bun run Packs/PackName/src/install.ts
```

#### Method B: Manual Copy

```powershell
# Copy all files to workspace
Copy-Item -Recurse `
  "C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2\Packs\PackName\src\*" `
  "$env:PAI_Root\.claude\" `
  -Force
```

### Step 3: Configure (If Required)

```powershell
# Add to .env if needed
Add-Content $env:PAI_Root\.claude\.env "`n# Pack Configuration"
Add-Content $env:PAI_Root\.claude\.env "PACK_SETTING=value"
```

### Step 4: Verify Installation

See [VERIFY.md](./VERIFY.md) for verification steps.

## Post-Installation

### Reload AI Client

If using Cherry Studio or Claude Code:
1. Close and reopen the AI client
2. Select the new agent or skill

### Test Functionality

Try using the pack's features:
- [ ] Test feature 1
- [ ] Test feature 2
- [ ] Test feature 3

## Uninstallation

To remove this pack:

```powershell
# Remove pack files
Remove-Item $env:PAI_Root\.claude\skills\YourSkill -Recurse -Force
Remove-Item $env:PAI_Root\.claude\agents\your-agent.md -Force

# Remove configuration from .env
(Get-Content $env:PAI_Root\.claude\.env) -notmatch "PACK_SETTING" | Set-Content $env:PAI_Root\.claude\.env
```

## Troubleshooting

### Issue: Files not copying

**Solution**: Check permissions:
```powershell
# Check if you can write to workspace
Test-Path $env:PAI_Root\.claude
Get-Acl $env:PAI_Root\.claude | Select-Object AccessToString
```

### Issue: Agent not appearing

**Solution**: Verify agent format:
```powershell
# Check agent file format
Get-Content $env:PAI_Root\.claude\agents\your-agent.md -TotalCount 10

# Should have proper frontmatter with name, description, instruction fields
```

---

Last updated: 2025-01-15
Platform: Windows 10/11 + PowerShell 7.5+
Runtime: Bun 1.1+
```

## VERIFY.md Template

```markdown
# Verification: Pack Name

Checklist to verify the pack is correctly installed and functioning.

## File Structure Verification

### Required Files Check

```powershell
$workspace = $env:PAI_Root + "\.claude"

# List files this pack should have installed
$expectedFiles = @(
    "$workspace\skills\YourSkill\SKILL.md",
    "$workspace\agents\your-agent.md",
)

Write-Host "🔍 Verifying Pack Installation..." -ForegroundColor Cyan

foreach ($file in $expectedFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file" -ForegroundColor Red
    }
}
```

### Directory Structure Check

```powershell
# Verify correct directory structure
$dirs = @(
    "$workspace\skills\YourSkill",
)

Write-Host "`n📁 Directory Structure:" -ForegroundColor Cyan

foreach ($dir in $dirs) {
    if (Test-Path $dir) {
        Write-Host "   ✅ $dir" -ForegroundColor Green
        Write-Host "      Files:" -ForegroundColor Gray
        Get-ChildItem $dir | ForEach-Object {
            Write-Host "         - $($_.Name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ❌ $dir" -ForegroundColor Red
    }
}
```

## Functionality Verification

### Skill Verification

```powershell
# Check skill files have correct format
$skillFile = "$workspace\skills\YourSkill\SKILL.md"

if (Test-Path $skillFile) {
    Write-Host "`n🧪 Skill Format Check:" -ForegroundColor Cyan
    
    # Check if file has YAML frontmatter
    $content = Get-Content $skillFile -Raw
    if ($content -match '^---[\s\S]*?---') {
        Write-Host "   ✅ Has YAML frontmatter" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Missing YAML frontmatter" -ForegroundColor Red
    }
    
    # Check for required fields
    if ($content -match 'name:') {
        Write-Host "   ✅ Has 'name' field" -ForegroundColor Green
    }
    if ($content -match 'instruction:') {
        Write-Host "   ✅ Has 'instruction' field" -ForegroundColor Green
    }
}
```

### Agent Verification

```powershell
# Check agent files
$agentFile = "$workspace\agents\your-agent.md"

if (Test-Path $agentFile) {
    Write-Host "`n🤖 Agent Format Check:" -ForegroundColor Cyan
    
    $content = Get-Content $agentFile -Raw
    
    # Verify frontmatter
    if ($content -match '^---[\s\S]*?---') {
        Write-Host "   ✅ Has YAML frontmatter" -ForegroundColor Green
    }
    
    # Verify required fields
    @('name', 'description', 'instruction') | ForEach-Object {
        if ($content -match "$_:") {
            Write-Host "   ✅ Has '$_' field" -ForegroundColor Green
        }
    }
}
```

## Configuration Verification

```powershell
# Check configuration in .env
$envFile = "$workspace\.env"

if (Test-Path $envFile) {
    Write-Host "`n⚙️  Configuration Check:" -ForegroundColor Cyan
    
    $envContent = Get-Content $envFile
    
    # Check for required env variables
    if ($envContent -match "PACK_SETTING") {
        Write-Host "   ✅ PACK_SETTING is configured" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  PACK_SETTING not configured" -ForegroundColor Yellow
    }
}
```

## Integration Verification

### Test with AI Client

1. **Open your AI client** (Cherry Studio, Claude Code)
2. **Select the agent/skill** provided by this pack
3. **Test basic functionality**:
   - [ ] Can the agent be selected?
   - [ ] Does it respond to relevant queries?
   - [ ] Does it use the provided skills?
   - [ ] Are tools accessible?

### Test Key Features

```powershell
# Test each main feature
Write-Host "`n🧪 Feature Tests:" -ForegroundColor Cyan

# Feature 1
$test1 = $false
# Perform test
if ($test1) {
    Write-Host "   ✅ Feature 1: Working" -ForegroundColor Green
} else {
    Write-Host "   ❌ Feature 1: Not working" -ForegroundColor Red
}

# Add more feature tests as needed
```

## PowerShell Tool Verification (If Applicable)

```powershell
# Test if PowerShell tools load correctly
$modulePath = "$workspace\tools\modules\YourModule.psm1"

if (Test-Path $modulePath) {
    Write-Host "`n🔧 PowerShell Tool Check:" -ForegroundColor Cyan
    
    try {
        Import-Module $modulePath -Force
        Write-Host "   ✅ Module loads successfully" -ForegroundColor Green
        
        # Test function
        Get-Command YourPAICommand -ErrorAction SilentlyContinue | Out-Null
        if ($?) {
            Write-Host "   ✅ Commands available" -ForegroundColor Green
        }
    } catch {
        Write-Host "   ❌ Module failed to load: $_" -ForegroundColor Red
    }
}
```

## Full Verification Script

```powershell
function Test-PackInstallation {
    param(
        [string]$PackName = "YourPack"
    )
    
    $workspace = $env:PAI_Root + "\.claude"
    $errors = 0
    $warnings = 0
    $success = 0
    
    Write-Host "🔍 Verifying $PackName Installation..." -ForegroundColor Cyan
    Write-Host "   Workspace: $workspace`n" -ForegroundColor Gray
    
    # Run all checks
    # [Add checks from above sections here]
    
    # Summary
    Write-Host "`n" + ("=" * 50) -ForegroundColor Cyan
    Write-Host "📊 Verification Summary:" -ForegroundColor Cyan
    Write-Host "   ✅ Success: $success" -ForegroundColor Green
    Write-Host "   ⚠️  Warnings: $warnings" -ForegroundColor Yellow
    Write-Host "   ❌ Errors: $errors" -ForegroundColor Red
    
    if ($errors -eq 0 -and $warnings -eq 0) {
        Write-Host "`n🎉 Installation verified successfully!" -ForegroundColor Green
    } elseif ($errors -eq 0) {
        Write-Host "`n✅ Installation verified with minor warnings" -ForegroundColor Yellow
    } else {
        Write-Host "`n⚠️  Installation has errors that need attention" -ForegroundColor Red
    }
}

# Run verification
Test-PackInstallation -PackName "YourPack"
```

## Next Steps After Verification

If all checks pass:
- [ ] Document what the pack adds
- [ ] Add to your bundle if desired
- [ ] Share with others if it's useful

If checks fail:
- [ ] Review failed items
- [ ] Check INSTALL.md for troubleshooting
- [ ] Re-run installation if needed

---

Last updated: 2025-01-15
Platform: Windows 10/11 + PowerShell 7.5+
Runtime: Bun 1.1+
```

## src/ Directory Structure

### Skills (`src/skills/`)

Each skill should have:
```
src/skills/YourSkill/
├── SKILL.md          ← Skill definition with YAML frontmatter
└── support.md        ← Optional: Supporting documentation
```

**SKILL.md Template**:
```markdown
---
name: Skill Name
description: What this skill does
version: 1.0.0
---

# Skill Name

Clear instruction on how to use this skill.

## When to Use This Skill

Use this skill when:
- Condition 1
- Condition 2

## How to Use This Skill

1. Step 1
2. Step 2
3. Step 3

## Example

Example of how the AI should use this skill.
```

### Agents (`src/agents/`)

Each agent should have:
```
src/agents/your-agent.md    ← Single file per agent
```

**Agent Template**:
```markdown
---
name: Agent Name
description: What this agent does
version: 1.0.0
---

# Agent Name

Detailed instruction for the agent.

## Capabilities

- Capability 1
- Capability 2

## Constraints

- Limitation 1
- Limitation 2

## Tone and Style

This agent should:
- Be [adjective]
- Use [style]
- Avoid [behavior]
```

### Tools (`src/tools/`)

```
src/tools/
├── modules/
│   └── YourModule.psm1    ← PowerShell module
├── scripts/
│   └── YourScript.ps1     ← PowerShell script
└── install.ts              ← Pack installation script
```

### Commands (`src/commands/`)

```
src/commands/
└── your-command.md         ← Command template
```

## install.ts Template

```typescript
#!/usr/bin/env bun

/**
 * Pack Installation Script
 * 
 * Installs this pack's files to user's PAI workspace.
 */

import { $, file } from "bun";
import { existsSync, mkdirSync, writeFileSync } from "fs";
import { resolve, join } from "path";

const HOME = process.env.USERPROFILE || process.env.HOME;
const PAI_DIR = process.env.PAI_DIR || `${HOME}/.claude`;

// Files to copy (relative to src/)
const FILES_TO_COPY = [
  "skills/YourSkill/SKILL.md",
  "agents/your-agent.md",
  // Add more files as needed
];

async function installFile(sourcePath: string): Promise<void> {
  const source = resolve(import.meta.dir, sourcePath);
  const dest = join(PAI_DIR, sourcePath);
  
  // Create directory if needed
  const destDir = resolve(dest);
  mkdirSync(destDir, { recursive: true });
  
  // Copy file
  await $`cp ${source} ${dest}`.quiet();
}

async function main() {
  console.log(`Installing pack to ${PAI_DIR}...`);
  
  for (const filePath of FILES_TO_COPY) {
    await installFile(filePath);
    console.log(`  ✅ ${filePath}`);
  }
  
  console.log("Installation complete!");
}

main();
```

## Naming Conventions

### Pack Directory Names
- PascalCase: `YourPackName`
- Descriptive: `Core`, `Agent-Assistant`, `Fabric-Skill`
- Windows-friendly: No spaces, no special characters

### Pack Display Names
- In README.md title: Human-readable name
- Can include spaces: "Core System", "Agent Assistant"

### Skill Names
- PascalCase: `SkillName`
- Consistent with pack name if relevant

### Agent Names
- Lowercase with hyphens: `your-agent.md`
- Matches the "name" field in frontmatter

## Testing Your Pack

Before distributing:

```powershell
# 1. Test in fresh workspace
mkdir $HOME\.claude-test
$env:PAI_DIR = "$HOME\.claude-test"

# 2. Install pack
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2
bun run Packs/YourPack/src/install.ts

# 3. Verify installation
. Tools/CheckPAIState.md

# 4. Test functionality manually
# Open AI client and test

# 5. Cleanup
Remove-Item -Recurse -Force $HOME\.claude-test
```

## Common Pitfalls

### ❌ Don't Do
- Don't include Windows-specific paths in content (`C:\Users\...`)
- Don't hardcode paths - use `$PAI_DIR` or `.claude` relative
- Don't forget to verify files in VERIFY.md
- Don't skip testing in fresh workspace

### ✅ Do
- Do use Bun for installation scripts
- Do make paths cross-platform compatible
- Do provide clear installation instructions
- Do test thoroughly

## Example: Complete Pack

See existing packs for examples:
- `PAI-Core` - Core system installation
- `PAI-Agent-Assistant` - Simple agent pack
- `PAI-Fabric-Skill` - Skill-based pack

---

Last updated: 2025-01-15
Platform: Windows 10/11 + PowerShell 7.5+
Runtime: Bun 1.1+
