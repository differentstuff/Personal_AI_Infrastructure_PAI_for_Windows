# Custom Slash Commands

This directory contains custom slash commands that extend AI client functionality (primarily designed for Claude Code, but work as templates in other GUIs).

## How Slash Commands Work

Files in this directory become available as `/command-name` in compatible AI clients. For example:
- `init.md` → `/init`
- `paiupdate.md` → `/paiupdate`
- `my-workflow.md` → `/my-workflow`

**For Claude Code**: Commands work as native slash commands  
**For Cherry Studio/Other GUIs**: Commands are templates that AI references

## Creating a Slash Command

1. Create a markdown file in this directory
2. The file content becomes the prompt that runs when you invoke the command
3. Use `$ARGUMENTS` to capture any text after the command

### Example: `/summarize`

```markdown
Summarize the following content in 3 bullet points:

$ARGUMENTS
```

Then use it: `/summarize [paste your content here]`

## Built-in Commands

### Core Commands

- **`/init`** - Initialize PAI context
  - Sets up environment
  - Gathers system state
  - Loads configuration
  - Use at session start or after config changes

- **`/paiupdate`** - PAI Update System (full version)
  - Safely update PAI from upstream
  - Analyzes conflicts with your customizations
  - Intelligent merge recommendations
  - Backup before changes
  - Full interactive workflow

- **`/pa`** - PAI Update (shortcut)
  - Quick shortcut for `/paiupdate`
  - Same functionality, less typing

### Example Commands

- `example.md` - A simple example showing the pattern

## Your Commands

Add your own slash commands here. Common use cases:
- Research workflows
- Code review templates
- Writing assistance
- Daily standup formats
- Custom analysis patterns
- Project-specific workflows

These are personal to your setup - add whatever helps your workflow.

## Command Best Practices

### Structure
```markdown
# Command Name - Brief Description

## Purpose
What this command does

## Usage
How to use it

## Examples
Concrete examples

## When to Use
Guidance for when to invoke

$ARGUMENTS
```

### Tips
- Keep commands focused (single purpose)
- Use clear, descriptive names
- Document expected inputs
- Provide examples
- Consider command chaining

### PowerShell Integration
Commands can reference PowerShell scripts:
```markdown
# My Command

Execute this workflow:

1. First, run this PowerShell command:
```powershell
./tools/MyScript.ps1
```

2. Then analyze the output...

$ARGUMENTS
```

## Platform Compatibility

### Claude Code (Native)
- Commands work as `/command-name`
- Arguments passed automatically
- Full integration

### Cherry Studio (Template Mode)
- AI reads command files via Knowledge Base
- Use command names in conversation
- Manual execution of PowerShell commands

### LibreChat (RAG Mode)
- Commands indexed via RAG
- Reference by name in prompts
- Script execution manual

### Generic/Other Clients
- Commands are markdown templates
- Copy/paste approach
- Flexible integration

## Command Development

### Testing
```powershell
# Test your command
Get-Content ./commands/mycommand.md

# Verify $ARGUMENTS placeholder exists
Select-String -Path ./commands/mycommand.md -Pattern '\$ARGUMENTS'
```

### Version Control
- Commands are part of PAI
- Commit your custom commands
- Share with team or community
- Keep upstream commands separate

### Updates
When running `/paiupdate`:
- Your custom commands are preserved
- Upstream commands offered as updates
- Conflicts highlighted
- You choose what to merge

## Security

### Safe Practices
- Review commands before execution
- Don't include secrets in commands
- Use environment variables for sensitive data
- Validate user input when needed

### Dangerous Patterns (Avoid)
```markdown
# ❌ BAD: Hardcoded secrets
$apiKey = "sk-abc123..."

# ❌ BAD: Unvalidated user input
Remove-Item $ARGUMENTS -Recurse -Force

# ✅ GOOD: Environment variables
$apiKey = $env:MY_API_KEY

# ✅ GOOD: Validated input
if (Test-Path $ARGUMENTS) {
    Remove-Item $ARGUMENTS -Confirm
}
```

## Examples

### Simple Command
```markdown
# /hello

Greet the user warmly and ask how you can help today.

$ARGUMENTS
```

### Workflow Command
```markdown
# /review

You are conducting a thorough code review. For each file:

1. Check code quality
2. Identify security issues
3. Suggest improvements
4. Rate overall quality (1-10)

$ARGUMENTS
```

### PowerShell Integration
```markdown
# /backup

Create a backup of current project state:

```powershell
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = "C:\\Temp\\Backups\\project_$timestamp"
Copy-Item -Path . -Destination $backupPath -Recurse
Write-Host "Backup created: $backupPath"
```

Then analyze the backup status.

$ARGUMENTS
```

## Related Documentation

- `../README.md` - Main PAI documentation
- `../ARCHITECTURE.md` - System architecture
- `../tools/README.md` - PowerShell tooling
- `../skills/CORE/SkillSystem.md` - Skill creation guide

---

**Command Count**: 4 (init, paiupdate, pa, example)  
**Last Updated**: 2024-12-16  
**Version**: 1.0.0
