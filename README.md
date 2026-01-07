# PAI - Personal AI Infrastructure for Windows

## 🎯 What is PAI?

PAI for Windows is a Windows-native port of Personal AI Infrastructure for [Daniel Miessler's PAI](https://github.com/danielmiessler/PAI).

---

## 🚀 Quick Start

### **Prerequisites**

- **Windows 11**
- **PowerShell 7.5 or higher** ([Install Guide](https://aka.ms/powershell))
- **Local directory or OneDrive** for workspace

### **Installation (3 Steps)**

**1. Verify PowerShell Version:**
```powershell
$PSVersionTable.PSVersion
# Should show 7.5.0 or higher
```
*If version < 7.5.0, install:*
```powershell
winget install Microsoft.PowerShell
# Then restart PowerShell
```

**2. Clone or download this repository:**
```powershell
git clone https://github.com/differentstuff/Personal_AI_Infrastructure_PAI_for_Windows.git
cd Personal_AI_Infrastructure_PAI_for_Windows
```

**3. Run the Windows installer:**

```cmd
# GUI
Doubleclick on: Tools\setup.bat
```

```powershell
# Powershell
.\Tools\Install-PAI.ps1
```

The installer will:
- Create safety backup of your current `.claude` folder
- Ask configuration questions (name, workspace location, timezone, etc.)
- Install PAI files to your chosen workspace (OneDrive recommended)
- Set up environment variables automatically

---

## 📁 What Gets Installed?

The PAI bundle installs to your workspace (e.g., `$env:PAI_DIR\.claude\`):

```
.claude\
├── settings.json          ← Your configuration
├── .env                   ← Environment variables (gitignored)
├── history/               ← Session logs (gitignored, auto-created)
├── agents/                ← AI agent personalities
├── skills/                ← Capability modules
├── commands/              ← Command templates
├── tools/                 ← PowerShell management scripts
├── hooks/                 ← Event hooks
├── templates/             ← File templates
└── mcp-servers/           ← MCP server configurations
```

---

## 🙏 Credits

Built on concepts from [Daniel Miessler's PAI](https://github.com/danielmiessler/PAI), reimagined for Windows environments.

**Key Differences:**
- ✅ Windows-native (PowerShell 7.5+, Windows paths)
- ✅ Single-bundle architecture (like Daniel's KAI)
- ✅ GUI-agnostic (Cherry Studio, Claude Code compatible)
- ✅ User-controlled installation location

---
