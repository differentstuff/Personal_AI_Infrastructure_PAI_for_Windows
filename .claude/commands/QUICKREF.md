# Quick Reference - PAI Commands

**Personal AI Infrastructure (PAI) for Windows**  
**Last Updated**: 2024-12-16 @ 12:30 CET

---

## Commands Available

### `/init` - Initialize PAI Context
**Purpose**: Set up environment and gather current context  
**When**: Session start, after config changes  
**Usage**: Just type `/init` in your AI client

**What it does**:
- Validates PowerShell version
- Creates necessary directories
- Outputs current system state
- Gathers configuration

---

### `/paiupdate` - Update PAI System
**Purpose**: Safely sync with upstream PAI repository  
**When**: Want latest features, bug fixes, improvements  
**Usage**: Type `/paiupdate` and follow prompts

**Features**:
- ✅ Intelligent conflict detection
- ✅ Automatic backups before changes
- ✅ Preserves your customizations
- ✅ Interactive decision-making
- ✅ Rollback capability

**Decision Options**:
- **[A]** Auto - Apply all safe updates + new features (recommended)
- **[S]** Step - Review each change individually
- **[C]** Conservative - Only safe updates, skip new
- **[M]** Manual - Show diffs, you decide everything
- **[N]** Not now - Keep staging for later review

---

### `/pa` - Update PAI (Shortcut)
**Purpose**: Quick access to `/paiupdate`  
**When**: Same as `/paiupdate`, just faster to type  
**Usage**: Type `/pa`

---

## Update Workflow

```
┌──────────────────────────────────────────────────────────┐
│  Phase 1: Fetch Upstream                                 │
│  • Git fetch from upstream repo                          │
│  • Extract to staging directory (.claude/pai_updates/)   │
│  • Record version info                                   │
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│  Phase 2: Analyze Differences                            │
│  • Compare staging vs your current files                 │
│  • Categorize changes:                                   │
│    🔴 Conflicts (both changed)                           │
│    🟢 Safe (only upstream changed)                       │
│    🆕 New (new features available)                       │
│    📝 Your files (preserved)                             │
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│  Phase 3: Generate Report                                │
│  • Visual summary of changes                             │
│  • Detailed conflict information                         │
│  • Recommendations                                       │
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│  Phase 4: User Decision                                  │
│  • Present options [A/S/C/M/N]                           │
│  • Get your approval                                     │
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│  Phase 5: Execute Updates                                │
│  • Create backups (.claude/pai_backups/)                 │
│  • Apply approved changes                                │
│  • Smart merge settings.json                             │
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│  Phase 6: Validate                                       │
│  • Check JSON syntax                                     │
│  • Verify file integrity                                 │
│  • Report results                                        │
└──────────────────────────────────────────────────────────┘
                           ↓
┌──────────────────────────────────────────────────────────┐
│  Phase 7: Track & Cleanup                                │
│  • Update .pai-sync-history                              │
│  • Clean temp files (optional)                           │
└──────────────────────────────────────────────────────────┘
```

---

## Files & Directories

### Command Files
```
commands/
├── init.md         - Session initialization
├── paiupdate.md    - Full update system
├── pa.md           - Update shortcut
├── README.md       - Commands documentation
└── QUICKREF.md     - This file
```

### Created by /paiupdate
```
.claude/
├── pai_updates/             - Staging directory (temporary)
│   └── [upstream files]     - Fresh from upstream
├── pai_backups/             - Backups (preserved)
│   ├── skills_20241216_123045/
│   ├── hooks_20241216_123045/
│   └── settings_20241216_123045.json
└── .pai-sync-history        - Sync tracking
```

---

## Protected Customizations

**These are NEVER overwritten without asking**:
- ✅ `settings.json` → Your `assistant_name` preserved
- ✅ Your skills (not in upstream) → Fully preserved
- ✅ Your agents (not in upstream) → Fully preserved
- ✅ Your commands (not in upstream) → Fully preserved
- ✅ Modified hooks → Flagged for review
- ✅ `.env` file → Never touched

**Example upstream skills**: CORE, fabric, research, security, code-analysis  
**Example upstream agents**: assistant, engineer, researcher, architect

---

## PowerShell Commands

### Check Version
```powershell
$PSVersionTable.PSVersion
# Should be 7.0+
```

### Navigate to PAI
```powershell
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows\.claude
```

### Initialize PAI
```powershell
./tools/Initialize-PAI.ps1
```

### List Skills
```powershell
./tools/Get-SkillIndex.ps1
```

### Check Git Status
```powershell
git status
git remote -v
git log -1
```

### Manual Backup
```powershell
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
Copy-Item . -Destination "C:\Temp\PAI_Backup_$timestamp" -Recurse -Exclude ".git"
```

---

## Troubleshooting

### Command Not Found
**Issue**: `/paiupdate` not recognized  
**Solution**: 
- Verify file exists: `commands/paiupdate.md`
- Check AI client has access to `.claude` directory
- For Cherry Studio: Add to Knowledge Base
- For Claude Code: Should auto-discover

### Git Issues
**Issue**: `git fetch` fails  
**Solution**:
```powershell
# Check git installed
git --version

# Check upstream remote
git remote get-url upstream

# Add if missing
git remote add upstream https://github.com/differentstuff/Personal_AI_Infrastructure_PAI_for_Windows.git

# Try fetching
git fetch upstream main
```

### PowerShell Version
**Issue**: Old PowerShell version  
**Solution**:
```powershell
# Install PowerShell 7.5
winget install Microsoft.PowerShell

# Or download from
# https://aka.ms/install-powershell
```

### Permission Denied
**Issue**: Can't create directories  
**Solution**:
```powershell
# Run PowerShell as Administrator (if needed)
# Or change directory to one with write permissions
```

### Merge Conflicts
**Issue**: Conflicting changes in settings.json  
**Solution**: Choose option [M] for manual review, then decide per-file

---

## Best Practices

### Before Updating
1. ✅ Commit your current changes
2. ✅ Review what you've customized
3. ✅ Note your `assistant_name` setting
4. ✅ Close AI clients using `.claude`

### During Update
1. ✅ Read the report carefully
2. ✅ Choose conservative [C] if unsure
3. ✅ Use step-by-step [S] for first update
4. ✅ Review conflicts manually [M] if many changes

### After Update
1. ✅ Test basic functionality
2. ✅ Verify settings.json
3. ✅ Check your skills still work
4. ✅ Restart AI client if needed
5. ✅ Remove staging directory if no issues

---

## Examples

### First-Time Update
```
You: /paiupdate

AI: 🔍 Checking for PAI updates...
AI: ✅ Found upstream changes!
AI: 
AI: ╔═══════════════════════════════════════════════╗
AI: ║           PAI UPDATE AVAILABLE                ║
AI: ║  Upstream: a1b2c3d (2024-12-16)              ║
AI: ║  Your version: initial (never synced)         ║
AI: ╠═══════════════════════════════════════════════╣
AI: ║ SUMMARY                                       ║
AI: ║ • 5 new files available                       ║
AI: ║ • 0 conflicts (first sync)                    ║
AI: ╚═══════════════════════════════════════════════╝
AI: 
AI: 🆕 NEW FEATURES:
AI: • New skill: fabric-advanced
AI: • New agent: coder-v2
AI: • Updated: commands/init.md
AI: 
AI: What would you like to do?
AI: [A] Apply all safe updates (recommended)
AI: [S] Step through each change
AI: [C] Conservative mode
AI: [M] Manual review
AI: [N] Not now

You: A

AI: ✅ Creating backups...
AI: ✅ Applying 5 updates...
AI: ✅ Validating...
AI: ✅ Update complete!
AI: 
AI: 📁 Backups saved to: .claude/pai_backups/
AI: 🗑️ Remove staging directory? [Y/N]

You: Y

AI: ✅ Cleanup complete. PAI is up to date!
```

### Update with Conflicts
```
You: /pa

AI: 🔍 Checking for updates...
AI: 
AI: 🔴 REQUIRES ATTENTION:
AI: • settings.json - You changed assistant_name to "Clippy"
AI:                   Upstream added new voice settings
AI:   → Recommendation: Smart merge (preserve your name, add voice)
AI: 
AI: 🟢 SAFE TO UPDATE:
AI: • agents/researcher.md - Only upstream changed
AI: • skills/CORE/SKILL.md - Only upstream changed
AI: 
AI: What would you like to do? [A/S/C/M/N]

You: S

AI: 1/3: settings.json - Smart merge?
AI:      Your: assistant_name = "Clippy"
AI:      Upstream adds: voice.enabled, voice.server_url
AI:      Result: Both preserved
AI: Apply this merge? [Y/N]

You: Y

AI: ✅ Merged settings.json
AI: 
AI: 2/3: agents/researcher.md - Update to latest?
AI: Apply? [Y/N]

You: Y

AI: ✅ Updated agents/researcher.md
AI: 
AI: 3/3: skills/CORE/SKILL.md - Update?
AI: Apply? [Y/N]

You: Y

AI: ✅ All updates applied!
```

---

## Support

### Documentation
- `README.md` - Main documentation
- `ARCHITECTURE.md` - System architecture
- `commands/README.md` - Commands guide
- `skills/CORE/SkillSystem.md` - Skill creation

### Repository
- **GitHub**: https://github.com/differentstuff/Personal_AI_Infrastructure_PAI_for_Windows
- **Issues**: Report bugs or request features
- **Discussions**: Ask questions, share ideas

### Compatibility
- ✅ Windows 11 (primary)
- ✅ Windows 10 (with PS 7.0+)
- ✅ PowerShell 7.5+ (recommended)
- ✅ Cherry Studio
- ✅ Claude Code/Desktop
- ✅ LibreChat
- ✅ Any RAG-enabled AI client

---

**Version**: 1.0.0  
**Last Updated**: 2024-12-16 @ 12:30 CET  
**Platform**: Windows 11, PowerShell 7.5+
