# PAI - Personal AI Infrastructure for Windows

**Version:** 2.0.0  
**Platform:** Windows 11 + PowerShell 7.5+  
**Architecture:** Single-bundle modular installation system

---

## 🎯 What is PAI?

PAI is a **Windows-native Personal AI Infrastructure** that provides:

- ✅ **Modular agent system** (Assistant, Engineer, Researcher, Architect)
- ✅ **Extensible skills framework** (CORE, Fabric, Research, Security)
- ✅ **Command templates** for common workflows
- ✅ **PowerShell tooling** for Windows automation
- ✅ **GUI-agnostic design** (works with Cherry Studio, Claude Code, etc.)


---

## 🚀 Quick Start

### **Prerequisites**

- **Windows 11**
- **PowerShell 7.5 or higher** ([Install Guide](https://aka.ms/powershell))
- **Administrator privileges** (for first-time setup)
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
cd C:\Temp
git clone <your-repo-url> PAI_Windows_v2
```
*Alternative: Download ZIP and extract to `C:\Temp\PAI_Windows_v2`*

**3. Run the Windows installer:**
```powershell
cd PAI_Windows_v2\Tools
.\Initialize-PAI.ps1
```

The installer will:
- ✅ Validate PowerShell version and administrator privileges  
- ✅ Detect existing AI system installations
- ✅ Create safety backup of your current `.claude` folder
- ✅ Ask configuration questions (name, workspace location, timezone, etc.)
- ✅ Install PAI files to your chosen workspace (OneDrive recommended)
- ✅ Set up environment variables automatically
- ✅ Configure Windows security policies for PowerShell scripts
- ✅ Create desktop shortcuts and Start Menu entries

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

## 🔧 Management Commands

### **Update PAI**
```powershell
cd $env:PAI_DIR\.claude\tools
.\Update-PAI.ps1
```
Safely updates your installation while preserving customizations.

### **Initialize/Reset PAI**
```powershell
cd $env:PAI_DIR\.claude\tools
.\Initialize-PAI.ps1
```
Re-initializes your PAI configuration while preserving data.

### **Get Available Skills**
```powershell
cd $env:PAI_DIR\.claude\tools
.\Get-SkillIndex.ps1
```
Lists all installed skills with descriptions.

---

## 📖 Documentation

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Design philosophy and v2 approach
- **[docs/QUICKSTART.md](docs/QUICKSTART.md)** - Detailed setup guide
- **[Bundles/PAI/README.md](Bundles/PAI/README.md)** - Bundle-specific documentation

---

## 🎨 Customization

### **Change Assistant Name**
Edit `settings.json`:
```json
{
  "assistant_name": "YourNameHere"
}
```

### **Add Custom Skills**
Place your skill in `$env:PAI_DIR\.claude\skills\YourSkill\` and reference it in settings.

### **Configure API Keys**
Edit `.env` file (never commit this file):
```
ANTHROPIC_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here
```

---

## 🔐 Security Notes

**NEVER commit these files:**
- ❌ `.env` (contains API keys/paths)
- ❌ `history/` (personal session data)
- ❌ Any files with secrets

**Best Practices:**
- ✅ Use environment variables for API keys
- ✅ Keep `.env` local-only
- ✅ Store encrypted backups separately

---

## 🛠️ Troubleshooting

### **PowerShell Version Too Old**
Install PowerShell 7.5+:
```powershell
winget install Microsoft.PowerShell
```

### **Execution Policy Error**
Allow script execution (run as Administrator):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### **Windows Security Warnings**
If Windows Defender blocks scripts, you may need to:
1. Right-click the PowerShell script → Properties → Unblock
2. Or run PowerShell as Administrator and use:
```powershell
Set-MpPreference -DisableRealtimeMonitoring $false
# Then add exclusion for your PAI directory
Add-MpPreference -ExclusionPath "$env:PAI_DIR\.claude"
```

### **Module Not Found**
Import PAI module manually:
```powershell
Import-Module $env:PAI_DIR\.claude\tools\modules\PAI\PAI.psm1
```

---

## 📜 License

MIT License - See [LICENSE](LICENSE) for details

---

## 🙏 Credits

Built on concepts from [Daniel Miessler's PAI](https://github.com/danielmiessler/PAI), reimagined for Windows environments.

**Key Differences:**
- ✅ Windows-native (PowerShell 7.5+, Windows paths)
- ✅ Single-bundle architecture (like Daniel's KAI)
- ✅ GUI-agnostic (Cherry Studio, Claude Code compatible)
- ✅ User-controlled installation location

---

**Ready to get started? Run `.\Tools\Initialize-PAI.ps1` and follow the prompts!** 🚀
