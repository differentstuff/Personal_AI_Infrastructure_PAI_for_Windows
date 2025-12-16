# Personal AI Infrastructure (PAI)

**Windows-Native AI Assistant System**

> Built for Windows 11 + PowerShell 7.5  
> GUI-agnostic (works with Cherry Studio, Cline, Claude Desktop, etc.)  
> Compatible with Daniel Miessler's PAI architecture

---

## 🎯 What is This?

A modular, portable system that structures AI interactions through:
- **Skills**: Self-contained capabilities
- **Agents**: Task-specific personalities
- **Templates**: Meta-prompting with variables
- **Hooks**: Event-driven automation (future)
- **History**: Automatic session documentation

## 🚀 Quick Start

### 1. Prerequisites

**Windows:**
```powershell
# Check PowerShell version (need 7.0+)
$PSVersionTable.PSVersion

# Install if needed
winget install Microsoft.PowerShell
```

### 2. Setup

```powershell
# Extract to your User directory or clone to ~/.claude
# Extracted: C:\Users\USERNAME\.claude
# Initialize
cd ~/.claude
./tools/Initialize-PAI.ps1

# Configure (optional - system env vars recommended)
cp .env.example .env
# Edit .env if needed (NEVER commit this!)
```

### 3. Connect to Your AI Client

**Cherry Studio:**
- Settings → Knowledge Base → Add Directory: `C:\Users\USERNAME\.claude`

**Claude Desktop:**
- Point to `C:\Users\USERNAME\.claude` in config

**Claude Code / Cline / Other:**
- Point to `C:\Users\USERNAME\.claude` in configuration

---

## 📁 Structure

```
.claude/
├── settings.json          # Your configuration
├── .env                   # API keys (gitignored)
├── README.md             # This file
│
├── skills/               # Modular capabilities
│   ├── CORE/            # System foundation (always loaded)
│   ├── fabric/          # Fabric patterns integration
│   └── template-skill/  # Template for new skills
│
├── agents/              # Personality presets
│   ├── assistant.md    # General assistant
│   ├── engineer.md     # Technical expert
│   └── researcher.md   # Deep research mode
│
├── templates/           # Meta-prompting templates
│   └── (coming soon)
│
├── hooks/              # Automation triggers (placeholder)
│   └── README.md
│
├── history/            # Session logs (gitignored)
│
└── tools/              # Management scripts
    ├── Initialize-PAI.ps1
    ├── Get-SkillIndex.ps1
    └── modules/PAI/
```

---

## 🎨 Core Philosophy: The 13 Principles

See `skills/CORE/Constitution.md` for details.

**Key Ideas:**
1. **Clear Thinking + Prompting is King** - Structure beats model size
2. **Scaffolding > Model** - System design matters more than raw power
3. **As Deterministic as Possible** - Prefer code over prompts
4. **Code Before Prompts** - Write functions, not instructions
5. **Spec / Test / Evals First** - Define success before building

---

## 🔧 Usage

### List Available Skills
```powershell
./tools/Get-SkillIndex.ps1
```

### Create New Skill
```powershell
./tools/New-Skill.ps1 -Name "MySkill" -Description "What it does"
```

### Switch Agent Personality
In your AI client:
```
Use the engineer agent for this task
```

### Use Fabric Pattern (if installed)
```
Extract wisdom from this article using fabric
```

---

## 🧩 Skills System

Skills are self-contained folders with:
- `SKILL.md` - Metadata and instructions
- `workflows/` - Step-by-step processes
- `tools/` - Scripts and utilities

**Create a skill:**
1. Copy `skills/template-skill/`
2. Rename and customize `SKILL.md`
3. Add your workflows and tools
4. AI automatically discovers it!

---

## 🤖 Agents

Agents are personality presets for different tasks:

- **assistant** - General purpose, balanced
- **engineer** - Technical depth, code-focused
- **researcher** - Deep analysis, citations

Switch by saying: *"Use the researcher agent"*

---

## 🔗 Fabric Integration

This system integrates Daniel Miessler's [Fabric](https://github.com/danielmiessler/fabric) patterns.

**Setup:**
```powershell
# Install fabric
pip install fabric-ai

# Configure in settings.json
"integrations": {
  "fabric": {
    "enabled": true
  }
}
```

**Use patterns:**
```
Extract wisdom from [content]
Summarize this meeting
Create action items
```

---

## 🔄 Updates & Compatibility

This system is **compatible with Daniel Miessler's PAI** architecture, so you can:
- Pull updates from his repository
- Share skills with the community
- Contribute improvements back

**Stay updated:**
```powershell
./tools/Update-PAI.ps1
```

---

## 🛠️ Windows-Specific Notes

**Environment Variables:**
- Uses `%PAI_ROOT%` for Windows compatibility
- Detects Windows paths automatically
- PowerShell 7.5+ recommended

**Path Format:**
- All scripts use Windows path format (C:\Path\To)
- Config files use forward slashes for compatibility
- TEMP directory is Windows Temp by default

---

## 📚 Learn More

- `skills/CORE/Constitution.md` - System philosophy
- `skills/CORE/SkillSystem.md` - How to create skills
- `agents/README.md` - Agent system guide
- `hooks/README.md` - Automation system

---

## 🤝 Contributing

This is your personal infrastructure, but feel free to:
1. Fork and customize
2. Share your skills
3. Submit improvements
4. Stay compatible with PAI standards

---

## 📄 License

MIT - Do whatever you want with it!

---

