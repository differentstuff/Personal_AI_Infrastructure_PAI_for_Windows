# Skill System Guide

**How to create, use, and manage skills in PAI**

---

## What is a Skill?

A **skill** is a self-contained folder that teaches the AI assistant how to perform a specific task or domain of work.

Think of skills as **plugins** or **apps** for your AI assistant.

### Anatomy of a Skill

```
skills/
└── MySkill/
    ├── SKILL.md          # Main skill definition (REQUIRED)
    ├── README.md         # Human-readable documentation
    ├── workflows/        # Step-by-step procedures
    │   ├── workflow1.md
    │   └── workflow2.md
    ├── tools/            # Scripts and utilities
    │   ├── tool1.ps1
    │   └── tool2.py
    └── resources/        # Reference materials
        ├── examples/
        └── templates/
```

---

## SKILL.md Format

Every skill MUST have a `SKILL.md` file with this structure:

```markdown
---
name: skill-name
description: Clear description of what this skill does and when to use it
version: 1.0.0
author: Your Name
tags: [tag1, tag2, tag3]
dependencies: []
platform: windows
---

# Skill Name

## Overview

Brief explanation of what this skill does.

## When to Use

Clear triggers for when this skill should be activated:
- User asks about [topic]
- User needs to [action]
- Task involves [domain]

## How It Works

Explain the skill's approach and methodology.

## Workflows

List available workflows:
1. **workflow-name** - What it does
2. **another-workflow** - What it does

## Examples

### Example 1: Basic Usage
\```
User: "Can you help me with X?"
Assistant: [Uses this skill to...]
\```

### Example 2: Advanced Usage
\```
User: "I need to do Y"
Assistant: [Applies workflow...]
\```

## Guidelines

- Guideline 1
- Guideline 2
- Guideline 3

## Tools

Available tools in `tools/` directory:
- **tool1.ps1** - Description
- **tool2.py** - Description

## Resources

- Link to documentation
- External references
- Related skills

---

**Version**: 1.0.0  
**Last Updated**: 2025-12-13
```

---

## Creating a New Skill

### Method 1: Using the Template

```powershell
# Copy the template
Copy-Item -Recurse skills\template-skill skills\MySkill

# Edit SKILL.md
code skills\MySkill\SKILL.md
```

### Method 2: Using the Tool (Coming Soon)

```powershell
.\tools\New-Skill.ps1 -Name "MySkill" -Description "What it does"
```

---

## Skill Discovery

The AI assistant discovers skills by:

1. **Reading `skills/` directory** at startup
2. **Parsing SKILL.md frontmatter** for metadata
3. **Building an index** of available skills
4. **Matching user intent** to skill descriptions

### Skill Index Structure

```json
{
  "skills": [
    {
      "name": "Research",
      "description": "Multi-source research workflows",
      "tags": ["research", "analysis", "sources"],
      "triggers": ["research", "investigate", "find information"],
      "path": "C:\\Users\\jean-\\.claude\\skills\\Research"
    }
  ]
}
```

---

## Skill Activation

Skills are activated when:

1. **User explicitly mentions skill name**
   - "Use the Research skill to..."
   - "Apply Fabric pattern..."

2. **User intent matches skill description**
   - User: "I need to research X" → Activates Research skill
   - User: "Analyze this code" → Activates Code Analysis skill

3. **Always-load skills** (defined in settings.json)
   - CORE skill is always active
   - Can configure others to auto-load

---

## Skill Types

### 1. Domain Skills
Encapsulate expertise in a specific domain.

**Examples**: Research, Writing, Coding, Data Analysis

### 2. Tool Skills
Wrap external tools or APIs.

**Examples**: Fabric (patterns), BrightData (scraping), GitHub (API)

### 3. Workflow Skills
Define repeatable processes.

**Examples**: Project Setup, Documentation Generation, Testing

### 4. Meta Skills
Skills that create or manage other skills.

**Examples**: CreateSkill, SkillTester, SkillUpdater

---

## Best Practices

### 1. Single Responsibility
Each skill should do ONE thing well.

❌ Bad: "GeneralPurpose" skill that does everything  
✅ Good: "Research" skill focused on research workflows

### 2. Clear Triggers
Make it obvious when the skill should activate.

❌ Bad: "This skill helps with stuff"  
✅ Good: "Use when user needs to research topics using multiple sources"

### 3. Self-Contained
Skills should include everything they need.

✅ Include:
- Documentation
- Tools/scripts
- Examples
- Templates

❌ Don't:
- Depend on external files outside the skill folder
- Require manual setup (automate it)

### 4. Versioned
Track skill versions for updates and compatibility.

```yaml
version: 1.2.0
changelog:
  - 1.2.0: Added new workflow
  - 1.1.0: Improved error handling
  - 1.0.0: Initial release
```

### 5. Tested
Include tests or evals for skill quality.

```
skills/MySkill/
└── tests/
    ├── test-workflow1.ps1
    └── expected-outputs/
```

---

## Skill Composition

Skills can work together:

### Sequential Composition
One skill's output feeds into another.

```
Research skill → Analysis skill → Report skill
```

### Parallel Composition
Multiple skills work simultaneously.

```
    ┌─ Skill A ─┐
    │           │
Input ─┼─ Skill B ─┼─ Combine → Output
    │           │
    └─ Skill C ─┘
```

### Hierarchical Composition
Parent skill delegates to child skills.

```
Project Setup (parent)
  ├─ Git Init (child)
  ├─ Create Structure (child)
  └─ Install Dependencies (child)
```

---

## Skill Lifecycle

1. **Creation**: Build skill folder and SKILL.md
2. **Testing**: Verify skill works as expected
3. **Activation**: AI assistant discovers and loads skill
4. **Usage**: Skill activated based on user intent
5. **Evolution**: Skill improves based on feedback
6. **Maintenance**: Updates and bug fixes

---

## Common Patterns

### Pattern 1: Workflow Skill

```markdown
---
name: research-workflow
description: Multi-step research process with source validation
---

# Research Workflow

## Steps

1. **Define Question**
2. **Identify Sources**
3. **Gather Information**
4. **Validate Facts**
5. **Synthesize Findings**
6. **Document Results**

[Detailed steps...]
```

### Pattern 2: Tool Wrapper Skill

```markdown
---
name: fabric-patterns
description: Access to Daniel Miessler's Fabric AI patterns
---

# Fabric Patterns

## Available Patterns

- extract_wisdom
- summarize
- create_threat_model
[...]

## Usage

\```powershell
.\tools\run-pattern.ps1 -Pattern "extract_wisdom" -Input "text"
\```
```

### Pattern 3: Meta Skill

```markdown
---
name: create-skill
description: Generates new skill scaffolding from template
---

# Create Skill

## Usage

\```powershell
.\tools\New-Skill.ps1 -Name "MySkill"
\```

Creates:
- Skill folder
- SKILL.md from template
- Basic structure
```

---

## Advanced Topics

### Dynamic Skill Loading
Skills can be loaded on-demand rather than at startup.

### Skill Dependencies
Skills can depend on other skills.

```yaml
dependencies:
  - name: CORE
    version: ">=1.0.0"
  - name: Research
    version: ">=2.0.0"
```

### Skill Contexts
Skills can maintain state across invocations.

### Skill Permissions
Control what skills can access (files, network, etc.)

---

## Troubleshooting

### Skill Not Activating

1. Check `SKILL.md` frontmatter is valid YAML
2. Verify skill is in `skills/` directory
3. Ensure description clearly indicates use cases
4. Check skill index: `.\tools\Get-SkillIndex.ps1`

### Skill Conflicts

If multiple skills match user intent:
1. AI will ask for clarification
2. Or use most specific match
3. Or use priority system (in settings.json)

---

## Next Steps

1. **Study existing skills** in `skills/` directory
2. **Use the template** to create your first skill
3. **Test thoroughly** before relying on it
4. **Document learnings** for future improvements

---

**Remember**: Skills are how PAI scales. Each new domain gets its own skill, maintaining organization as the system grows.
