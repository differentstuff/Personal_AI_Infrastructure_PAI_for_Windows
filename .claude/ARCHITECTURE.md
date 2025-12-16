# PAI Architecture - Windows Edition

## Design Philosophy

**Goal**: User-agnostic, GUI-agnostic PAI infrastructure that works with any AI interface (Cherry Studio, LibreChat, Claude Code, custom tools).

**Principles**:
- ✅ **80/20 Efficiency** - Keep only what scripts actually use
- ✅ **Flexibility** - Deploy anywhere, configure via environment variables
- ✅ **Modularity** - Agents, skills, commands are independent
- ✅ **Windows-Native** - PowerShell 7.5, backslash paths, Windows conventions
- ✅ **Future-Proof** - MCP-ready, hook system placeholder, extensible

---

## Directory Structure

```
.claude/
│
├── settings.json                      ← Minimal, GUI-agnostic config
├── settings.claudecode.example.json   ← Claude Code specific (hooks, permissions)
├── .env.example                       ← Optional (Claude Code compatibility)
│
├── agents/                            ← Flat single-file agents (Daniel's approach)
│   ├── assistant.md                   ← Default agent (optional frontmatter)
│   ├── researcher.md                  ← Specialized agent
│   └── coder.md                       ← Specialized agent
│
├── skills/                            ← Reusable capabilities
│   ├── CORE/                          ← Always loaded
│   └── [others]/
│
├── commands/                          ← PowerShell templates
│   ├── init.md                        ← Initialize context
│   └── [others].md
│
├── tools/                             ← Automation scripts
│   ├── Set-PAIRoot.ps1                ← Environment setup
│   └── Initialize-PAI.ps1             ← Context gathering
│
├── history/                           ← Session logs (future)
├── hooks/                             ← Future automation (Claude Code)
└── templates/                         ← Reusable patterns
```

---

## Information Flow

### 1. Installation & Setup

```
User clones/downloads .claude folder
    ↓
User runs: .\tools\Set-PAIRoot.ps1
    ↓
$env:PAI_ROOT is set (PowerShell environment)
    ↓
settings.json paths resolve correctly
```

### 2. GUI Integration

```
User adds .claude to GUI (Cherry Studio Knowledge Base)
    ↓
User sets Custom Instructions (CI):
    "Reference .claude directory structure"
    ↓
AI can read files via Knowledge Base
```

### 3. Session Initialization

```
User runs: .\tools\Initialize-PAI.ps1
    ↓
Script reads settings.json + agent config
    ↓
Outputs formatted context (date, time, timezone, agent personality)
    ↓
User copies output to AI chat
    ↓
AI has current context
```

### 4. Task Execution

```
User: "Help me with X"
    ↓
AI: Checks task type
    ↓
AI: Selects appropriate agent (default: assistant)
    ↓
AI: References /skills for capabilities
    ↓
AI: Provides PowerShell commands from /commands
    ↓
User: Executes commands manually
    ↓
User: Reports results
    ↓
AI: Continues with task
```

---

## Configuration Layers

### Layer 1: Core Paths (settings.json)

**What it contains:**
- PAI root directory
- Subdirectory paths (skills, agents, commands)
- User basics (name, timezone)
- System defaults (assistant name, default agent, always-load skills)

**What it DOESN'T contain:**
- Personality details (→ agent configs)
- Secrets (→ .env file)
- GUI preferences (→ GUI settings)

**Why minimal?**
- Scripts actually parse and use these values
- Easy to maintain
- Inspired by Anthropic's original design

### Layer 2: Agent Personality

**Structure**: Flat single-file Markdown (Daniel's approach)

**Example**: `agents/assistant.md`

**Frontmatter for metadata and control**:
```markdown
---
name: assistant
description: General-purpose AI assistant
# model: sonnet  # Commented out - GUI chooses model
# voiceId: Ava (Premium)  # Commented out - enable if using voice
color: blue
permissions:  # May be GUI-specific
  allow:
    - "Bash"
    - "Read(*)"
    - "Write(*)"
---

# Assistant Agent
Description and behavior...
```

**What it contains:**
- Agent description and behavior
- Metadata: name, description, color
- Optional: voiceId (commented out by default)
- Permissions (GUI-specific, may not apply to all clients)

**Key Design Decisions:**
- `model` is commented out - GUI selects model dynamically
- `voiceId` is commented out - enable only if using voice features
- `permissions` may be specific to certain GUIs (e.g., Claude Code)

**Why flat files?**
- Simple, readable, single source of truth
- Same approach as Daniel's PAI
- Easy to add/edit agents
- AI reads markdown directly

### Layer 2.5: Voice Notification System (Optional)

**Feature Flag**: `settings.json → features.voice.enabled`

**Purpose**: Allow agents to announce task completion audibly

**Configuration**:
```json
"features": {
  "voice": {
    "enabled": false,
    "server_url": "http://localhost:8888/notify",
    "default_rate": 260
  }
}
```

**Requirements**:
- Separate voice notification server (custom, not included with PAI)
- Server must accept POST requests with JSON payload
- Agents check `enabled` flag before making curl requests

**Agent Implementation**:
Agents include conditional voice notification code:
```bash
# Only executes if voice is enabled in settings.json
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"Task completed","rate":260,"voice_enabled":true}'
```

**Status**: Disabled by default, optional feature

### Layer 3: Secrets (.env)

**Status**: Optional (Claude Code compatibility)

**Best practice**: Use system environment variables, not local `.env`

**If using Claude Code**:
```env
PAI_ROOT=C:\Users\username\.claude
FABRIC_PATTERNS_DIR=${PAI_ROOT}\fabric\patterns
TEMP_DIR=C:\Temp
DA=PAI
CLAUDE_CODE_MAX_OUTPUT_TOKENS=64000
```

**Why minimal?**
- API keys managed by GUI applications (Cherry Studio, LibreChat)
- System environment variables are more secure
- Only needed if using Claude Code or custom scripts

### Layer 4: GUI Settings (App-Specific)

**Approach**: Copy `.example` files to app-specific locations

**Examples**:
- `settings.claudecode.example.json` → Copy to Claude Code config
- `settings.cherrystudio.example.json` → Copy to Cherry Studio config

**What it contains:**
- App-specific features (hooks, permissions, statusLine)
- Interface preferences
- Model selection
- Custom Instructions reference to .claude

**Why separate?**
- GUI-specific features (hooks are Claude Code only)
- User may switch GUIs
- Core PAI structure remains GUI-agnostic

---

## Agent System

### Structure: Flat Single-File Markdown

**Inspired by Daniel's PAI** - one `.md` file per agent in `/agents` directory.

### Default Agent: `assistant`

**File**: `/agents/assistant.md`

**Personality**: INTP, logical, efficiency-focused

**Use for**:
- General tasks
- Automation
- Configuration
- Quick questions

### Specialized Agent: `researcher`

**File**: `/agents/researcher.md`

**Personality**: Methodical, thorough, evidence-based

**Use for**:
- Deep analysis
- Fact-checking
- Documentation review
- Research tasks

### Specialized Agent: `coder`

**File**: `/agents/coder.md`

**Personality**: Precise, technical, production-focused

**Use for**:
- Code generation
- Module development
- Complex scripts
- Architecture design

### Agent Selection Logic

**Explicit (User chooses)**:
```
"Use researcher agent: Analyze security implications of X"
```

**Implicit (AI chooses)**:
- Task involves research/analysis → `researcher`
- Task involves code generation → `coder`
- Task is general/unclear → `assistant` (default)

**Configuration (settings.json)**:
```json
"defaults": {
    "agent": "assistant"
}
```

---

## Commands System

### Commands are Templates

**Not**: Slash commands (Claude Code specific)

**Are**: Markdown files with PowerShell code blocks

**Format**:
```markdown
# Command Name

## Purpose
What it does

## Usage
```powershell
# PowerShell code here
```

## When to Use
Guidance for user/AI
```

### Command Execution Flow

1. **AI references**: Reads `/commands/[name].md` via Knowledge Base
2. **AI presents**: Shows PowerShell code to user
3. **User reviews**: Checks if safe/appropriate
4. **User executes**: Copies to PowerShell, runs manually
5. **User reports**: Shares output with AI
6. **AI continues**: Uses output to proceed with task

### Why Manual Execution?

**80/20 Efficiency**:
- No complex MCP server setup (yet)
- User maintains control and visibility
- Safe (user reviews before execution)
- Works with any GUI immediately

**Future**: MCP server can automate this flow

---

## Skills System

### Always Loaded: CORE

**Path**: `/skills/CORE`

**Contains**: Fundamental capabilities all agents use

**Loaded**: Automatically on every session

### On-Demand Skills

**Path**: `/skills/[skill_name]`

**Loaded**: When AI determines it's needed

**Discovery**: AI scans `/skills` directory for relevant tools

### Skill Structure

```
/skills/YOUR_SKILL/
├── SKILL.md              ← Description, USE WHEN, capabilities
├── README.md             ← Usage documentation
└── [tools/scripts]       ← Implementation
```

**AI reads SKILL.md to determine if skill is relevant**

---

## Path Resolution

### Environment Variable Based

**Priority**:
1. `$env:PAI_ROOT` (PowerShell environment - user/system level)
2. `.env` file (if present)
3. Auto-detect (from script location)

### Windows-Native

**Format**: `C:\path\to\.claude\subdir`

**Not**: `/path/to/.claude/subdir` (Linux style)

**Example**:
```json
"paths": {
    "skills_dir": "${PAI_ROOT}\\skills"
}
```

**Resolution**:
```powershell
$skillsDir = $settings.paths.skills_dir -replace '\$\{PAI_ROOT\}', $env:PAI_ROOT
# Result: C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows\.claude\skills
```

---

## GUI Integration Patterns

### Cherry Studio (Current)

**Method**: Knowledge Base + Custom Instructions

**Setup**:
1. Add `.claude` folder to Knowledge Base
2. Set Custom Instructions to reference structure
3. Run `Initialize-PAI.ps1` for context
4. AI reads files as needed

**Pros**:
- Works immediately
- No additional tools
- File-based (safe)

### LibreChat (Future)

**Method**: RAG + File System Access

**Setup**:
1. Enable file system access to `.claude`
2. Enable RAG for agents/skills
3. Custom preset with PAI instructions
4. Auto-context injection

**Pros**:
- Deeper integration
- RAG-powered skill discovery
- Preset management

### Claude Code (Future)

**Method**: Native `.claude` folder

**Setup**:
1. Place `.claude` in project root
2. Commands become slash commands automatically
3. Skills auto-discovered
4. No additional setup

**Pros**:
- Native support
- Slash commands work
- Full integration

---

## Extensibility

### Adding New Agents

```powershell
# 1. Create agent file
@"
---
name: "your_agent"
personality_type: "analytical"
response_style: "detailed"
---

# Your Agent

Description and behavior guidelines...

USE WHEN: User needs...

BEHAVIOR:
- Characteristic 1
- Characteristic 2
"@ | Out-File .claude\agents\your_agent.md

# 2. Use it
"Use your_agent: Do something"
```

### Adding New Skills

```powershell
# 1. Create directory
mkdir .claude\skills\YOUR_SKILL

# 2. Create SKILL.md
@"
# YOUR_SKILL

USE WHEN: User needs to...
CAPABILITIES: ...
"@ | Out-File .claude\skills\YOUR_SKILL\SKILL.md

# 3. AI auto-discovers
```

### Adding New Commands

```powershell
# 1. Create markdown file
@"
# Your Command

## Purpose
...

## Usage
```powershell
# Code here
```
"@ | Out-File .claude\commands\your-command.md

# 2. AI can reference it
```

---

## Security Considerations

### Secrets Management

**Never commit**:
- `.env` file
- `/history` directory
- Any file with API keys

**Use**:
- `.gitignore` to exclude sensitive files
- Environment variables for secrets
- Separate OneDrive folder for encrypted storage

### Script Execution

**User reviews before execution**:
- Commands are templates, not auto-executed
- User sees PowerShell code before running
- User controls what gets executed

**Future automation**:
- MCP server requires explicit permission
- Whitelist of safe commands
- Audit log of executions

---

## Future Enhancements

### Phase 1 (Current)
✅ Minimal settings.json
✅ Agent configs
✅ Commands as templates
✅ Manual execution
✅ Cherry Studio integration

### Phase 2 (Near Future)
- [ ] MCP server for command execution
- [ ] LibreChat integration guide
- [ ] Hook system implementation
- [ ] History/logging system

### Phase 3 (Future)
- [ ] Auto-initialization hooks
- [ ] Advanced RAG integration
- [ ] Multi-GUI sync
- [ ] Cloud backup/sync

---

## Comparison: Daniel's PAI vs Clippy

| Feature | Daniel's PAI | Clippy (Windows) |
|---------|-------------|------------------|
| **Platform** | macOS/Linux | Windows |
| **Shell** | Bash/Zsh | PowerShell 7.5 |
| **Paths** | Forward slashes | Backslashes |
| **Commands** | Slash commands (Claude Code) | Templates (GUI-agnostic) |
| **Settings** | Detailed | Minimal (script-used only) |
| **Agent configs** | In settings.json | Separate files |
| **Deployment** | Fixed location | Flexible (env var) |
| **GUI** | Claude Code | Cherry Studio (+ others) |

**Key Philosophy Difference**:
- **Daniel's**: Optimized for Claude Code, macOS
- **Clippy**: GUI-agnostic, Windows-native, modular

---

## Summary

**What Makes This Work**:

1. **Minimal Core** - settings.json only has what scripts use
2. **Modular Agents** - Personality configs separate from core
3. **Template Commands** - Works with any GUI (no slash command dependency)
4. **Flexible Paths** - Deploy anywhere via environment variables
5. **Manual Execution** - User control, GUI-agnostic (80/20 efficiency)
6. **Future-Proof** - Ready for MCP, hooks, advanced features

**Result**: A PAI system that works with Cherry Studio today, LibreChat tomorrow, and any AI interface in the future.