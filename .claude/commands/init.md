# Init - Initialize PAI Context

## Purpose
Initializes Personal AI Infrastructure (PAI) and provides current session context. This command gathers system state and prepares the environment for AI interaction.

## What It Does

### System Setup (First-Time)
1. Validates PowerShell version (7.0+ required)
2. Creates `.env` from template (optional, for Claude Code)
3. Creates `history/` directory (for session logs)
4. Creates `C:\Temp` if needed
5. Checks Python installation (optional but useful)

### Context Gathering (Every Session)
1. Gets current date/time and timezone
2. Reads PAI configuration from `settings.json`
3. Loads active agent configuration
4. Reports system status

## Usage

### First-Time Setup
```powershell
# Navigate to PAI root
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows\.claude

# Run initialization
./tools/Initialize-PAI.ps1
```

### Session Initialization
```powershell
# Get current context (paste output to AI)
./tools/Initialize-PAI.ps1
```

### Expected Output
```
🚀 Initializing Personal AI Infrastructure (PAI)

📋 Platform Detection:
   OS: Windows
   PowerShell: 7.5.0
   PAI Root: C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows\.claude

📝 Creating .env file (optional, for Claude Code)...
   ✅ Created .env (API keys should be system env vars!)
   ✅ Created history directory

🎯 Configuration:
   settings.json - Your identity and preferences
   .env          - Optional (Claude Code compatibility)
   System Env    - API keys (recommended)
   settings.*.example.json - GUI-specific configs

   ✅ Python detected: Python 3.11.5

✨ PAI Initialized Successfully!

📚 Next Steps:
   1. Set API keys as system environment variables (recommended)
   2. Customize settings.json
   3. Connect your AI client (Cherry Studio, LibreChat, etc.)
   4. Run: ./tools/Get-SkillIndex.ps1

📖 Documentation: README.md
```

## When to Use

### First-Time Setup
- After cloning or downloading PAI
- When setting up on a new machine
- After major updates

### Regular Use
- Start of new conversation/session
- After configuration changes
- When context seems missing
- Before complex multi-step tasks

## Configuration Files

### `settings.json` (Primary)
Core PAI settings:
```json
{
  "user": {
    "name": "Your Name",
    "timezone": "Europe/Zurich"
  },
  "defaults": {
    "assistant_name": "Clippy",
    "agent": "assistant",
    "skills_always_load": ["CORE"]
  }
}
```

### `.env` (Optional)
For Claude Code compatibility:
```env
PAI_ROOT=C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows\.claude
TEMP_DIR=C:\Temp
DA=Clippy
```

**Note**: API keys should be system environment variables, not in `.env`!

### GUI-Specific Settings
- `settings.claudecode.example.json` - Claude Code specific
- `settings.cherrystudio.example.json` - Cherry Studio specific
- Copy and customize for your GUI

## Prerequisites

### Required
- **Windows 11** (or Windows 10 with PowerShell 7.0+)
- **PowerShell 7.0+** (recommended: 7.5+)
  ```powershell
  # Check version
  $PSVersionTable.PSVersion
  
  # Install/update
  winget install Microsoft.PowerShell
  ```

### Optional
- **Python 3.x** (for advanced features like Fabric integration)
- **Git** (for PAI updates via `/paiupdate`)
- **Fabric** (for pattern integration)
  ```powershell
  pip install fabric-ai
  fabric --setup
  ```

## Directory Structure After Init

```
.claude/
├── settings.json          ← Your configuration
├── .env                   ← Optional (gitignored)
├── history/               ← Session logs (gitignored)
│   └── 2024-12/          ← Organized by month
├── agents/                ← Agent personalities
│   ├── assistant.md
│   ├── engineer.md
│   ├── researcher.md
│   └── architect.md
├── skills/                ← Capabilities
│   ├── CORE/
│   ├── fabric/
│   ├── research/
│   └── security/
├── commands/              ← Command templates
├── tools/                 ← Management scripts
│   ├── Initialize-PAI.ps1 ← This script
│   └── modules/PAI/       ← PowerShell module
└── [other directories...]
```

## Troubleshooting

### PowerShell Version Too Old
```powershell
# Install PowerShell 7.5
winget install Microsoft.PowerShell

# Or download from
# https://aka.ms/install-powershell
```

### Permission Issues
```powershell
# Run as Administrator if needed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Path Issues
```powershell
# Verify PAI_ROOT
$env:PAI_ROOT
# Should output: C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows\.claude

# Set if missing
$env:PAI_ROOT = "C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows\.claude"
```

### Module Not Found
```powershell
# Import PAI module manually
Import-Module ./tools/modules/PAI/PAI.psm1

# Test
Test-PAIEnvironment
```

## Security Notes

### Never Commit
- `.env` file (contains paths, possibly secrets)
- `history/` directory (personal session data)
- Any files with API keys

### Best Practices
- Use **system environment variables** for API keys
- Keep `.env` for local-only configuration
- Use `.gitignore` to exclude sensitive files
- Store encrypted backups separately (OneDrive, etc.)

## Future Enhancements

### Coming Soon
- [ ] Auto-run via hooks (on session start)
- [ ] MCP server integration (automatic context injection)
- [ ] Advanced RAG integration
- [ ] Multi-GUI sync

### Phase 2
- [ ] Cloud backup/sync
- [ ] Team configurations
- [ ] Custom initialization profiles

## Related Commands

- `/paiupdate` (or `/pa`) - Update PAI safely
- `./tools/Get-SkillIndex.ps1` - List available skills
- `./tools/modules/PAI/PAI.psm1` - Core functions

## Examples

### Quick Start
```powershell
# Clone/download PAI
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows\.claude

# Initialize
./tools/Initialize-PAI.ps1

# Customize settings
notepad settings.json

# Connect to Cherry Studio
# Settings → Knowledge Base → Add Directory → Browse to .claude folder

# You're ready!
```

### Daily Use
```powershell
# At the start of each session
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows\.claude
./tools/Initialize-PAI.ps1

# Copy output to AI chat for context
```

### After Updates
```powershell
# Pull updates
/paiupdate

# Re-initialize
./tools/Initialize-PAI.ps1

# Verify
./tools/Get-SkillIndex.ps1
```

---

**Last Updated**: 2024-12-16  
**Version**: 1.0.0  
**Platform**: Windows 11, PowerShell 7.5+

$ARGUMENTS
