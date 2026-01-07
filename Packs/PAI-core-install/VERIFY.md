# PAI-Core Verification Checklist

**Automated and manual verification of PAI-Core installation**

---

## 🤖 Automated Verification

Ask your AI client to verify installation:

```
Verify my PAI-Core installation step by step:

1. Check if CORE skill exists and contains Constitution.md and SkillSystem.md
2. Read the 13 Founding Principles from Constitution.md and summarize the first 5
3. Check if settings.json exists and validate its JSON structure
4. Check if commands/init.md exists
5. Check if these directories exist: skills/, commands/, history/, hooks/, mcp-servers/
6. Confirm your user name and timezone from settings.json
7. List any other skills present in the skills/ directory
8. Report overall installation status with specific failures if any
```

**Expected Output:**
- ✅ CORE skill found with Constitution.md and SkillSystem.md
- ✅ Displays summary of 5 principles
- ✅ settings.json exists and is valid JSON
- ✅ commands/init.md exists
- ✅ All required directories present
- ✅ Shows your user name and timezone from settings
- ✅ Lists other skills (if any other packs installed)

---

## ✅ Manual Verification Checklist

### 1. Directory Structure

Verify these directories exist in your workspace (`$env:OneDrive\.claude`):

```powershell
# Test workspace path
$WorkspacePath = "$env:OneDrive\.claude"

# Check each directory
$Directories = @(
    "skills",
    "agents",
    "commands",
    "templates",
    "history", 
    "hooks",
    "mcp-servers",
    "tools"
)

foreach ($Dir in $Directories) {
    $Path = Join-Path $WorkspacePath $Dir
    if (Test-Path $Path) {
        Write-Host "✅ $Dir/ exists" -ForegroundColor Green
    } else {
        Write-Host "❌ $Dir/ missing" -ForegroundColor Red
    }
}
```

---

### 2. CORE Skill Components

```powershell
# Check CORE skill files
$COREPath = Join-Path $WorkspacePath "skills\CORE"

$Files = @(
    (Join-Path $COREPath "Constitution.md"),
    (Join-Path $COREPath "SkillSystem.md")
)

foreach ($File in $Files) {
    if (Test-Path $File) {
        Write-Host "✅ $File exists" -ForegroundColor Green
    } else {
        Write-Host "❌ $File missing" -ForegroundColor Red
    }
}
```

---

### 3. Configuration Files

```powershell
# Check settings.json
$SettingsPath = Join-Path $WorkspacePath "settings.json"
if (Test-Path $SettingsPath) {
    Write-Host "✅ settings.json exists" -ForegroundColor Green
    
    # Validate JSON syntax
    try {
        $Settings = Get-Content $SettingsPath | ConvertFrom-Json
        Write-Host "✅ settings.json is valid JSON" -ForegroundColor Green
        
        # Check required fields
        if ($Settings.user) {
            Write-Host "✅ user section present" -ForegroundColor Green
        } else {
            Write-Host "⚠️ user section missing" -ForegroundColor Yellow
        }
        
        if ($Settings.defaults) {
            Write-Host "✅ defaults section present" -ForegroundColor Green
        } else {
            Write-Host "⚠️ defaults section missing" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ settings.json has invalid JSON: $_" -ForegroundColor Red
    }
} else {
    Write-Host "❌ settings.json missing" -ForegroundColor Red
}

# Check .env file
$EnvPath = Join-Path $WorkspacePath ".env"
if (Test-Path $EnvPath) {
    Write-Host "✅ .env exists" -ForegroundColor Green
} else {
    Write-Host "⚠️ .env not found (optional)" -ForegroundColor Yellow
}
```

---

### 4. Command Templates

```powershell
# Check command files
$CommandsPath = Join-Path $WorkspacePath "commands"

if (Test-Path (Join-Path $CommandsPath "init.md")) {
    Write-Host "✅ commands/init.md exists" -ForegroundColor Green
} else {
    Write-Host "❌ commands/init.md missing" -ForegroundColor Red
}
```

---

### 5. Content Validation

**Via AI Client:**

Ask: "Read the Constitution from the CORE skill and tell me Principle 1"

**Expected**: AI reads `$env:OneDrive\.claude\skills\CORE\Constitution.md` and explains "Clear Thinking + Prompting is King" [7]

---

### 6. AI Client Integration

**Test Context Initialization:**

Ask your AI: "Initialize my PAI context"

**Expected**: AI reads `commands/init.md` and provides:
- Current date and time
- Your user name from settings.json
- Timezone from settings.json
- Available skills list
- System context [6][9]

---

### 7. PowerShell Version Check

```powershell
# Verify PowerShell 7.0+
$PSVersion = $PSVersionTable.PSVersion

Write-Host "PowerShell Version: $($PSVersion.Major).$($PSVersion.Minor).$($PSVersion.Build)" -ForegroundColor Cyan

if ($PSVersion.Major -ge 7) {
    Write-Host "✅ PowerShell version meets requirement (7.0+)" -ForegroundColor Green
} else {
    Write-Host "❌ PowerShell version too old (required: 7.0+)" -ForegroundColor Red
}
```

---

### 8. Path Resolution

```powershell
# Test path variables
if (Test-Path $env:OneDrive) {
    Write-Host "✅ OneDrive path exists: $env:OneDrive" -ForegroundColor Green
} else {
    Write-Host "❌ OneDrive path not found" -ForegroundColor Red
}

$PAI_DIR = $env:PAI_DIR
if ($PAI_DIR) {
    Write-Host "✅ PAI_DIR environment variable set: $PAI_DIR" -ForegroundColor Green
} else {
    Write-Host "⚠️ PAI_DIR not set (will use settings.json paths)" -ForegroundColor Yellow
}
```

---

## 🔍 Diagnostic Commands

### Full Diagnostic Report

```powershell
# Generate diagnostic report
$WorkspacePath = "$env:OneDrive\.claude"

Write-Host "=== PAI-Core Diagnostic Report ===" -ForegroundColor Cyan
Write-Host "Workspace: $WorkspacePath" -ForegroundColor Cyan
Write-Host "PowerShell: $($PSVersionTable.PSVersion)" -ForegroundColor Cyan
Write-Host ""

# Directory check
Write-Host "1. Directory Structure:" -ForegroundColor Yellow
$Dirs = @("skills","agents","commands","templates","history","hooks","mcp-servers","tools")
foreach ($Dir in $Dirs) {
    $Status = if (Test-Path (Join-Path $WorkspacePath $Dir)) { "✅" } else { "❌" }
    Write-Host "   $Status $Dir/" 
}
Write-Host ""

# CORE skill check
Write-Host "2. CORE Skill:" -ForegroundColor Yellow
$COREPath = Join-Path $WorkspacePath "skills\CORE"
if (Test-Path $COREPath) {
    $Files = Get-ChildItem $COREPath -File
    Write-Host "   ✅ CORE/ directory exists with $($Files.Count) files:"
    $Files | ForEach-Object { Write-Host "      - $($_.Name)" }
} else {
    Write-Host "   ❌ CORE/ directory missing"
}
Write-Host ""

# Configuration check
Write-Host "3. Configuration:" -ForegroundColor Yellow
$SettingsPath = Join-Path $WorkspacePath "settings.json"
if (Test-Path $SettingsPath) {
    try {
        $Settings = Get-Content $SettingsPath | ConvertFrom-Json
        Write-Host "   ✅ settings.json is valid"
        if ($Settings.user.name) {
            Write-Host "      User: $($Settings.user.name)"
        }
        if ($Settings.user.timezone) {
            Write-Host "      Timezone: $($Settings.user.timezone)"
        }
    } catch {
        Write-Host "   ❌ settings.json invalid: $_"
    }
} else {
    Write-Host "   ❌ settings.json missing"
}
Write-Host ""

Write-Host "=== End Report ===" -ForegroundColor Cyan
```

---

## 🎯 Success Criteria

PAI-Core is correctly installed if:

- ✅ All directories exist (skills/, commands/, history/, etc.)
- ✅ CORE skill is present with Constitution.md and SkillSystem.md [7]
- ✅ settings.json exists and is valid JSON [9][10]
- ✅ commands/init.md exists [6]
- ✅ AI can read the Constitution and explain principles
- ✅ Initialization command ("Initialize my PAI context") works
- ✅ PowerShell version is 7.0+
- ✅ Workspace path is correct

---

## ❌ Common Issues and Solutions

### Issue: "No CORE skill found"

**Check:**
```powershell
Test-Path $env:OneDrive\.claude\skills\CORE
```

**Fix:** Reinstall PAI-Core pack

---

### Issue: Invalid JSON in settings.json

**Check:**
```powershell
Get-Content $env:OneDrive\.claude\settings.json | ConvertFrom-Json
```

**Fix:** Restore from .env.example or fix JSON syntax

---

### Issue: Commands not loading

**Check:**
```powershell
Get-ChildItem $env:OneDrive\.claude\commands
```

**Fix:** Ensure commands/ directory contains init.md

---

## 📋 Full Verification Summary

Run all checks at once:

```powershell
# Complete verification
$Workspace = "$env:OneDrive\.claude"
$Pass = 0
$Fail = 0

Write-Host "=== PAI-Core Full Verification ===" -ForegroundColor Cyan
Write-Host ""

# Directories
Write-Host "Checking directories..." -ForegroundColor Yellow
$Dirs = @("skills","agents","commands","templates","history","hooks","mcp-servers","tools")
foreach ($Dir in $Dirs) {
    if (Test-Path (Join-Path $Workspace $Dir)) {
        Write-Host "  ✅ $Dir/" -ForegroundColor Green
        $Pass++
    } else {
        Write-Host "  ❌ $Dir/" -ForegroundColor Red
        $Fail++
    }
}
Write-Host ""

# Files
Write-Host "Checking core files..." -ForegroundColor Yellow
$Files = @(
    "skills\CORE\Constitution.md",
    "skills\CORE\SkillSystem.md",
    "commands\init.md",
    "settings.json"
)
foreach ($File in $Files) {
    if (Test-Path (Join-Path $Workspace $File)) {
        Write-Host "  ✅ $File" -ForegroundColor Green
        $Pass++
    } else {
        Write-Host "  ❌ $File" -ForegroundColor Red
        $Fail++
    }
}
Write-Host ""

# Summary
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Passed: $Pass" -ForegroundColor Green
Write-Host "Failed: $Fail" -ForegroundColor $(if ($Fail -eq 0) { "Green" } else { "Red" })

if ($Fail -eq 0) {
    Write-Host ""
    Write-Host "🎉 PAI-Core verification PASSED!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "⚠️ PAI-Core verification FAILED with $Fail issues" -ForegroundColor Red
}
```

---

✅ **Run these checks to ensure PAI-Core is properly installed!**
