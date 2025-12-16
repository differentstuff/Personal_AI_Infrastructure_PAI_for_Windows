# PAI Update - Intelligent Sideloading System

You are helping the user safely update their PAI installation while preserving their customizations.

## Overview

The user has customized their PAI system (changed assistant_name, added skills, modified hooks, changed settings). They want to pull updates from the upstream PAI repository without losing their work.

## Your Task

Execute this workflow step by step:

### Phase 1: Fetch Upstream PAI

1. **Check for staging directory**: Look for `.claude/pai_updates/`

2. **Fetch latest PAI**: The user's project IS a clone of PAI. Use git to get upstream:

```powershell
# Ensure we have the upstream remote
$upstreamUrl = git remote get-url upstream 2>$null
if (-not $upstreamUrl) {
    git remote add upstream https://github.com/differentstuff/Personal_AI_Infrastructure_PAI_for_Windows.git
}

# Fetch latest from upstream (doesn't modify working directory)
git fetch upstream main

# Create staging directory
Remove-Item -Path .claude/pai_updates -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path .claude/pai_updates -Force

# Export upstream's .claude directory to staging (clean, no .git)
# Note: git archive may not work on Windows - use alternative
$upstreamCommit = git rev-parse upstream/main
git worktree add --detach .claude/pai_updates_temp $upstreamCommit
Copy-Item -Path .claude/pai_updates_temp/.claude/* -Destination .claude/pai_updates/ -Recurse -Force
git worktree remove .claude/pai_updates_temp --force
Remove-Item -Path .claude/pai_updates_temp -Recurse -Force -ErrorAction SilentlyContinue
```

**Alternative (if git worktree fails)**:
```powershell
# Clone upstream to temp location
$tempPath = Join-Path $env:TEMP "pai_upstream_$(Get-Date -Format 'yyyyMMddHHmmss')"
git clone --depth 1 --branch main https://github.com/differentstuff/Personal_AI_Infrastructure_PAI_for_Windows.git $tempPath
Copy-Item -Path "$tempPath\.claude\*" -Destination .claude/pai_updates/ -Recurse -Force
Remove-Item -Path $tempPath -Recurse -Force
```

This gives us `.claude/pai_updates/` containing the pure upstream `.claude/` contents without affecting the user's working directory.

3. **Record version info**:
```powershell
$upstreamCommit = git rev-parse upstream/main
$upstreamDate = git log -1 --format=%ci upstream/main
Write-Host "Upstream: $upstreamCommit ($upstreamDate)"
```

4. **Check user's current sync state**: Look for `.claude/.pai-sync-history` to see when they last synced

### Phase 2: Analyze Differences

Compare the staging directory (`.claude/pai_updates/`) against the user's active directory (`.claude/`).

For each file category:

**Settings (`settings.json`)**:
- Identify new keys added upstream
- Identify keys the user has customized (especially `defaults.assistant_name`, custom env vars)
- Plan a smart merge that adds new keys while preserving user values

**Skills (`.claude/skills/`)**:
- New skills in upstream → Available to add
  - Examples: CORE, fabric, research, security, code-analysis
- Modified skills → Compare if user has customized
- User's own skills (not in upstream) → Never touch these
  - Identify by comparing with upstream skill list

**Hooks (`.claude/hooks/`)**:
- Critical: hooks often contain custom logic
- Check if user has modified vs. upstream version
- Identify breaking changes

**Agents (`.claude/agents/`)**:
- New agents available
  - Examples: assistant, engineer, researcher, architect
- Modified agents (usually safe to update)
- User's own agents (not in upstream) → Never touch these

**Commands (`.claude/commands/`)**:
- Don't overwrite user's own commands (not in upstream)
- Offer new commands from upstream

### Phase 3: Generate Report

Present a clear, organized report:

```
╔═══════════════════════════════════════════════════════════════════╗
║                     PAI UPDATE AVAILABLE                          ║
║                     Upstream: [commit hash]                       ║
║                     Your version: [last sync or "initial"]        ║
╠═══════════════════════════════════════════════════════════════════╣
║ SUMMARY                                                           ║
║ • X new files available                                           ║
║ • Y files updated upstream                                        ║
║ • Z potential conflicts with your customizations                  ║
╠═══════════════════════════════════════════════════════════════════╣
```

Then organize by category:

**🔴 REQUIRES ATTENTION** (conflicts with your customizations)
- List files where both upstream changed AND user modified
- Show what would be lost if blindly updated
- Recommend merge strategy

**🟢 SAFE TO AUTO-UPDATE** (you haven't modified these)
- List files that can be updated without risk
- These match your current upstream version

**🆕 NEW FEATURES** (available to add)
- New skills, agents, commands
- Brief description of what each does
- Recommendation based on user's apparent use case

**📝 YOUR ADDITIONS** (will be preserved)
- List user's files that don't exist upstream
- Examples: User-added skills, agents, hooks, commands
- Confirm these are safe and will be preserved

### Phase 4: Get User Decision

Present clear options:

```
What would you like to do?

[A] Apply all safe updates + add all new features (recommended for most users)
[S] Step through each change individually
[C] Conservative - only safe updates, skip new features
[M] Manual - show me the diffs, I'll decide everything
[N] Not now - keep staging for later review
```

### Phase 5: Execute Updates

For approved changes:

1. **Create backup**:
   ```powershell
   $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
   New-Item -ItemType Directory -Path .claude/pai_backups -Force
   Copy-Item -Path .claude/skills -Destination .claude/pai_backups/skills_$timestamp -Recurse
   Copy-Item -Path .claude/hooks -Destination .claude/pai_backups/hooks_$timestamp -Recurse
   Copy-Item -Path .claude/settings.json -Destination .claude/pai_backups/settings_$timestamp.json
   ```

2. **Apply changes**:
   - Copy approved new files
   - For settings.json: perform intelligent merge (preserve user keys, add new ones)
   - For conflicts user approved: apply the merge strategy they chose

3. **Update tracking**:
   ```powershell
   $timestamp = Get-Date -Format "o"
   $commit = git rev-parse upstream/main
   Add-Content -Path .claude/.pai-sync-history -Value "$timestamp $commit"
   ```

### Phase 6: Validate

After applying updates:
1. Check that settings.json is valid JSON
2. Verify no syntax errors in key hooks
3. Report success or any issues

### Phase 7: Cleanup Option

Ask if user wants to:
- Keep `.claude/pai_updates/` for reference
- Remove it to save space

---

## Important Notes

- **Never overwrite without asking** when user has customized a file
- **Always backup** before modifying existing files
- **Preserve user identity**: Their assistant name, custom env vars, personal touches
- **Be conservative**: When in doubt, ask rather than overwrite
- **Explain clearly**: Users should understand what each change does

## Handling Edge Cases

**First time running `/paiupdate`**:
- No sync history exists
- Treat all current files as "user's version" (may be customized)
- Be extra careful, ask more questions

**User has diverged significantly**:
- Many files modified
- Recommend reviewing section by section
- Offer to show detailed diffs

**Upstream has breaking changes**:
- Warn prominently
- Explain what might break
- Offer to defer those specific changes

**Not a git repo (downloaded as ZIP)**:
- If no `.git` directory exists, use alternative approach:
  ```powershell
  $tempPath = Join-Path $env:TEMP "pai_upstream_$(Get-Date -Format 'yyyyMMddHHmmss')"
  Invoke-WebRequest -Uri "https://github.com/differentstuff/Personal_AI_Infrastructure_PAI_for_Windows/archive/refs/heads/main.zip" -OutFile "$tempPath.zip"
  Expand-Archive -Path "$tempPath.zip" -DestinationPath $tempPath
  Copy-Item -Path "$tempPath\Personal_AI_Infrastructure_PAI_for_Windows-main\.claude\*" -Destination .claude/pai_updates/ -Recurse -Force
  Remove-Item -Path $tempPath -Recurse -Force
  Remove-Item -Path "$tempPath.zip" -Force
  ```
- Inform user they should consider using git for easier future updates

**User forked PAI**:
- Their `origin` is their fork, not upstream PAI
- Check if `upstream` remote exists, add it if not
- This is the expected setup for most users

---

## Begin Now

Start by checking for the staging directory and fetching the latest PAI. Then analyze and report.

$ARGUMENTS
