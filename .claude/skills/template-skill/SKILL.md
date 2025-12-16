---
Name: template-skill
Description: Template for creating new PAI skills
Version: 1.0.0
Author: Your Name
Tags: [template, example]
Dependencies: []
---

# Skill Name

Brief description of what this skill does and why it's useful.

## USE WHEN

List specific situations where this skill should be activated:
- Situation 1
- Situation 2
- Situation 3

Be specific! This helps the AI know when to use this skill.

## DEPENDENCIES

List any required tools or installations:
```powershell
# Example: Install required Python package
pip install some-package

# Example: Install PowerShell module
Install-Module -Name SomeModule
```

## USAGE

### Basic Usage

Describe how to use this skill:

```powershell
# Example command
./tools/Use-Skill.ps1 -Name "YourSkill" -Parameter "value"
```

### Via AI Assistant

Show how users interact naturally:
- *"Do X using this skill"*
- *"Help me with Y"*

## CONFIGURATION

If this skill needs configuration, document it here:

```json
{
  "skills": {
    "your_skill": {
      "enabled": true,
      "option1": "value1",
      "option2": "value2"
    }
  }
}
```

## WORKFLOWS

### Workflow 1: [Name]

**Goal**: What this workflow accomplishes

**Steps**:
1. Step 1 - What happens
2. Step 2 - What happens
3. Step 3 - What happens

**Output**: What the user gets

### Workflow 2: [Name]

**Goal**: What this workflow accomplishes

**Steps**:
1. Step 1
2. Step 2
3. Step 3

**Output**: Expected results

## EXAMPLES

### Example 1: [Scenario]

**Input**:
```
Example input data or command
```

**Process**:
```
What happens during execution
```

**Output**:
```
Expected output
```

### Example 2: [Scenario]

**Input**: Description or code
**Process**: What the skill does
**Output**: What the user receives

## TOOLS

List any scripts or utilities in this skill's `tools/` directory:

- `tool1.ps1` - Description of what it does
- `tool2.py` - Description of what it does
- `helper.psm1` - PowerShell module with functions

## TIPS

✅ **DO:**
- Best practice 1
- Best practice 2
- Best practice 3

❌ **DON'T:**
- Anti-pattern 1
- Anti-pattern 2
- Anti-pattern 3

## TROUBLESHOOTING

### Problem: [Common Issue]

**Symptoms**: What the user sees

**Solution**: How to fix it
```powershell
# Example fix
command to resolve
```

### Problem: [Another Issue]

**Symptoms**: Description
**Solution**: Steps to resolve

## RESOURCES

- [Link to documentation](https://example.com)
- [Related project](https://github.com/example)
- [Tutorial](https://example.com/tutorial)

## INTEGRATION STATUS

Use these indicators to show completion status:
- ✅ Feature complete and tested
- ⏳ In development
- 🚧 Planned but not started
- ❌ Deprecated or removed

Example:
- ✅ Basic functionality
- ✅ Cross-platform support
- ⏳ Advanced features
- 🚧 GUI interface

---

## METADATA

**Version History**:
- 1.0.0 (2025-01-15) - Initial release

**Compatibility**:
- Windows 11 ✅
- Linux ✅
- macOS ⏳

**Maintainer**: Your Name (@username)

**License**: MIT
