#!/usr/bin/env bun
/**
 * PAI Installation Wizard for Windows
 *
 * Windows-native interactive CLI wizard for setting up PAI.
 * Auto-detects AI system directories and creates safety backups.
 * Uses Bun runtime for TypeScript execution.
 *
 * Platform: Windows 11 + PowerShell 7.5+
 * 
 * Usage:
 *   bun run install.ts --install-dir=C:/path/to/dir
 */

import { $ } from "bun";
import * as readline from "readline";
import { existsSync } from "fs";
import { mkdir } from "fs/promises";

// =============================================================================
// COMMAND LINE ARGUMENT PARSING
// =============================================================================

function parseInstallDir(): string {
  const args = process.argv.slice(2);
  for (const arg of args) {
    if (arg.startsWith("--install-dir=")) {
      return arg.substring("--install-dir=".length);
    }
  }
  
  // Fallback: Use PAI_DIR environment variable
  const paiDir = process.env.PAI_DIR;
  if (paiDir) {
    return paiDir.replace(/\\/g, "/");
  }
  
  // Default fallback
  const userProfile = process.env.USERPROFILE || process.env.HOME;
  return `${userProfile}/.claude`.replace(/\\/g, "/");
}

// =============================================================================
// TYPES
// =============================================================================

interface AISystem {
  name: string;
  dir: string;
  exists: boolean;
}

interface WizardConfig {
  assistantName: string;
  timeZone: string;
  userName: string;
  elevenLabsApiKey?: string;
  elevenLabsVoiceId?: string;
  installDir: string;
}

interface ExistingConfig {
  assistantName?: string;
  timeZone?: string;
  userName?: string;
  elevenLabsApiKey?: string;
  elevenLabsVoiceId?: string;
}

async function readExistingConfig(installDir: string): Promise<ExistingConfig> {
  const config: ExistingConfig = {};
  
  try {
    const settingsPath = `${installDir}/settings.json`;
    if (existsSync(settingsPath)) {
      const settingsContent = await Bun.file(settingsPath).text();
      const settings = JSON.parse(settingsContent);
      
      if (settings.identity) {
        config.userName = settings.identity.user_name;
        config.assistantName = settings.identity.assistant_name;
        config.timeZone = settings.identity.timezone;
      }
    }
  } catch {
    // No settings.json, continue with empty config
  }
  
  // Try to read from .env file for API keys
  try {
    const envPath = `${installDir}/.env`;
    if (existsSync(envPath)) {
      const envContent = await Bun.file(envPath).text();
      const lines = envContent.split("\n");
      for (const line of lines) {
        const match = line.match(/^([A-Z_]+)=(.*)$/);
        if (match) {
          const [, key, value] = match;
          if (key === "ELEVENLABS_API_KEY") config.elevenLabsApiKey = value;
          if (key === "ELEVENLABS_VOICE_ID") config.elevenLabsVoiceId = value;
        }
      }
    }
  } catch {
    // No .env file, continue
  }
  
  return config;
}

// =============================================================================
// UTILITIES
// =============================================================================

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

function ask(question: string): Promise<string> {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer.trim());
    });
  });
}

async function askWithDefault(question: string, defaultValue: string): Promise<string> {
  const answer = await ask(`${question} [${defaultValue}]: `);
  return answer || defaultValue;
}

function isValidTimezone(tz: string): boolean {
  try {
    Intl.DateTimeFormat(undefined, { timeZone: tz });
    return true;
  } catch {
    return false;
  }
}

async function askYesNo(question: string, defaultYes = true): Promise<boolean> {
  const defaultStr = defaultYes ? "Y/n" : "y/N";
  const answer = await ask(`${question} [${defaultStr}]: `);
  if (!answer) return defaultYes;
  return answer.toLowerCase().startsWith("y");
}

function printHeader(title: string) {
  console.log("\n" + "=".repeat(60));
  console.log(`  ${title}`);
  console.log("=".repeat(60) + "\n");
}

// =============================================================================
// AI SYSTEM DETECTION
// =============================================================================

function detectAISystems(): AISystem[] {
  const userProfile = process.env.USERPROFILE || process.env.HOME;
  const onedrive = process.env.ONEDRIVE || process.env.OneDrive;
  
  const systems: AISystem[] = [
    { name: "Claude Code", dir: `${userProfile}\\.claude`, exists: false },
    { name: "Cherry Studio", dir: onedrive ? `${onedrive}\\.claude` : "", exists: false },
    { name: "Cursor", dir: `${userProfile}\\.cursor`, exists: false },
    { name: "Windsurf", dir: `${userProfile}\\.windsurf`, exists: false },
    { name: "Cline", dir: `${userProfile}\\.cline`, exists: false },
    { name: "Continue", dir: `${userProfile}\\.continue`, exists: false },
  ];

  for (const system of systems) {
    if (system.dir) {
      system.exists = existsSync(system.dir);
    }
  }

  return systems.filter(s => s.dir);
}

function getDetectedSystems(systems: AISystem[]): AISystem[] {
  return systems.filter((s) => s.exists);
}

// =============================================================================
// BACKUP
// =============================================================================

async function detectAndBackup(installDir: string): Promise<boolean> {
  const allSystems = detectAISystems();
  const detectedSystems = getDetectedSystems(allSystems);
  const backupDir = `${installDir}-BACKUP`;

  console.log("Scanning for existing AI system directories...\n");

  if (detectedSystems.length === 0) {
    console.log("   [*] No existing AI system directories detected");
    console.log("   [*] This will be a fresh installation\n");
  } else {
    console.log("   Detected AI systems:");
    for (const system of detectedSystems) {
      console.log(`      - ${system.name}: ${system.dir}`);
    }
    console.log();
  }

  const paiExists = existsSync(installDir);

  if (!paiExists) {
    console.log(`   [*] No existing PAI found at ${installDir}`);
    console.log(`   [*] Fresh installation\n`);

    const proceed = await askYesNo(
      `Ready to install PAI to ${installDir}. Proceed?`,
      true
    );
    if (!proceed) {
      console.log("\n   [!] Installation cancelled\n");
      return false;
    }
    return true;
  }

  console.log("┌─────────────────────────────────────────────────────────────┐");
  console.log("│  SAFETY BACKUP                                              │");
  console.log("├─────────────────────────────────────────────────────────────┤");
  console.log("│                                                             │");
  console.log("│  The installer will:                                        │");
  console.log("│                                                             │");
  console.log(`│  1. Copy your current ${installDir.padEnd(40)} │`);
  console.log(`│     to ${backupDir.padEnd(53)} │`);
  console.log(`│  2. Install fresh PAI files into ${installDir.padEnd(26)} │`);
  console.log("│                                                             │");
  console.log("│  Your original files will be preserved in the backup.       │");
  console.log("│                                                             │");
  console.log("└─────────────────────────────────────────────────────────────┘");
  console.log();

  if (existsSync(backupDir)) {
    console.log(`   [!] Existing backup found at ${backupDir}`);
    const overwrite = await askYesNo("   Overwrite existing backup?", false);
    if (!overwrite) {
      console.log("   [!] Please manually remove or rename the existing backup first\n");
      return false;
    }
    await $`powershell -Command "Remove-Item -Path '${backupDir}' -Recurse -Force"`.quiet();
  }

  const proceed = await askYesNo(
    "Do you want to proceed with the backup and installation?",
    true
  );
  if (!proceed) {
    console.log("\n   [!] Installation cancelled\n");
    return false;
  }

  console.log(`\n   [*] Backing up ${installDir} to ${backupDir}...`);
  await $`powershell -Command "Copy-Item -Path '${installDir}' -Destination '${backupDir}' -Recurse -Force"`.quiet();
  console.log("   [OK] Backup complete\n");
  return true;
}

// =============================================================================
// MAIN WIZARD
// =============================================================================

async function gatherConfig(installDir: string): Promise<WizardConfig> {
  printHeader("PAI CONFIGURATION");

  console.log("This wizard will configure your AI assistant.\n");
  console.log(`   Installation directory: ${installDir}\n`);

  // Read existing configuration if available
  const existing = await readExistingConfig(installDir);
  
  if (existing.userName || existing.assistantName) {
    console.log("   [*] Found existing configuration:");
    if (existing.userName) console.log(`       User: ${existing.userName}`);
    if (existing.assistantName) console.log(`       Assistant: ${existing.assistantName}`);
    if (existing.timeZone) console.log(`       Timezone: ${existing.timeZone}`);
    console.log();
    
    const keepExisting = await askYesNo("Keep existing configuration?", true);
    if (keepExisting && existing.userName && existing.assistantName && existing.timeZone) {
      return {
        assistantName: existing.assistantName,
        timeZone: existing.timeZone,
        userName: existing.userName,
        elevenLabsApiKey: existing.elevenLabsApiKey,
        elevenLabsVoiceId: existing.elevenLabsVoiceId,
        installDir,
      };
    }
    console.log("   [*] Updating configuration:\n");
  }

  const userName = existing.userName
    ? await askWithDefault("What is your name?", existing.userName)
    : await ask("What is your name? ");

  const assistantName = await askWithDefault(
    "What would you like to name your AI assistant?",
    existing.assistantName || "PAI"
  );

  const defaultTz = existing.timeZone || Intl.DateTimeFormat().resolvedOptions().timeZone;
  let timeZone = await askWithDefault("What's your timezone?", defaultTz);

  while (!isValidTimezone(timeZone)) {
    console.log(`   [!] "${timeZone}" is not a valid IANA timezone`);
    console.log(`   [*] Examples: America/New_York, Europe/London, Asia/Tokyo`);
    timeZone = await askWithDefault("What's your timezone?", defaultTz);
  }

  const defaultWantsVoice = !!existing.elevenLabsApiKey;
  const wantsVoice = await askYesNo(
    "\nDo you want voice notifications? (requires ElevenLabs API key)",
    defaultWantsVoice
  );

  let elevenLabsApiKey: string | undefined;
  let elevenLabsVoiceId: string | undefined;

  if (wantsVoice) {
    if (existing.elevenLabsApiKey) {
      const keepKey = await askYesNo(
        `Keep existing ElevenLabs API key (****${existing.elevenLabsApiKey.slice(-4)})?`,
        true
      );
      elevenLabsApiKey = keepKey ? existing.elevenLabsApiKey : await ask("Enter your ElevenLabs API key: ");
    } else {
      elevenLabsApiKey = await ask("Enter your ElevenLabs API key: ");
    }
    elevenLabsVoiceId = await askWithDefault(
      "Enter your preferred voice ID",
      existing.elevenLabsVoiceId || "s3TPKV1kjDlVtZbl4Ksh"
    );
  }

  return {
    assistantName,
    timeZone,
    userName,
    elevenLabsApiKey,
    elevenLabsVoiceId,
    installDir,
  };
}

// =============================================================================
// FILE GENERATION
// =============================================================================

function generateSkillMd(config: WizardConfig): string {
  return `---
name: CORE
description: Personal AI Infrastructure core. AUTO-LOADS at session start.
---

# CORE - Personal AI Infrastructure

## Identity

**Assistant:**
- Name: ${config.assistantName}
- Role: ${config.userName}'s AI assistant
- Operating Environment: Personal AI infrastructure

**User:**
- Name: ${config.userName}

---

## Stack Preferences

- **Language:** TypeScript preferred over Python
- **Package Manager:** bun (NEVER npm/yarn/pnpm)
- **Runtime:** Bun
- **Markup:** Markdown (NEVER HTML for basic content)

---

## Quick Reference

**Full documentation available in context files:**
- Contacts: \`Contacts.md\`
- Stack preferences: \`CoreStack.md\`
`;
}

function generateContactsMd(config: WizardConfig): string {
  return `# Contact Directory

Quick reference for frequently contacted people.

---

## Contacts

| Name | Role | Email | Notes |
|------|------|-------|-------|
| [Add contacts here] | [Role] | [email] | [Notes] |

---

## Usage

When asked about someone:
1. Check this directory first
2. Return the relevant contact information
3. If not found, ask for details
`;
}

function generateCoreStackMd(config: WizardConfig): string {
  return `# Core Stack Preferences

Technical preferences for code generation and tooling.

Generated: ${new Date().toISOString().split("T")[0]}

---

## Language Preferences

| Priority | Language | Use Case |
|----------|----------|----------|
| 1 | TypeScript | Primary for all new code |
| 2 | Python | Data science, ML, when required |

---

## Package Managers

| Language | Manager | Never Use |
|----------|---------|-----------|
| JavaScript/TypeScript | bun | npm, yarn, pnpm |
| Python | uv | pip, pip3 |

---

## Runtime

| Purpose | Tool |
|---------|------|
| JavaScript Runtime | Bun |
| Serverless | Cloudflare Workers |

---

## Code Style

- Prefer explicit over clever
- No unnecessary abstractions
- Comments only where logic isn't self-evident
- Error messages should be actionable
`;
}

// =============================================================================
// MAIN
// =============================================================================

async function main() {
  console.log(`
╔══════════════════════════════════════════════════════════════╗
║           PAI - Personal AI Infrastructure                   ║
║                 Windows Native Installer                     ║
╚══════════════════════════════════════════════════════════════╝
  `);

  try {
    const installDir = parseInstallDir();
    
    printHeader("STEP 1: DETECT & BACKUP");
    const backupOk = await detectAndBackup(installDir);
    if (!backupOk) {
      process.exit(1);
    }

    printHeader("STEP 2: CONFIGURATION");
    const config = await gatherConfig(installDir);

    printHeader("STEP 3: INSTALLATION");

	// Read existing configuration to determine if this is an update
	const existingConfig = await readExistingConfig(installDir);
	const isUpdate = !!(existingConfig.userName || existingConfig.assistantName);

	if (!isUpdate) {
	  console.log("   [*] Creating directory structure...");
	  await mkdir(`${installDir}/skills/CORE/workflows`, { recursive: true });
	  await mkdir(`${installDir}/skills/CORE/tools`, { recursive: true });
	  await mkdir(`${installDir}/history/sessions`, { recursive: true });
	  await mkdir(`${installDir}/history/learnings`, { recursive: true });
	  await mkdir(`${installDir}/history/research`, { recursive: true });
	  await mkdir(`${installDir}/history/decisions`, { recursive: true });
	  await mkdir(`${installDir}/agents`, { recursive: true });
	  await mkdir(`${installDir}/commands`, { recursive: true });
	} else {
	  console.log("   [*] Using existing directory structure...");
	}

	console.log("   [*] Generating SKILL.md...");
	const skillMd = generateSkillMd(config);
	await Bun.write(`${installDir}/skills/CORE/SKILL.md`, skillMd);


    console.log("   [*] Generating Contacts.md...");
    const contactsMd = generateContactsMd(config);
    await Bun.write(`${installDir}/skills/CORE/Contacts.md`, contactsMd);

    console.log("   [*] Generating CoreStack.md...");
    const coreStackMd = generateCoreStackMd(config);
    await Bun.write(`${installDir}/skills/CORE/CoreStack.md`, coreStackMd);

    console.log("   [*] Creating .env file...");
    const envFileContent = `# PAI Environment Configuration
# Created: ${new Date().toISOString().split("T")[0]}

ASSISTANT_NAME=${config.assistantName}
USER_NAME=${config.userName}
TIME_ZONE=${config.timeZone}
${config.elevenLabsApiKey ? `ELEVENLABS_API_KEY=${config.elevenLabsApiKey}` : "# ELEVENLABS_API_KEY="}
${config.elevenLabsVoiceId ? `ELEVENLABS_VOICE_ID=${config.elevenLabsVoiceId}` : "# ELEVENLABS_VOICE_ID="}
`;
    await Bun.write(`${installDir}/.env`, envFileContent);

    console.log("   [*] Creating settings.json...");
    const settingsJson = {
      identity: {
        user_name: config.userName,
        assistant_name: config.assistantName,
        timezone: config.timeZone,
      },
      paths: {
        skills_dir: `${installDir}/skills`,
        agents_dir: `${installDir}/agents`,
        history_dir: `${installDir}/history`,
      },
    };

    await Bun.write(`${installDir}/settings.json`, JSON.stringify(settingsJson, null, 2) + "\n");
    console.log("   [OK] Created settings.json\n");

    printHeader("INSTALLATION COMPLETE");

    console.log(`
Your PAI system is configured:

   [*] Installation: ${installDir}
   [*] Backup: ${installDir}-BACKUP
   [*] Assistant Name: ${config.assistantName}
   [*] User: ${config.userName}
   [*] Timezone: ${config.timeZone}
   [*] Voice: ${config.elevenLabsApiKey ? "Enabled" : "Disabled"}

Files created:
   - ${installDir}/skills/CORE/SKILL.md
   - ${installDir}/skills/CORE/Contacts.md
   - ${installDir}/skills/CORE/CoreStack.md
   - ${installDir}/.env
   - ${installDir}/settings.json

Next steps:

   1. Configure API keys as environment variables
   2. Customize settings.json
   3. Add PAI directory to your AI client:
      - Cherry Studio: Add to Knowledge Base
      - Claude Desktop: Set working directory
   4. Environment variable: PAI_DIR=${installDir}
`);

  } catch (error) {
    console.error("\n   [!] Installation failed:", error);
    process.exit(1);
  } finally {
    rl.close();
  }
}

main();
