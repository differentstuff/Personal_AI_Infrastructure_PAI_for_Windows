# PAI-Core

**Windows-Native System Foundation Pack**

> Version: 2.0.0  
> Platform: Windows 11+, PowerShell 7.5+  
> Compatible with: Cherry Studio, LibreChat, Claude Desktop, Claude Code

---

## 🎯 What This Pack Provides

The **PAI-Core** pack is the foundational infrastructure for the PAI system [1]. It includes:

- **CORE Skill**: The 13 Founding Principles that guide all PAI interactions [7]
- **Configuration System**: `settings.json` and environment handling [9][10]
- **Command Templates**: Meta-prompting patterns for common operations [6]
- **Skill System Foundation**: Base structure for creating custom skills [1][7]
- **Directory Structure**: Standardized workspace layout

**Dependencies**: None (this is the base layer)

---

## 📁 Pack Contents

```
PAI-Core/
├── README.md                        ← This file
├── INSTALL.md                       ← Installation instructions
├── VERIFY.md                        ← Verification checklist
└── src/                             ← Source files
    ├── skills/
    │   └── CORE/                    ← System foundation skill
    │       ├── Constitution.md      ← 13 Founding Principles
    │       └── SkillSystem.md       ← Skill creation guide
    ├── commands/                    ← Meta-prompting templates
    │   └── init.md                  ← Initialization command
    ├── templates/                   ← Reusable patterns
    │   └── (template files)
    ├── settings.json                ← Master configuration
    └── .env.example                 ← Environment variables template
```

---

## 🚀 Quick Installation

```powershell
# Navigate to v2 repository
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2

# Run bundle installer
& ".\Bundles\PAI\Install.ps1"
```

---

## 💡 Usage After Installation

### 1. Configure Your Identity

Edit `$env:OneDrive\.claude\settings.json`:

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

### 2. Initialize Session (Start of Conversation)

Tell your AI:

```
Initialize my PAI context
```

The AI will read `commands/init.md` to gather:
- Current date, time, timezone
- Your configuration
- Available skills
- System context [6][9]

### 3. Load CORE Skill (Automatic)

The CORE skill provides the 13 Founding Principles [7]:

```
Tell me about your Constitution and how it guides your actions
```

---

## 🔧 Components Explained

### CORE Skill (`src/skills/CORE/`)

**Constitution.md**: The 13 Founding Principles [7]
- Clear Thinking + Prompting is King
- Scaffolding > Model
- As Deterministic as Possible
- Code Before Prompts
- Spec / Test / Evals First
- UNIX Philosophy
- ENG / SRE Principles
- CLI as Interface
- Goal → Code → CLI → Prompts → Agents
- Meta / Self Update System
- Custom Skill Management
- Custom History System
- Custom Agent Personalities

**SkillSystem.md**: How to create your own skills [1][7]

### Configuration (`src/settings.json`)

Master configuration that defines:
- **Paths**: Where everything is located
- **User**: Your identity and timezone
- **Defaults**: Default assistant, agent, skills to load
- **Features**: Optional capabilities (voice, etc.) [9][10]

### Commands (`src/commands/init.md`)

Initialization command that sets session context:
- Date, time, timezone [9]
- Directory structure
- Available skills
- User configuration [6]

---

## 🎨 Design Philosophy

This pack follows PAI principles [1][7]:
- ✅ **Modular**: Each component is independent and swappable
- ✅ **Windows-Native**: PowerShell 7.5+, Windows paths, Windows conventions
- ✅ **GUI-Agnostic**: Works with any AI client
- ✅ **Deterministic**: Configuration drives behavior, not randomness

---

## 🔄 Updates

To update PAI-Core pack:

```powershell
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2
& ".\Tools\Update-PAI.ps1" -PackName "PAI-Core"
```

Protected files are preserved during updates [1]:
- Customized `settings.json` changes
- User-created skills
- Command templates you've modified

---

## 🤝 Integration with Other Packs

PAI-Core is designed to work seamlessly with:

- **PAI-Agent-Assistant**: General-purpose interactions [4][10]
- **PAI-Agent-Engineer**: Technical tasks [4][10]
- **PAI-Agent-Researcher**: Deep research [4][10]
- **PAI-Fabric-Skill**: Pattern integration [3][6]
- **PAI-PowerShell-Tools**: Windows management [4][5]

All these builds **on top of** PAI-Core.

---

## 🐛 Troubleshooting

### Issue: CORE skill not loading
**Solution**: Check `settings.json` defaults.skills_always_load includes "CORE" [9][10]

### Issue: Commands not found
**Solution**: Verify `commands/` directory exists in your workspace [6]

### Issue: Configuration changes not taking effect
**Solution**: Restart your AI client session after editing `settings.json`

**For more help**, see `VERIFY.md` or run manual verification checks.

---

## 📚 Documentation

- `INSTALL.md` - Step-by-step setup guide  
- `VERIFY.md` - Installation verification checklist  
- `src/skills/CORE/` - System philosophy and principles [7]  
- `settings.json` - Configuration reference [9][10]

---

🎯 **PAI-Core is installed. Your AI now has a structural foundation!**
