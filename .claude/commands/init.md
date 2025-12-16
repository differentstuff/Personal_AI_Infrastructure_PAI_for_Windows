# Init - Initialize PAI Context

## Purpose
Gathers system context and loads initial configuration. Run this at the start of a session to provide the AI with current system state.

## What It Does
1. Gets current date/time and timezone
2. Reads PAI configuration
3. Loads default agent settings
4. Outputs formatted context for AI consumption

## Usage

### Manual Execution
```powershell
# Run initialization script
./tools/Initialize-PAI.ps1
```

### Expected Output
```
=== PAI Initialization ===
Current Date: 2024-12-16
Current Time: 09:45:23
Timezone: Europe/Zurich

User: User
Assistant: Clippy
Active Agent: assistant (INTP personality)

PAI Root: C:\Users\User\.claude
Default Skills: CORE

System Ready.
```

## When to Use
- Start of new conversation
- After configuration changes
- When context seems missing
- Before complex multi-step tasks

## Future
- Auto-run via hooks (when enabled)
- MCP server can trigger automatically
- Startup script integration
