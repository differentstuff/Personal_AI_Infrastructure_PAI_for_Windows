# PAI Bundle Template

Specification for creating custom PAI bundles on Windows.

## What is a Bundle?

A **bundle** is a curated collection of packs that are installed together as a cohesive system. It's like an "app store" that bundles multiple related features into one installation.

Bundles do NOT contain code - they reference packs from the `Packs/` directory.

## Required Files

```
Bundles/YourBundle/
├── README.md              ← Bundle specification (REQUIRED)
├── install.ts             ← Installation script (REQUIRED)
└── your-icon.png          ← Icon (OPTIONAL)
```

## README.md Structure

```markdown
# Bundle Name

One-line description of what this bundle provides.

## Overview

Detailed description of the bundle's purpose and target users.

## Packs Included

List all packs included in this bundle with descriptions:

- [Pack-Name](../../Packs/Pack-Name/) - Pack description
- [Another-Pack](../../Packs/Another-Pack/) - Another pack description

## Installation Order

Specify the order packs should be installed (important for dependencies):

1. Core-Infrastructure
2. Agent-Assistant
3. Agent-Engineer
4. ...

## Dependencies

List any external dependencies:
- Bun 1.1+ runtime
- PowerShell 7.5+
- API keys (OpenAI, Anthropic, etc.)

## Platform

- Windows 10/11 only
- Requires `$env:PAI_Root\.claude` workspace
- Compatible with Cherry Studio, Claude Code

## Verification

After installation, verify with:

```powershell
# Check skill installation
Get-ChildItem $env:PAI_Root\.claude\skills

# Check agents
Get-ChildItem $env:PAI_Root\.claude\agents

# Run diagnostic
. Tools/CheckPAIState.md
```

## Credits

Based on Daniel Miessler's PAI v2 architecture.
Adapted for Windows by [Your Name].
```

## install.ts Template

```typescript
#!/usr/bin/env bun

/**
 * PAI Bundle Installer - Windows Version
 * 
 * Installs a curated collection of PAI packs to user's workspace.
 * 
 * Usage:
 *   bun run Bundles/YourBundle/install.ts
 */

import { $ } from "bun";
import { existsSync, mkdirSync, writeFileSync, readFileSync } from "fs";
import { resolve } from "path";

// Configuration
const PACKS_DIR = resolve(import.meta.dir, "../../Packs");
const HOME = process.env.USERPROFILE || process.env.HOME;
const PAI_DIR = process.env.PAI_DIR || `${HOME}/.claude`;

// Define your packs and installation order
const PACKS_TO_INSTALL = [
  "PAI-Core",
  "PAI-Agent-Assistant",
  "PAI-Agent-Engineer",
  // Add more packs as needed
];

// Colors for terminal output
const COLORS = {
  reset: "\x1b[0m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  cyan: "\x1b[36m",
  gray: "\x1b[90m",
};

/**
 * Print colored message
 */
function print(color: keyof typeof COLORS, message: string) {
  console.log(`${COLORS[color]}${message}${COLORS.reset}`);
}

/**
 * Check if Bun is installed
 */
function checkBun(): boolean {
  const bunAvailable = Bun.which("bun");
  if (!bunAvailable) {
    print("yellow", "⚠️  Bun is not installed!");
    print("yellow", "   Install with: powershell -c \"irm bun.sh/install.ps1 | iex\"");
    return false;
  }
  return true;
}

/**
 * Check if workspace exists
 */
function checkWorkspace(): boolean {
  if (existsSync(PAI_DIR)) {
    return true;
  }
  
  print("yellow", `⚠️  Workspace not found: ${PAI_DIR}`);
  print("cyan", "   Creating workspace...\n");
  
  mkdirSync(PAI_DIR, { recursive: true });
  return true;
}

/**
 * Check if pack exists in repository
 */
function packExists(packName: string): boolean {
  return existsSync(resolve(PACKS_DIR, packName));
}

/**
 * Create backup of existing files
 */
async function createBackup(): Promise<string> {
  const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
  const backupDir = resolve(PAI_DIR, `backup-${timestamp}`);
  
  await $`cp -r ${PAI_DIR} ${backupDir}`.quiet();
  
  return backupDir;
}

/**
 * Install a single pack
 */
async function installPack(packName: string): Promise<boolean> {
  print("cyan", `\n📦 Installing ${packName}...`);
  
  const packDir = resolve(PACKS_DIR, packName);
  
  // Check if pack exists
  if (!packExists(packName)) {
    print("yellow", `   ⏭️  Pack not found in repository, skipping`);
    return false;
  }
  
  // Run pack's install script if it exists
  const installScript = resolve(packDir, "src/install.ts");
  
  if (existsSync(installScript)) {
    try {
      await $`bun run ${installScript}`.quiet();
      print("green", `   ✅ Installed ${packName}`);
      return true;
    } catch (error) {
      print("yellow", `   ⚠️  Installation script not found or failed`);
      return false;
    }
  } else {
    print("yellow", `   ⏭️  No installation script, skipping`);
    return false;
  }
}

/**
 * Update shell profile (PowerShell for Windows)
 */
function updateShellProfile(): void {
  const profileDir = `${HOME}/Documents/PowerShell`;
  const profilePath = `${profileDir}/Microsoft.PowerShell_profile.ps1`;
  
  if (!existsSync(profilePath)) {
    mkdirSync(profileDir, { recursive: true });
    writeFileSync(profilePath, `# PAI Configuration\nexport PAI_DIR="${PAI_DIR}"\n`);
    print("green", `   ✅ Created PowerShell profile`);
    return;
  }
  
  print("gray", `   ⏭️  PowerShell profile already exists`);
}

/**
 * Verify installation
 */
function verifyInstallation(): void {
  print("cyan", "\n🔍 Verifying installation...\n");
  
  const checks = [
    { name: "Workspace", path: PAI_DIR },
    { name: "Skills", path: `${PAI_DIR}/skills` },
    { name: "Agents", path: `${PAI_DIR}/agents` },
  ];
  
  checks.forEach(check => {
    if (existsSync(check.path)) {
      print("green", `   ✅ ${check.name}: ${check.path}`);
    } else {
      print("yellow", `   ⚠️  ${check.name} not found at ${check.path}`);
    }
  });
}

/**
 * Main installation function
 */
async function main() {
  print("cyan", "🚀 PAI Bundle Installer for Windows\n");
  
  // 1. Check prerequisites
  if (!checkBun()) {
    print("red", "❌ Cannot continue without Bun");
    process.exit(1);
  }
  
  if (!checkWorkspace()) {
    print("red", "❌ Cannot check or create workspace");
    process.exit(1);
  }
  
  print("gray", `Workspace: ${PAI_DIR}`);
  print("gray", `Bundles: ${PACKS_TO_INSTALL.join(", ")}\n`);
  
  // 2. Create backup
  if (existsSync(resolve(PAI_DIR, "skills"))) {
    const backupDir = await createBackup();
    print("gray", `Backup: ${backupDir}\n`);
  }
  
  // 3. Install packs
  let installedCount = 0;
  
  for (const packName of PACKS_TO_INSTALL) {
    const installed = await installPack(packName);
    if (installed) installedCount++;
  }
  
  // 4. Update shell profile
  print("\n⚙️  Configuring shell...");
  updateShellProfile();
  
  // 5. Verify installation
  verifyInstallation();
  
  // 6. Summary
  print("\n" + "=".repeat(50));
  print("green", `✅ Installation complete!`);
  print("gray", `   Installed: ${installedCount}/${PACKS_TO_INSTALL.length} packs`);
  print("gray", `   Workspace: ${PAI_DIR}`);
  print("cyan", "\n📚 Next steps:");
  print("gray", "   1. Configure API keys in .env file");
  print("gray", "   2. Restart your AI client (Cherry Studio, Claude Code)");
  print("gray", "   3. Run: bun Tools/CheckPAIState.md\n");
}

// Run installer
main().catch(err => {
  print("red", `❌ Error: ${err.message}`);
  process.exit(1);
});
```

## Installation Order Best Practices

### Order by Dependencies

Install infrastructure first, then dependent features:

1. **Core System** (no dependencies)
2. **Agents** (depend on skills)
3. **Features** (depend on core)
4. **Enhancements** (depend on above)

### Example: PAI for Windows Bundle

```typescript
const PACKS_TO_INSTALL = [
  // 1. Core infrastructure (must be first)
  "PAI-Core",
  
  // 2. Agent systems (depend on core)
  "PAI-Agent-Assistant",
  "PAI-Agent-Engineer",
  "PAI-Agent-Researcher",
  
  // 3. Skills and tools
  "PAI-Fabric-Skill",
  "PAI-PowerShell-Tools",
  
  // 4. Optional enhancements
  "PAI-History-System",
];
```

## Naming Conventions

### Bundle Names
- PascalCase: `YourBundle`
- Descriptive: `Developertools`, `Researcher`, `Complete`

### Pack Names
- PascalCase with prefix: `PAI-[Category]-[Name]`
- Examples: `PAI-Core`, `PAI-Agent-Assistant`, `PAI-Fabric-Skill`

## Testing Your Bundle

Before submitting your bundle:

1. ✅ Install in fresh workspace
2. ✅ Verify all packs install correctly
3. ✅ Test dependencies
4. ✅ Run diagnostic check
5. ✅ Document verification steps

```powershell
# Test bundle installation
cd C:\Temp\Personal_AI_Infrastructure_PAI_for_Windows_v2

# Fresh workspace setup
mkdir $HOME\.claude-test
$env:PAI_DIR = "$HOME\.claude-test"

# Run installer
bun run Bundles/PAI/install.ts

# Verify
. Tools/CheckPAIState.md

# Cleanup
Remove-Item -Recurse -Force $HOME\.claude-test
```

## Additional Considerations

### Platform Compatibility
- Specify Windows version requirements
- Document any Windows-specific features
- Test on multiple Windows versions if possible

### User Experience
- Provide clear instructions
- Include verification steps
- Document common issues and solutions

### Maintenance
- Keep pack versions up-to-date
- Update README when packs change
- Track bundle version

## Example: Complete Bundle

See `Bundles/PAI/` for a complete working example of a Windows PAI bundle.

---

Last updated: 2025-01-15  
Platform: Windows 10/11 + PowerShell 7.5+
Runtime: Bun 1.1+
