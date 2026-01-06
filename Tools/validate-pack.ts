#!/usr/bin/env bun

/**
 * PAI Pack Validator for Windows
 * 
 * Validates that a pack meets all PAI v2 requirements.
 * Checks directory structure, required files, and content format.
 * 
 * Usage:
 *   bun run Tools/validate-pack.ts [pack-name]
 *   bun run Tools/validate-pack.ts --all
 */

import { resolve } from "path";
import { existsSync, readFileSync, readdirSync, lstatSync } from "fs";

// Constants
const PACKS_DIR = resolve(import.meta.dir, "../Packs");
const PACK_ROOT = resolve(import.meta.dir, "..");

// Required files per pack
const REQUIRED_FILES = {
  root: ["README.md", "INSTALL.md", "VERIFY.md"],
  optional: ["icon.png"],
};

// Required directory structure
const REQUIRED_DIRS = ["src"];

// Colors for terminal output
const COLORS = {
  reset: "\x1b[0m",
  bright: "\x1b[1m",
  dim: "\x1b[2m",
  red: "\x1b[31m",
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
 * Print section header
 */
function printHeader(title: string) {
  print("cyan", `\n${"=".repeat(60)}`);
  print("cyan", ` ${title}`);
  print("cyan", `${"=".repeat(60)}\n`);
}

/**
 * Check if directory exists
 */
function checkDir(path: string, silent = false): boolean {
  const exists = existsSync(path);
  if (!silent) {
    if (exists) {
      print("green", `   ✅ ${path}`);
    } else {
      print("red", `   ❌ ${path}`);
    }
  }
  return exists;
}

/**
 * Check if file exists
 */
function checkFile(path: string, silent = false): boolean {
  const exists = existsSync(path);
  if (!silent) {
    if (exists) {
      print("green", `   ✅ ${path}`);
    } else {
      print("red", `   ❌ ${path}`);
    }
  }
  return exists;
}

/**
 * Read file safely
 */
function readFile(path: string): string | null {
  try {
    return readFileSync(path, "utf-8");
  } catch (error) {
    return null;
  }
}

/**
 * Validate README.md
 */
function validateReadme(packDir: string): { valid: boolean; errors: string[] } {
  print("cyan", "📖 Checking README.md...");

  const readmePath = resolve(packDir, "README.md");
  const errors: string[] = [];
  let valid = true;

  if (!existsSync(readmePath)) {
    print("yellow", "   ⚠️  README.md not found (optional but recommended)");
    return { valid: true, errors };
  }

  const content = readFile(readmePath);
  if (!content) {
    print("red", "   ❌ Cannot read README.md");
    return { valid: false, errors: ["Cannot read README.md"] };
  }

  // Check for required sections
  const requiredSections = [
    "# ",
    "## Overview",
    "## What This Pack Provides",
  ];

  let missingSections = 0;
  requiredSections.forEach((section) => {
    if (!content.includes(section)) {
      print("yellow", `   ⚠️  Missing section: ${section}`);
      missingSections++;
      errors.push(`Missing section: ${section}`);
    }
  });

  if (missingSections === 0) {
    print("green", "   ✅ README.md has all required sections");
  }

  return { valid: missingSections === 0, errors };
}

/**
 * Validate INSTALL.md
 */
function validateInstall(packDir: string): { valid: boolean; errors: string[] } {
  print("cyan", "📥 Checking INSTALL.md...");

  const installPath = resolve(packDir, "INSTALL.md");
  const errors: string[] = [];

  if (!existsSync(installPath)) {
    print("red", "   ❌ INSTALL.md isREQUIRED");
    return { valid: false, errors: ["INSTALL.md not found"] };
  }

  const content = readFile(installPath);
  if (!content) {
    print("red", "   ❌ Cannot read INSTALL.md");
    return { valid: false, errors: ["Cannot read INSTALL.md"] };
  }

  // Check for required sections
  const requiredSections = [
    "# Installation:",
    "## Prerequisites",
    "## Installation Steps",
    "## Post-Installation",
  ];

  let missingSections = 0;
  requiredSections.forEach((section) => {
    if (!content.includes(section)) {
      print("yellow", `   ⚠️  Missing section: ${section}`);
      missingSections++;
      errors.push(`Missing section: ${section}`);
    }
  });

  if (missingSections === 0) {
    print("green", "   ✅ INSTALL.md has all required sections");
  }

  // Check for Windows-specific content
  if (content.includes("bun.sh") && !content.includes("bun.sh/install.ps1")) {
    print("yellow", "   ⚠️  INSTALL.md may not include Windows Bun install instructions");
    errors.push("May lack Windows Bun install instructions");
  }

  return { valid: missingSections === 0, errors };
}

/**
 * Validate VERIFY.md
 */
function validateVerify(packDir: string): { valid: boolean; errors: string[] } {
  print("cyan", "🔍 Checking VERIFY.md...");

  const verifyPath = resolve(packDir, "VERIFY.md");
  const errors: string[] = [];

  if (!existsSync(verifyPath)) {
    print("red", "   ❌ VERIFY.md isREQUIRED");
    return { valid: false, errors: ["VERIFY.md not found"] };
  }

  const content = readFile(verifyPath);
  if (!content) {
    print("red", "   ❌ Cannot read VERIFY.md");
    return { valid: false, errors: ["Cannot read VERIFY.md"] };
  }

  // Check for verification content
  const hasTests = content.includes("test") || content.includes("verify");
  const hasSteps = content.includes("##") || content.indexOf("#") > 0;
  const hasExamples = content.includes("```powershell") || content.includes("```bash");

  if (!hasTests) {
    print("yellow", "   ⚠️  VERIFY.md should include verification tests");
    errors.push("No verification tests found");
  }
  if (!hasSteps) {
    print("yellow", "   ⚠️  VERIFY.md should include step-by-step verification");
    errors.push("No step-by-step verification found");
  }
  if (!hasExamples) {
    print("yellow", "   ⚠️  VERIFY.md should include PowerShell examples");
    errors.push("No PowerShell examples found");
  }

  if (hasTests && hasSteps && hasExamples) {
    print("green", "   ✅ VERIFY.md has verification tests and examples");
  }

  return { valid: hasTests && hasSteps, errors };
}

/**
 * Validate src/ directory structure
 */
function validateSrcDir(packDir: string): { valid: boolean; errors: string[] } {
  print("cyan", "📁 Checking src/ directory structure...");

  const srcDir = resolve(packDir, "src");
  const errors: string[] = [];

  if (!existsSync(srcDir)) {
    print("red", "   ❌ src/ directory does not exist");
    return { valid: false, errors: ["src/ directory not found"] };
  }

  // Check for at least one content directory
  const validDirs = ["skills", "agents", "tools", "commands"];
  const foundDirs: string[] = [];

  validDirs.forEach((dir) => {
    const dirPath = resolve(srcDir, dir);
    if (existsSync(dirPath)) {
      foundDirs.push(dir);
      print("green", `   ✅ src/${dir}/ exists`);
    }
  });

  if (foundDirs.length === 0) {
    print("yellow", "   ⚠️  src/ directory is empty (no skills, agents, tools, or commands)");
    errors.push("src/ directory is empty");
    return { valid: false, errors };
  }

  // Validate install.ts if present
  const installTsPath = resolve(srcDir, "install.ts");
  if (existsSync(installTsPath)) {
    print("green", `   ✅ src/install.ts exists`);
    const installContent = readFile(installTsPath);
    if (installContent && !installContent.includes("#!/usr/bin/env bun")) {
      print("yellow", "   ⚠️  install.ts should start with #!/usr/bin/env bun");
      errors.push("install.ts missing Bun shebang");
    }
  }

  return { valid: true, errors };
}

/**
 * Validate skill format
 */
function validateSkill(skillPath: string): boolean {
  const skillName = skillPath.split("\\").pop() || "unknown";

  // Check SKILL.md exists
  const skillMdPath = resolve(skillPath, "SKILL.md");
  if (!existsSync(skillMdPath)) {
    print("yellow", `      ⚠️  ${skillName}/SKILL.md not found`);
    return false;
  }

  // Check format
  const content = readFile(skillMdPath);
  if (!content) {
    print("yellow", `      ❌ Cannot read ${skillName}/SKILL.md`);
    return false;
  }

  // Check for YAML frontmatter
  const hasFrontmatter = content.match(/^---[\s\S]*?---/);
  if (!hasFrontmatter) {
    print("yellow", `      ⚠️  ${skillName}/SKILL.md missing YAML frontmatter`);
    return false;
  }

  // Check for required fields
  const requiredFields = ["name:", "description:", "version:"];
  let valid = true;
  requiredFields.forEach((field) => {
    if (!content.includes(field)) {
      print("yellow", `      ⚠️  ${skillName}/SKILL.md missing field: ${field}`);
      valid = false;
    }
  });

  if (valid) {
    print("green", `      ✅ ${skillName}/SKILL.md is properly formatted`);
  }

  return valid;
}

/**
 * Validate agent format
 */
function validateAgent(agentPath: string): boolean {
  const agentName = agentPath.split("\\").pop() || "unknown";

  // Check if .md file
  if (!agentPath.endsWith(".md")) {
    return true; // Skip non-md files
  }

  const content = readFile(agentPath);
  if (!content) {
    print("yellow", `      ❌ Cannot read ${agentName}`);
    return false;
  }

  // Check for YAML frontmatter
  const hasFrontmatter = content.match(/^---[\s\S]*?---/);
  if (!hasFrontmatter) {
    print("yellow", `      ⚠️  ${agentName} missing YAML frontmatter`);
    return false;
  }

  // Check for required fields
  const requiredFields = ["name:", "description:", "instruction:"];
  let valid = true;
  requiredFields.forEach((field) => {
    if (!content.includes(field)) {
      print("yellow", `      ⚠️  ${agentName} missing field: ${field}`);
      valid = false;
    }
  });

  if (valid) {
    print("green", `      ✅ ${agentName} is properly formatted`);
  }

  return valid;
}

/**
 * Validate content in src/ directories
 */
function validateContent(packDir: string): { valid: boolean; warnings: string[] } {
  print("cyan", "📄 Checking content files...");

  const srcDir = resolve(packDir, "src");
  const warnings: string[] = [];
  let valid = true;

  // Validate skills
  const skillsDir = resolve(srcDir, "skills");
  if (existsSync(skillsDir)) {
    const skills = readdirSync(skillsDir);
    print("gray", "   Skills:");
    skills.forEach((skill) => {
      const skillPath = resolve(skillsDir, skill);
      if (lstatSync(skillPath).isDirectory()) {
        const skillValid = validateSkill(skillPath);
        if (!skillValid) {
          valid = false;
        }
      }
    });
  }

  // Validate agents
  const agentsDir = resolve(srcDir, "agents");
  if (existsSync(agentsDir)) {
    const agents = readdirSync(agentsDir);
    print("gray", "   Agents:");
    agents.forEach((agent) => {
      const agentPath = resolve(agentsDir, agent);
      if (
        lstatSync(agentPath).isFile() &&
        agentPath.endsWith(".md")
      ) {
        const agentValid = validateAgent(agentPath);
        if (!agentValid) {
          valid = false;
        }
      }
    });
  }

  return { valid, warnings };
}

/**
 * Check for Windows-specific issues
 */
function validateWindowsCompatibility(packDir: string): { valid: boolean; warnings: string[] } {
  print("cyan", "🪟 Checking Windows compatibility...");

  const srcDir = resolve(packDir, "src");
  const warnings: string[] = [];
  let valid = true;

  // Check all files in src/
  function checkDir(dirPath: string) {
    if (!existsSync(dirPath)) {
      return;
    }

    const items = readdirSync(dirPath);
    items.forEach((item) => {
      const itemPath = resolve(dirPath, item);
      const stat = lstatSync(itemPath);

      if (stat.isDirectory()) {
        checkDir(itemPath);
      } else if (stat.isFile() && item.endsWith(".md")) {
        const content = readFile(itemPath);
        if (content) {
          // Check for hard-coded Windows paths (should use env vars)
          if (content.match(/C:\\Users\\[^\s]+\\.claude/g)) {
            print(
              "yellow",
              `      ⚠️  ${item}: Contains hard-coded Windows path (use $PAI_DIR or ${env}:.claude)`
            );
            warnings.push(`${item}: Hard-coded Windows path`);
            valid = false;
          }

          // Check for bash commands (should use PowerShell or Bun)
          if (content.includes("chmod") && !content.includes("PowerShell")) {
            print("yellow", `      ⚠️  ${item}: Contains bash 'chmod' (use PowerShell)`);
            warnings.push(`${item}: Bash commands present (chmod)`);
            valid = false;
          }
        }
      }
    });
  }

  checkDir(srcDir);

  if (valid) {
    print("green", "   ✅ Pack appears Windows-compatible");
  }

  return { valid, warnings };
}

/**
 * Validate a single pack
 */
function validatePack(packName: string): {
  valid: boolean;
  errors: string[];
  warnings: string[];
} {
  const packDir = resolve(PACKS_DIR, packName);
  const errors: string[] = [];
  const warnings: string[] = [];
  let valid = true;

  printHeader(`Validating Pack: ${packName}`);

  // 1. Check pack directory exists
  if (!existsSync(packDir)) {
    print("red", `❌ Pack not found: ${packDir}`);
    return { valid: false, errors: ["Pack not found"], warnings };
  }

  print("gray", `   Location: ${packDir}`);

  // 2. Check required files
  print("cyan", "📋 Checking required files...");
  REQUIRED_FILES.root.forEach((file) => {
    const filePath = resolve(packDir, file);
    if (!existsSync(filePath)) {
      print("red", `   ❌ Missing required file: ${file}`);
      errors.push(`Missing ${file}`);
      valid = false;
    } else {
      print("green", `   ✅ ${file} exists`);
    }
  });

  // 3. Check src/ directory
  const srcValidation = validateSrcDir(packDir);
  if (!srcValidation.valid) {
    valid = false;
  }
  errors.push(...srcValidation.errors);

  // 4. Validate documentation
  const readmeValidation = validateReadme(packDir);
  if (!readmeValidation.valid) {
    warnings.push(...readmeValidation.errors);
  }

  const installValidation = validateInstall(packDir);
  if (!installValidation.valid) {
    valid = false;
  }
  errors.push(...installValidation.errors);

  const verifyValidation = validateVerify(packDir);
  if (!verifyValidation.valid) {
    valid = false;
  }
  errors.push(...verifyValidation.errors);

  // 5. Validate content
  const contentValidation = validateContent(packDir);
  if (!contentValidation.valid) {
    valid = false;
  }
  warnings.push(...contentValidation.warnings);

  // 6. Check Windows compatibility
  const windowsValidation = validateWindowsCompatibility(packDir);
  if (!windowsValidation.valid) {
    warnings.push(...windowsValidation.warnings);
  }

  return { valid, errors, warnings };
}

/**
 * Validate all packs
 */
function validateAllPacks(): {
  valid: boolean;
  results: Array<{
    packName: string;
    valid: boolean;
    errors: string[];
    warnings: string[];
  }>;
} {
  const results: {
    packName: string;
    valid: boolean;
    errors: string[];
    warnings: string[];
  }[] = [];

  if (!existsSync(PACKS_DIR)) {
    print("red", `❌ Packs directory not found: ${PACKS_DIR}`);
    return { valid: false, results };
  }

  const packs = readdirSync(PACKS_DIR).filter(
    (item) =>
      lstatSync(resolve(PACKS_DIR, item)).isDirectory() && !item.startsWith(".")
  );

  print("cyan", `Found ${packs.length} packs to validate\n`);

  packs.forEach((packName) => {
    const result = validatePack(packName);
    results.push(result);
  });

  const overallValid = results.every((r) => r.valid);
  return { valid: overallValid, results };
}

/**
 * Main function
 */
function main() {
  const args = process.argv.slice(2);

  printHeader("PAI Pack Validator - Windows Edition");

  let valid = true;
  let results:
    | {
        packName: string;
        valid: boolean;
        errors: string[];
        warnings: string[];
      }[];
  let totalErrors = 0;
  let totalWarnings = 0;

  if (args.includes("--all")) {
    // Validate all packs
    const allResults = validateAllPacks();
    valid = allResults.valid;
    results = allResults.results;

    if (results) {
      results.forEach((r) => {
        totalErrors += r.errors.length;
        totalWarnings += r.warnings.length;
      });
    }
  } else if (args.length > 0 && !args[0].startsWith("-")) {
    // Validate specific pack
    const result = validatePack(args[0]);
    valid = result.valid;
    results = [result];

    totalErrors = result.errors.length;
    totalWarnings = result.warnings.length;
  } else {
    print("yellow", "Usage:");
    print(
      "gray",
      "  bun run Tools/validate-pack.ts [pack-name]    # Validate specific pack"
    );
    print("gray", "  bun run Tools/validate-pack.ts --all              # Validate all packs");
    print("gray", "  bun run Tools/validate-pack.ts                    # Show usage");
    process.exit(0);
  }

  // Print summary
  printHeader("Validation Summary");

  if (valid) {
    print("green", "   ✅ All required checks passed!");
  } else {
    print("red", "   ❌ Some packs have errors that must be fixed");
  }

  print(
    "yellow",
    `   ⚠️  ${totalWarnings} warning${totalWarnings !== 1 ? "s" : ""} found`
  );

  if (results) {
    print("cyan", "\n   Results by pack:");
    results.forEach((r) => {
      if (r.valid) {
        print("green", `      ✅ ${r.packName}`);
      } else {
        print("red", `      ❌ ${r.packName} (${r.errors.length} errors)`);
      }

      if (r.warnings.length > 0) {
        print("gray", `         ${r.warnings.length} warning${r.warnings.length !== 1 ? "s" : ""}`);
      }
    });
  }

  // Exit with appropriate code
  process.exit(valid ? 0 : 1);
}

// Run main function
main();
