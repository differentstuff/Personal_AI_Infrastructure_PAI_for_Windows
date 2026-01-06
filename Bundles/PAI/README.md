# PAI for Windows Bundle v2.0.0

> **FOR AI AGENTS:** You are about to install the complete PAI for Windows bundle. Run the wizard first, then install each pack in order.

---

## 🚨 CRITICAL: Full Implementation Required (For AI Agents)

> **MANDATORY: Read this section before installing ANY pack in this bundle.**

### The Problem

AI agents systematically create "simplified" versions of pack implementations. Instead of the full specification, they create abbreviated "equivalents." **This breaks the system and wastes the user's time.**

### The Rules for This Bundle

1. **EVERY PACK = FULL IMPLEMENTATION** - No shortcuts, no simplification
2. **EVERY FILE SPECIFIED = EVERY FILE CREATED** - Count them
3. **EVERY LINE OF CODE = EVERY LINE OF CODE** - Don't summarize
4. **IF YOU CAN'T DO IT FULLY, STOP AND SAY SO** - Don't create partial implementations

### Per-Pack Installation Checklist

**For EACH pack you install, confirm:**

```markdown
## Pack: [pack-name] Installation Verification

- [ ] All directories created as specified
- [ ] All files created (counted: X of Y)
- [ ] Code files contain COMPLETE implementations
- [ ] YAML/JSON files contain ALL entries
- [ ] Verification commands passed
- [ ] No "simplified" or "equivalent" versions created
```

### Full Bundle Completion Checklist

**After ALL packs are installed, confirm:**

```markdown
## PAI Bundle Installation Complete

### Pack Status
- [ ] PAI-Core - FULLY installed, verified
- [ ] PAI-Agent-Assistant - FULLY installed, verified
- [ ] PAI-Agent-Engineer - FULLY installed, verified
- [ ] PAI-Agent-Researcher - FULLY installed, verified
- [ ] PAI-PowerShell-Tools - FULLY installed, verified

### Integration Status
- [ ] $env:OneDrive\.claude directory structure correct
- [ ] settings.json contains all configurations
- [ ] Environment variables set correctly
- [ ] AI client restarted to activate changes

### Quality Confirmation
- [ ] NO simplified implementations
- [ ] NO missing files
- [ ] NO summarized configurations
- [ ] User informed of required customizations
```

**Present this completed checklist to the user. If ANY item fails, you are NOT done.**

---

## Quick Start

```powershell
# Fresh install (with backup)
bun run install.ts

# Update existing installation (preserves config)
bun run install.ts --update
```

### Fresh Install

The wizard will:
1. **Detect existing AI systems** - Scans for Claude Code, Cursor, Windsurf, Cline, Aider, Continue
2. **Show you what it found** and explain what will be backed up
3. **Ask for your confirmation** before making any changes
4. **Create a safety backup** of your existing `.claude` directory
5. **Ask configuration questions** (your name, AI name, timezone, preferences)
6. **Install to configured location** (default: `$env:OneDrive\.claude`)
7. **Configure environment variables** automatically

**Safety First:** The installer will not modify anything until you explicitly confirm. Your original files are always preserved in the backup.

### Update Mode

After pulling new changes from the repo, use `--update` to apply them without losing your configuration:

```powershell
git pull
bun run install.ts --update
```

Update mode will:
- **Skip backup** - Your files stay in place
- **Read existing config** - Uses your .env values as defaults
- **Preserve customizations** - History and personal settings untouched
- **Update infrastructure** - Only refreshes core skill files

---

## What This Bundle Provides

When fully installed, the PAI for Windows bundle gives you:

- **Modular agent system** - Pre-configured personalities (Assistant, Engineer, Researcher)
- **Extensible skills framework** - CORE skill system with modular capabilities
- **PowerShell tooling** - Windows-native automation and management scripts
- **Command templates** - Reusable workflows for common tasks
- **Session history tracking** - Automatic capture of sessions and learnings
- **GUI-agnostic design** - Works with Cherry Studio, Claude Code, LibreChat, etc.
- **Update system** - Safe updates that preserve your customizations
- **Bun runtime** - Fast TypeScript execution for cross-platform compatibility

---

## Installation Order (CRITICAL)

**After running the wizard, install these packs IN ORDER:**

| # | Pack | Purpose | Dependencies |
|---|------|---------|--------------|
| 1 | [PAI-Core](../../Packs/PAI-Core/) | Core skills + Constitution principles | None |
| 2 | [PAI-Agent-Assistant](../../Packs/PAI-Agent-Assistant/) | General-purpose assistant agent | Core |
| 3 | [PAI-Agent-Engineer](../../Packs/PAI-Agent-Engineer/) | Technical engineering agent | Core |
| 4 | [PAI-Agent-Researcher](../../Packs/PAI-Agent-Researcher/) | Research and analysis agent | Core |
| 5 | [PAI-PowerShell-Tools](../../Packs/PAI-PowerShell-Tools/) | Windows management scripts | Core |
| 6 | [PAI-Fabric-Skill](../../Packs/PAI-Fabric-Skill/) | Fabric patterns integration (optional) | Core |

### How to Install Packs

Give each pack directory to your AI and ask it to install:

```
"Install the PAI-Core pack from Packs/PAI-Core/"
```

The AI will:
1. Read the pack's `README.md` for context
2. Follow `INSTALL.md` step by step
3. Copy files from `src/` to your system (default: `$env:OneDrive\.claude`)
4. Complete `VERIFY.md` checklist to confirm success

**Note:** Each pack is a directory (v2.0 format) containing README.md, INSTALL.md, VERIFY.md, and a `src/` folder with actual Windows-compatible files.

### Why Order Matters

- **PAI-Core** is the foundation - provides CORE skill system and Constitution principles
- **Agent packs** depend on CORE for skill routing and identity framework
- **PowerShell-Tools** provides Windows-native management utilities
- **Fabric-Skill** extends functionality with pattern-based processing (optional)

---

## Prerequisites

- **Windows 11** with PowerShell 7.5+
- **[Bun](https://bun.sh)**: Install via PowerShell:
  ```powershell
  powershell -c "irm bun.sh/install.ps1 | iex"
  ```
- **Compatible AI client**: Cherry Studio, Claude Code, LibreChat, or any GUI that supports `.claude` directories

---

## Verification

After installing all packs:

```powershell
# Check directory structure
Get-ChildItem $env:OneDrive\.claude

# Expected directories:
# agents/      - Agent personality files
# skills/      - CORE and other skills
# tools/       - PowerShell utilities
# commands/    - Command templates
# history/     - Session tracking (auto-created)

# Check settings file exists
Test-Path $env:OneDrive\.claude\settings.json

# Restart your AI client to activate all changes
```

---

## Restoring from Backup

If something goes wrong:

```powershell
# Remove the new installation
Remove-Item $env:OneDrive\.claude -Recurse -Force

# Restore from backup
Move-Item $env:OneDrive\.claude-BACKUP $env:OneDrive\.claude
```

---

## What Are Packs and Bundles?

**Packs** are complete subsystems organized around a single capability. Each pack is a directory containing:
- `README.md` - Overview, architecture, what it solves
- `INSTALL.md` - Step-by-step installation instructions
- `VERIFY.md` - Mandatory verification checklist
- `src/` - Actual source code files (TypeScript, PowerShell, YAML, etc.)

**Bundles** are curated combinations of packs designed to work together. The PAI for Windows Bundle is 6 packs that form a complete AI infrastructure (5 required + 1 optional).

---

## Core Principles

The PAI for Windows system embeds these principles:

1. **Clear Thinking + Prompting is King** - Good prompts come from clear thinking
2. **Scaffolding > Model** - Architecture matters more than which model
3. **As Deterministic as Possible** - Templates and consistent patterns
4. **Code Before Prompts** - Use AI only for what actually needs intelligence
5. **Spec / Test / Evals First** - Write specifications and tests before building
6. **UNIX Philosophy** - Do one thing well, make tools composable
7. **ENG / SRE Principles** - Treat AI infrastructure like production software
8. **CLI as Interface** - Command-line is faster and more reliable
9. **Goal → Code → CLI → Prompts → Agents** - The decision hierarchy
10. **Custom Skill Management** - Modular capabilities that route intelligently
11. **Custom History System** - Everything worth knowing gets captured
12. **Custom Agent Personalities** - Different work needs different approaches
13. **Windows-Native Design** - PowerShell, Bun, Windows conventions throughout

---

## Changelog

### 2.0.0 - 2025-01-XX

- **Windows-Native Implementation:** Complete rewrite for Windows 11 + PowerShell 7.5+
- **Bun Runtime:** TypeScript execution via Bun for cross-platform compatibility
- **Directory-Based Packs:** All packs migrated to v2.0 directory structure
- **New Pack Format:** Each pack contains README.md, INSTALL.md, VERIFY.md, and src/
- **Windows Path Handling:** OneDrive integration, Windows environment variables
- **PowerShell Tooling:** Native Windows management scripts
- **Installation Wizard:** Interactive setup with backup and configuration

### 1.0.0 - Based on PAI v1

- Initial Windows adaptation from original PAI system
- PowerShell-based installation
- Cherry Studio compatibility
- GUI-agnostic design

---

## Credits

**Original PAI System:** Daniel Miessler ([danielmiessler/PAI](https://github.com/danielmiessler/PAI))  
**Windows Adaptation:** Custom Windows-native implementation for Bun + PowerShell  
**Philosophy:** Based on [Personal AI Infrastructure](https://danielmiessler.com/blog/personal-ai-infrastructure) principles

---

## Support

For issues, questions, or contributions:
- Review pack documentation in `Packs/` directory
- Check verification checklists after installation
- Ensure Bun and PowerShell 7.5+ are installed
- Verify Windows paths use `$env:OneDrive` correctly

---

*PAI for Windows v2.0 - Complete AI infrastructure for Windows 11 + Bun runtime*
