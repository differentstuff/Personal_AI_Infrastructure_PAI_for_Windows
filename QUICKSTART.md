# PAI Quick Start Guide

Get up and running with Personal AI Infrastructure in 5 minutes.

## 🚀 Step 1: Initialize

```powershell
# Navigate to PAI directory
cd C:\Users\jean-\.claude

# Run initialization
./tools/Initialize-PAI.ps1
```

This creates your `.env` file and validates the setup.

## 🔑 Step 2: Configure API Keys

Edit `.env` with your API keys:

```powershell
# Open in your editor
code .env

# Or notepad
notepad .env
```

Add your keys:
```bash
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
```

**Important**: Never commit `.env` to git!

## ⚙️ Step 3: Customize Settings

Edit `settings.json`:

```powershell
code settings.json
```

Update your identity:
```json
{
  "identity": {
    "user_name": "Your Name",
    "user_email": "your@email.com",
    "assistant_name": "YourAssistant"
  }
}
```

## 🎨 Step 4: Connect Your AI Client

### Cherry Studio

1. Open Cherry Studio
2. Go to **Settings** → **Knowledge Base**
3. Add directory: `C:\Users\jean-\.claude`
4. Enable auto-load
5. Restart Cherry Studio

### Claude Desktop (if using)

Already uses `~/.claude` by default - no configuration needed!

### Cline / Other

Point to `C:\Users\jean-\.claude` in your client's configuration.

## ✅ Step 5: Verify Installation

```powershell
# Check environment
Import-Module ./tools/modules/PAI/PAI.psm1
Test-PAIEnvironment

# List skills
./tools/Get-SkillIndex.ps1
```

## 🎯 Step 6: Try It Out!

In your AI client, try:

**Use an agent:**
```
Use the engineer agent to help me debug this code
```

**Use a skill (when Fabric is installed):**
```
Extract wisdom from this article: [paste URL]
```

**Ask for help:**
```
What skills are available in PAI?
```

## 📚 Next Steps

### Install Fabric (Optional but Recommended)

```powershell
# Install fabric
pip install fabric-ai

# Or with pipx
pipx install fabric-ai

# Configure
fabric --setup
```

### Create Your First Custom Skill

```powershell
# Copy template
Copy-Item skills/template-skill skills/my-skill -Recurse

# Edit SKILL.md
code skills/my-skill/SKILL.md
```

### Explore Agents

Try different personalities:
- `assistant` - General purpose
- `engineer` - Technical depth
- `researcher` - Deep analysis

### Learn More

- `README.md` - Full documentation
- `skills/CORE/Constitution.md` - System philosophy
- `agents/README.md` - Agent system guide
- `skills/fabric/SKILL.md` - Fabric integration

## 🆘 Troubleshooting

**"PAI root directory not found"**
```powershell
# Set environment variable
$env:PAI_ROOT = "C:\Users\jean-\.claude"
```

**"Settings file not found"**
```powershell
# Re-run initialization
./tools/Initialize-PAI.ps1
```

**"Skills not loading in Cherry Studio"**
1. Verify directory is added to Knowledge Base
2. Restart Cherry Studio
3. Check that `settings.json` exists

**"Fabric patterns not working"**
```powershell
# Install fabric
pip install fabric-ai

# Verify installation
fabric --version
```

## 💡 Pro Tips

1. **Use agents** for different contexts (engineer for code, researcher for learning)
2. **Create custom skills** for your common workflows
3. **Keep PAI updated** with Daniel's latest improvements
4. **Share useful skills** with the community
5. **Customize agents** to match your personality

## 🤝 Getting Help

- Check `README.md` for detailed docs
- Review skill documentation in `skills/*/SKILL.md`
- Look at example workflows in `skills/*/workflows/`
- Test with `Test-PAIEnvironment`

---

**Ready?** Start using your Personal AI Infrastructure! 🎉
