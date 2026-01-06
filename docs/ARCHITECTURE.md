# PAI v2 Architecture - Windows Edition

**Version:** 2.0.0  
**Last Updated:** 2026-01-06
**Platform:** Windows 11 + PowerShell 7.5+

---

## 🎯 Design Philosophy

PAI v2 for Windows is built on four core principles:

1. **Windows-Native First** - PowerShell 7.5+, Windows paths, Windows conventions
2. **Single-Bundle Simplicity** - One cohesive bundle (not fragmented packs)
3. **GUI-Agnostic** - Works with any AI client (Cherry Studio, Claude Code, etc.)
4. **User Control** - Safe installation with protected customizations

---

## 🔄 Evolution from V1 to V2

### **Why V2 Exists**

PAI v1 attempted a **monolithic "clone-and-use" approach**:
- ❌ Users cloned `.claude` folder directly to their workspace
- ❌ Updates required manual git operations in workspace
- ❌ Risk of overwriting user customizations
- ❌ No separation between "source repository" and "installed system"

PAI v2 introduces a **bundle-based installation model**:
- ✅ **Repository** = Source of truth (what you maintain)
- ✅ **Bundle** = Installable package (`Bundles/PAI/`)
- ✅ **Workspace** = User's `.claude` folder (where bundle installs)
- ✅ **Installation Tools** = Safe deployment and updates

### **Architectural Shift**

```
┌─────────────────────────────────────────────────────────────┐
│                         V1 APPROACH                         │
│  User Workspace = Repository (directly cloned)             │
│                                                             │
│  Problem: Updates overwrite customizations                 │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                         V2 APPROACH                         │
│                                                             │
│  ┌─────────────────┐                                       │
│  │   Repository    │  (Source - GitHub/Local)              │
│  │   Bundles/PAI/  │                                       │
│  └────────┬────────┘                                       │
│           │                                                 │
│           │ Install-PAI.ps1                                │
│           │ (Safe Deployment)                              │
│           ↓                                                 │
│  ┌─────────────────┐                                       │
│  │ User Workspace  │  ($env:OneDrive\.claude)              │
│  │ .claude/        │                                       │
│  └─────────────────┘                                       │
│                                                             │
│  Benefits: Protected customizations, safe updates          │
└─────────────────────────────────────────────────────────────┘
```

---

## 📦 Repository Structure

```
PAI_Windows_v2/                    ← Source Repository
│
├── README.md                      ← Installation guide
├── ARCHITECTURE.md                ← This file
├── LICENSE                        ← MIT license
├── .gitignore                     ← Git exclusions
│
├── Bundles/                       ← Installable Bundles
│   └── PAI/                       ← THE single bundle
│       ├── agents/                ← Agent personalities
│       ├── skills/                ← Capability modules
│       ├── commands/              ← Command templates
│       ├── tools/                 ← PowerShell modules
│       ├── hooks/                 ← Event hooks
│       ├── templates/             ← File templates
│       ├── mcp-servers/           ← MCP configurations
│       ├── settings.json          ← Default configuration
│       ├── .env.example           ← Environment template
│       └── README.md              ← Bundle documentation
│
├── Tools/                         ← Installation Utilities
│   ├── Install-PAI.ps1            ← Main installer
│   ├── Update-PAI.ps1             ← Update mechanism
│   └── Uninstall-PAI.ps1          ← Removal tool
│
└── docs/                          ← Extended Documentation
    ├── QUICKSTART.md              ← Setup guide
    ├── ARCHITECTURE.md            ← Design details
    └── IMPLEMENTATION.md          ← Technical notes
```

**Key Exclusions (Not in Repository):**
- ❌ `history/` - User-specific session logs (created at runtime)
- ❌ `.env` - User's environment variables (created from `.env.example`)
- ❌ User customizations (preserved during updates)

---

## 🏗️ Installation Architecture

### **Installation Flow**

```
┌──────────────────────────────────────────────────────────────┐
│ 1. USER CLONES REPOSITORY                                   │
│    git clone <repo> PAI_Windows_v2                          │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ↓
┌──────────────────────────────────────────────────────────────┐
│ 2. RUN INSTALLER                                            │
│    .\Tools\Install-PAI.ps1                                  │
│                                                             │
│    • Prompts for workspace location                        │
│    • Validates PowerShell version (7.5+)                   │
│    • Creates .claude/ structure                            │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ↓
┌──────────────────────────────────────────────────────────────┐
│ 3. DEPLOY BUNDLE                                            │
│    Copy Bundles/PAI/* → $WorkspaceLocation\.claude\        │
│                                                             │
│    • Copy agents, skills, commands, tools                  │
│    • Copy settings.json (if not exists)                    │
│    • Create .env from .env.example                         │
│    • Create history/ directory (empty)                     │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ↓
┌──────────────────────────────────────────────────────────────┐
│ 4. USER CONFIGURATION                                       │
│    Edit $WorkspaceLocation\.claude\settings.json           │
│    Edit $WorkspaceLocation\.claude\.env                    │
└──────────────────────────────────────────────────────────────┘
```

### **Workspace Structure (After Installation)**

```
$env:OneDrive\.claude/                  ← User's Workspace
│
├── settings.json                       ← User configuration
├── .env                                ← Environment vars (gitignored)
│
├── history/                            ← Session logs (gitignored)
│   └── 2024-12/                        ← Monthly organization
│
├── agents/                             ← From PAI bundle
│   ├── assistant.md
│   ├── engineer.md
│   ├── researcher.md
│   └── architect.md
│
├── skills/                             ← From PAI bundle
│   ├── CORE/                           ← Constitution, SkillSystem
│   ├── fabric/                         ← Fabric patterns
│   ├── research/                       ← Research capabilities
│   └── security/                       ← Security tools
│
├── commands/                           ← From PAI bundle
│   ├── init.md
│   ├── paiupdate.md
│   └── QUICKREF.md
│
├── tools/                              ← From PAI bundle
│   └── modules/PAI/
│       └── PAI.psm1                    ← Core PowerShell module
│
├── hooks/                              ← From PAI bundle
├── templates/                          ← From PAI bundle
└── mcp-servers/                        ← From PAI bundle
```

---

## 🔄 Update Mechanism

### **Protected Customizations**

The update system preserves user modifications[1][4][8]:

**ALWAYS PRESERVED:**
- ✅ `settings.json` - User's `assistant_name` and custom settings[8]
- ✅ Custom skills not in upstream[1]
- ✅ Custom agents not in upstream[1]
- ✅ Custom commands not in upstream[1]
- ✅ `.env` file (never overwritten)[5]
- ✅ `history/` directory (never touched)[1][5]

**SAFE TO UPDATE:**
- ✅ Upstream-only changes (no local modifications)
- ✅ New files from upstream[4]
- ✅ Core system files (with backup)[10]

**CONFLICT HANDLING:**
- ⚠️ Smart merge for `settings.json` (preserve user values, add new keys)[8]
- ⚠️ User decision required for conflicting files[4][8]
- ⚠️ Automatic backups before any changes[8][10]

### **Update Workflow**

```
┌──────────────────────────────────────────────────────────────┐
│ 1. CHECK FOR UPDATES                                        │
│    .\Tools\Update-PAI.ps1                                   │
│    • Fetch latest from repository                          │
│    • Compare with installed version                        │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ↓
┌──────────────────────────────────────────────────────────────┐
│ 2. ANALYZE CHANGES                                          │
│    • Detect conflicts (user vs upstream)[10]               │
│    • Identify safe updates[4]                              │
│    • Generate recommendations[8]                           │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ↓
┌──────────────────────────────────────────────────────────────┐
│ 3. USER DECISION[4][8]                                      │
│    • A - Auto (apply all safe updates)                     │
│    • S - Step (review each change)                         │
│    • C - Conservative (only critical fixes)                │
│    • M - Manual (user handles)                             │
│    • N - Not now                                           │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ↓
┌──────────────────────────────────────────────────────────────┐
│ 4. BACKUP & APPLY[8][10]                                    │
│    • Create backups in .claude/pai_backups/[8]             │
│    • Apply approved changes                                │
│    • Smart merge settings.json[8]                          │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ↓
┌──────────────────────────────────────────────────────────────┐
│ 5. VALIDATE & CLEANUP[1][10]                                │
│    • Verify file integrity                                 │
│    • Update sync history[1]                                │
│    • Optional cleanup of staging[1]                        │
└──────────────────────────────────────────────────────────────┘
```

---

## 🪟 Windows-Specific Design Decisions

### **PowerShell 7.5+ Requirement**

**Why not Windows PowerShell 5.1?**
- ❌ 5.1 lacks modern cmdlets and features
- ✅ 7.5+ is cross-platform PowerShell (but we target Windows)
- ✅ 7.5+ has better performance and security
- ✅ 7.5+ is the future of PowerShell

**Enforcement:**
```powershell
#Requires -Version 7.5
```

### **Path Conventions**

**Always use Windows-native paths:**
```powershell
# ✅ CORRECT
$WorkspacePath = "$env:OneDrive\.claude"
$SkillPath = Join-Path $WorkspacePath "skills\CORE"

# ❌ WRONG (Mac/Linux style)
$WorkspacePath = "~/.claude"
$SkillPath = "$WorkspacePath/skills/CORE"
```

**Environment Variables:**
- ✅ `$env:OneDrive` - OneDrive root
- ✅ `$env:USERPROFILE` - User's home directory
- ✅ `$env:TEMP` - Temporary files
- ❌ `~` - Avoid Unix-style home shorthand

### **Execution Policy**

All scripts assume `RemoteSigned` or `Unrestricted`:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### **No Mac/Linux Dependencies**

**Explicitly excluded:**
- ❌ Bash scripts (`.sh` files)
- ❌ `bun`, `node` runtime requirements
- ❌ Unix utilities (`chmod`, `chown`, `grep`)
- ❌ Unix paths (`/usr/local/`, `~/`)

**Windows equivalents:**
- ✅ PowerShell scripts (`.ps1`)
- ✅ Native PowerShell cmdlets
- ✅ Windows paths (`C:\`, `$env:ProgramData`)

---

## 🎨 GUI-Agnostic Design

PAI v2 works with **any AI client** that supports custom instructions:

- ✅ **Cherry Studio** - Full support
- ✅ **Claude Code** - Full support
- ✅ **Custom LLM interfaces** - Compatible

**How it works:**
1. User's AI client loads agents from `$workspace\.claude\agents\`
2. Agent files reference skills in `$workspace\.claude\skills\`
3. No client-specific code or configurations

---

## 🔐 Security Model

### **Secrets Management**

```
.env (NEVER in repository)
├── API keys (Anthropic, OpenAI, etc.)
├── Custom paths
└── User-specific configuration

.env.example (IN repository)
├── Template structure
├── Example values
└── Documentation comments
```

**Best Practices:**
- ✅ Store API keys in `.env` (gitignored)[5]
- ✅ Use system environment variables when possible
- ✅ Never commit `.env` to git[5]
- ✅ Keep backups encrypted and separate

### **User Data Protection**

**Never in repository:**
- ❌ `history/` - Session logs[3][5]
- ❌ `.env` - User secrets[5]
- ❌ Personal customizations
- ❌ API keys or credentials

**Always gitignored:**[3][5]
```gitignore
.env
history/
*.jsonl
pai_backups/
pai_updates/
```

---

## 🚀 Extension Model

### **Adding Custom Skills**

1. Create skill directory: `$workspace\.claude\skills\MySkill\`
2. Add skill files (Markdown format)
3. Reference in `settings.json` (optional)
4. Skill is automatically protected during updates[1]

### **Adding Custom Agents**

1. Create agent file: `$workspace\.claude\agents\my-agent.md`
2. Follow agent template structure
3. Agent is automatically protected during updates[1]

### **Adding Custom Commands**

1. Create command file: `$workspace\.claude\commands\mycommand.md`
2. Use command template format
3. Command is automatically protected during updates[1]

---

## 📊 Comparison: Daniel's KAI vs. PAI Windows

| Aspect | Daniel's KAI (Mac) | PAI Windows |
|--------|-------------------|-------------|
| **Platform** | macOS | Windows 11 |
| **Shell** | Bash/Zsh | PowerShell 7.5+ |
| **Bundle** | KAI | PAI |
| **Installation** | `bun run install.ts` | `.\Tools\Install-PAI.ps1` |
| **Paths** | Unix (`~/`, `/usr/`) | Windows (`$env:`, `C:\`) |
| **Philosophy** | Mac-native | Windows-native |
| **Architecture** | Single bundle | Single bundle (same) |

**Shared Concepts:**
- ✅ Bundle-based installation (not monolithic)
- ✅ Protected user customizations
- ✅ Safe update mechanism
- ✅ GUI-agnostic design

**Key Differences:**
- ✅ PAI is Windows-first (no Mac/Linux code)
- ✅ PAI uses PowerShell (no Bash/Node/Bun)
- ✅ PAI targets different workspace paths

---

## 🎯 Success Criteria

**V2 Architecture Achieves:**
- ✅ Clean separation: Repository ≠ Workspace
- ✅ Safe updates without overwriting customizations[1][4][8]
- ✅ Windows-native tooling throughout
- ✅ Single-bundle simplicity (like Daniel's KAI)
- ✅ GUI-agnostic compatibility
- ✅ User control over installation location
- ✅ No Mac/Linux dependencies

**Future Enhancements:**
- 🔮 PowerShell Gallery publishing
- 🔮 GUI installer (Windows Forms)
- 🔮 Automated testing suite
- 🔮 Enhanced MCP integration
- 🔮 Cloud sync capabilities

---

**This architecture ensures PAI v2 is a true Windows-native AI infrastructure system, learning from v1's limitations while adopting Daniel's successful bundle-based approach.** 🎯
