# PAI Testing Guide

How to test your Personal AI Infrastructure setup.

## Manual Testing

### 1. Test PowerShell Tools

```powershell
# Navigate to PAI directory
cd C:\Users\jean-\.claude

# Test initialization
./tools/Initialize-PAI.ps1

# Should output:
# ✅ Platform detection
# ✅ Created .env file
# ✅ Created directories
# ✨ PAI Initialized Successfully!
```

### 2. Test PowerShell Module

```powershell
# Import PAI module
Import-Module ./tools/modules/PAI/PAI.psm1

# Test configuration loading
$config = Get-PAIConfig
$config.identity.user_name  # Should show "Jean"

# Test environment validation
Test-PAIEnvironment
# Should show all ✅ checkmarks

# Test skill discovery
Get-PAISkills
# Should list: CORE, fabric, template-skill

# Test agent loading
$agent = Get-PAIAgent -Name "engineer"
$agent.Name  # Should show "engineer"
```

### 3. Test Skill Index

```powershell
# List all skills
./tools/Get-SkillIndex.ps1

# Should output:
# 🔧 CORE
# 🔧 fabric
# 🔧 template-skill
```

### 4. Verify File Structure

```powershell
# Check directory structure
Get-ChildItem -Recurse -Directory | Select-Object FullName

# Should include:
# - agents/
# - hooks/
# - skills/CORE/
# - skills/fabric/
# - skills/template-skill/
# - templates/
# - tools/modules/PAI/
```

## Cherry Studio Integration Testing

### 1. Add PAI to Knowledge Base

1. Open Cherry Studio
2. Settings → Knowledge Base
3. Add Directory: `C:\Users\jean-\.claude`
4. Enable auto-load
5. Restart Cherry Studio

### 2. Test Agent Loading

In Cherry Studio chat:
```
Use the engineer agent
```

Expected: AI should acknowledge and adopt engineer personality

### 3. Test Skill Recognition

```
What skills are available in PAI?
```

Expected: AI should list CORE, fabric, template-skill

### 4. Test Agent Switching

```
Switch to researcher agent
```

Expected: AI should change to research-focused behavior

## Functional Tests

### Test 1: Configuration Loading

**Command:**
```powershell
Import-Module ./tools/modules/PAI/PAI.psm1
$config = Get-PAIConfig
$config | ConvertTo-Json -Depth 5
```

**Expected Output:**
- Valid JSON structure
- identity.user_name = "Jean"
- paths.pai_root = "${PAI_ROOT}"
- All required sections present

### Test 2: Skill Discovery

**Command:**
```powershell
$skills = Get-PAISkills
$skills | Format-Table Name, HasMetadata
```

**Expected Output:**
```
Name           HasMetadata
----           -----------
CORE           True
fabric         True
template-skill True
```

### Test 3: Agent Loading

**Command:**
```powershell
$agents = @("assistant", "engineer", "researcher")
foreach ($agent in $agents) {
    $a = Get-PAIAgent -Name $agent
    Write-Host "$($a.Name): $($a.Content.Length) chars"
}
```

**Expected Output:**
```
assistant: [number] chars
engineer: [number] chars
researcher: [number] chars
```

### Test 4: Environment Validation

**Command:**
```powershell
Test-PAIEnvironment
```

**Expected Output:**
```
Item            Status Path
----            ------ ----
PAI Root        ✅     C:\Users\jean-\.claude
settings.json   ✅     Found
.env            ⚠️      Missing (run Initialize-PAI.ps1)
skills/         ✅     Exists
agents/         ✅     Exists
hooks/          ✅     Exists
tools/          ✅     Exists
templates/      ✅     Exists
```

## Cherry Studio Specific Tests

### Test 1: Knowledge Base Recognition

**In Cherry Studio:**
1. Type: `What files are in the PAI directory?`
2. AI should reference files from `.claude` directory

### Test 2: Agent Activation

**In Cherry Studio:**
1. Type: `Use the engineer agent`
2. Type: `How would you approach debugging a memory leak?`
3. AI should respond with technical depth and code examples

### Test 3: Skill Reference

**In Cherry Studio:**
1. Type: `Show me the CORE skill documentation`
2. AI should reference `skills/CORE/SKILL.md`

### Test 4: Agent Personality

**In Cherry Studio:**
1. Type: `Use the researcher agent`
2. Type: `Explain quantum computing`
3. AI should provide structured analysis with sources

## Troubleshooting Tests

### Issue: Module Not Loading

**Test:**
```powershell
Get-Module -ListAvailable | Where-Object { $_.Name -like "*PAI*" }
```

**Fix:**
```powershell
Import-Module ./tools/modules/PAI/PAI.psm1 -Force
```

### Issue: Skills Not Found

**Test:**
```powershell
Test-Path C:\Users\jean-\.claude\skills
Get-ChildItem C:\Users\jean-\.claude\skills
```

**Fix:**
Ensure skills directory exists and contains SKILL.md files

### Issue: Configuration Not Loading

**Test:**
```powershell
Test-Path C:\Users\jean-\.claude\settings.json
Get-Content C:\Users\jean-\.claude\settings.json | ConvertFrom-Json
```

**Fix:**
Check JSON syntax, ensure no trailing commas

## Performance Tests

### Test: Skill Loading Speed

```powershell
Measure-Command { Get-PAISkills }
```

**Expected:** < 500ms

### Test: Configuration Loading

```powershell
Measure-Command { Get-PAIConfig }
```

**Expected:** < 100ms

### Test: Agent Loading

```powershell
Measure-Command { Get-PAIAgent -Name "engineer" }
```

**Expected:** < 50ms

## Validation Checklist

- [ ] Initialize-PAI.ps1 runs without errors
- [ ] .env file created from .env.example
- [ ] PAI module loads successfully
- [ ] Get-PAIConfig returns valid configuration
- [ ] Test-PAIEnvironment shows all ✅
- [ ] Get-PAISkills lists all skills
- [ ] Get-PAIAgent loads all three agents
- [ ] Cherry Studio recognizes .claude directory
- [ ] Agent switching works in Cherry Studio
- [ ] Skill documentation accessible
- [ ] No PowerShell errors in any script

## Next Steps After Testing

1. **If all tests pass**: Start using PAI!
2. **If tests fail**: Check TROUBLESHOOTING.md
3. **For new features**: Create custom skills
4. **For updates**: Follow Daniel's PAI repo

---

**Testing Complete?** You're ready to use your Personal AI Infrastructure! 🎉
