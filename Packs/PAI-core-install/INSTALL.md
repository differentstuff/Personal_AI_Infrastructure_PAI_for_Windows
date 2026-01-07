# PAI-Core Installation Guide

**Step-by-step installation of the PAI system foundation**

---

## 📋 Prerequisites

### Required:
- ✅ **Windows 11 or Windows 10** with PowerShell 7.0+ (7.5+ recommended) [6][9]
- ✅ **AI Client**: Cherry Studio, LibreChat, Claude Desktop, or Claude Code
- ✅ **Workspace Location**: `$env:OneDrive\.claude` (or custom location)

### Optional but Recommended:
- Git for PAI updates
- Python 3.x for advanced features (Fabric integration)

---

## 🚀 Installation Methods

### Method 1: Install via Bundle (Recommended)

The PAI Bundle includes PAI-Core plus all other packs:

```powershell
# Navigate to v2 repository
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2

# Install complete bundle
& ".\Bundles\PAI\Install.ps1"
```

This installs all packs in the correct order.

---

### Method 2: Install Individual Pack

If you want only the core foundation:

```powershell
# Navigate to v2 repository
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2

# Check workspace location
$WorkspacePath = "$env:OneDrive\.claude"

# Create workspace directory if it doesn't exist
if (-not (Test-Path $WorkspacePath)) {
    New-Item -ItemType Directory -Path $WorkspacePath -Force
    Write-Host "Created workspace: $WorkspacePath" -ForegroundColor Green
}

# Copy PAI-Core source files to workspace
$SourcePath = "Packs\PAI-Core\src"

# Copy skills
Copy-Item (Join-Path $SourcePath "skills\*") -Destination (Join-Path $WorkspacePath "skills\") -Recurse -Force

# Copy commands
Copy-Item (Join-Path $SourcePath "commands\*") -Destination (Join-Path $WorkspacePath "commands\") -Recurse -Force

# Copy templates
if (Test-Path (Join-Path $SourcePath "templates")) {
    Copy-Item (Join-Path $SourcePath "templates\*") -Destination (Join-Path $WorkspacePath "templates\") -Recurse -Force
}

# Copy configuration
Copy-Item (Join-Path $SourcePath "settings.json") -Destination $WorkspacePath -Force

# Copy .env.example
Copy-Item (Join-Path $SourcePath ".env.example") -Destination $WorkspacePath -Force

# Create empty .env if it doesn't exist
if (-not (Test-Path (Join-Path $WorkspacePath ".env"))) {
    Copy-Item (Join-Path $SourcePath ".env.example") (Join-Path $WorkspacePath ".env") -Force
}

# Create required directories
$Directories = @(
    "history",
    "hooks",
    "mcp-servers"
)

foreach ($Dir in $Directories) {
    $DirPath = Join-Path $WorkspacePath $Dir
    if (-not (Test-Path $DirPath)) {
        New-Item -ItemType Directory -Path $DirPath -Force | Out-Null
    }
}

Write-Host "✅ PAI-Core installed successfully to: $WorkspacePath" -ForegroundColor Green
Write-Host "📋 Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Edit $WorkspacePath\settings.json with your name and timezone" -ForegroundColor White
Write-Host "   2. Review .env file (optional - API keys recommended as system env vars)" -ForegroundColor White
Write-Host "   3. Configure your AI client to point to $WorkspacePath" -ForegroundColor White
```

---

## 🔧 Post-Installation Configuration

### 1. Update settings.json

Edit `$env:OneDrive\.claude\settings.json`:

```json
{
  "_version": "2.0.0",
  
  "paths": {
    "pai_dir": "${PAI_DIR}",
    "skills_dir": "${PAI_DIR}\\skills",
    "agents_dir": "${PAI_DIR}\\agents",
    "commands_dir": "${PAI_DIR}\\commands",
    "history_dir": "${PAI_DIR}\\history",
    "tools_dir": "${PAI_DIR}\\tools"
  },
  
  "user": {
    "name": "YOUR NAME HERE",
    "timezone": "Europe/Zurich"
  },
  
  "defaults": {
    "assistant_name": "Clippy",
    "agent": "assistant",
    "skills_always_load": ["CORE"]
  },
  
  "features": {
    "voice": {
      "enabled": false
    }
  }
}
```

### 2. Configure Environment Variables (Optional)

**For Claude Code compatibility**, you can use `.env`:

```powershell
# Copy template
$Workspace = "$env:OneDrive\.claude"
Copy-Item "$Workspace\.env.example" "$Workspace\.env" -Force
```

**Recommended**: Set API keys as system environment variables instead:

```powershell
# Set system environment variables (PowerShell 7+)
[System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY', 'your-key-here', 'User')
[System.Environment]::SetEnvironmentVariable('ANTHROPIC_API_KEY', 'your-key-here', 'User')
```

### 3. Connect Your AI Client

**Cherry Studio:**
- Settings → Knowledge Base → Add Directory
- Browse to `$env:OneDrive\.claude`

**Claude Desktop:**
- Edit configuration file
- Set knowledge base path to `$env:OneDrive\.claude`

**Claude Code / Cline:**
- Add `.claude` to your project
- Configure custom instructions to reference the directory

---

## ✅ Verification

After installation, verify PAI-Core is working:

### Automated Verification

```powershell
# Navigate to pack directory and run verification manually
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2\Packs\PAI-core-install
# Then ask your AI: "Verify my PAI-Core installation"
```

### Manual Verification in Your AI Client

Ask your AI:

```
Verify my PAI-Core installation:
1. List available skills
2. Read the Constitution principles
3. Check if settings.json is configured correctly
4. Verify directory structure is complete
```

Expected output:
- ✅ Lists "CORE" skill
- ✅ Displays the 13 Founding Principles [7]
- ✅ Shows your user name and timezone from settings
- ✅ Confirms all directories exist (skills/, commands/, history/, etc.)

---

## 🔄 Updating PAI-Core

To update to a newer version:

```powershell
# Navigate to v2 repository
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2

# Pull latest changes
git pull

# Update pack (preserves your customizations)
& ".\Tools\Update-PAI.ps1" -PackName "PAI-Core"
```

**Protected during updates:**
- Your customized `settings.json` values
- User-created skills in `skills/`
- Modified command templates
- `.env` file (never overwritten)

---

## 🗑️ Uninstallation

To remove PAI-Core from your workspace:

```powershell
# Backup important data first
Backup-PAIWorkspace.ps1  # If available

# Remove files (careful - this deletes your customizations too!)
Remove-Item $env:OneDrive\.claude\skills\CORE -Recurse -Force
Remove-Item $env:OneDrive\.claude\commands -Recurse -Force
Remove-Item $env:OneDrive\.claude\templates -Recurse -Force
Remove-Item $env:OneDrive\.claude\settings.json -Force
Remove-Item $env:OneDrive\.claude\.env -Force
```

⚠️ **Warning**: This removes PAI-Core components. If other packs depend on it, they will break.

---

## 🐛 Troubleshooting

### Issue: PowerShell version too old

**Error**: "PowerShell 7.0+ required"

**Solution**:
```powershell
# Check current version
$PSVersionTable.PSVersion

# Install PowerShell 7.5 (Direct download - recommended)
# Download from: https://github.com/PowerShell/PowerShell/releases
# Or use Microsoft Store: "PowerShell 7"
```

### Issue: Copy command fails

**Error**: "Access denied" or "Path not found"

**Solution**:
```powershell
# Run PowerShell as Administrator if needed
# Or check workspace path has write permissions
$WorkspacePath = "$env:OneDrive\.claude"
Test-Path $WorkspacePath

# Create directory if missing
New-Item -ItemType Directory -Path $WorkspacePath -Force
```

### Issue: Settings.json not found after restart

**Solution**:
```powershell
# Verify file exists
Test-Path $env:OneDrive\.claude\settings.json

# Check content
Get-Content $env:OneDrive\.claude\settings.json
```

### Issue: Skills not loading

**Symptom**: AI says "No CORE skill found"

**Check**:
```powershell
# Verify CORE skill directory exists
Test-Path $env:OneDrive\.claude\skills\CORE\Constitution.md
Test-Path $env:OneDrive\.claude\settings.json

# Check settings.json includes CORE
Get-Content $env:OneDrive\.claude\settings.json | Select-String "CORE"
```

**For more help**: See `VERIFY.md` or run manual verification commands from that file

---

## 📚 Next Steps

After installing PAI-Core:

1. ✅ **Install additional packs**:
   - `PAI-Agent-Assistant` - General purpose [4][10]
   - `PAI-Agent-Engineer` - Technical tasks [4][10]
   - `PAI-Agent-Researcher` - Deep research [4][10]

2. ✅ **Initialize your AI client**:
   - Test: "Initialize my PAI context" [6]
   - Test: "What skills are available?"
   - Test: "Tell me about your Constitution"

3. ✅ **Customize your setup**:
   - Edit `settings.json` with your preferences [9][10]
   - Create custom skills (copy `template-skill`)
   - Add your own command templates

---

🎯 **PAI-Core is the foundation. Build on it with other packs!**
