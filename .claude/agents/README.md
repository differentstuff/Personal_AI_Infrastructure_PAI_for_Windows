# Agents System

Agents are **personality presets** that optimize the AI for specific tasks. Think of them as "modes" or "hats" the assistant wears.

## How It Works

1. **Agent files** contain specialized system prompts
2. **User activates** by saying: *"Use the engineer agent"*
3. **AI loads** the agent's context and behavior
4. **Continues** until user switches agents

## Available Agents

| Agent | Purpose | Best For |
|-------|---------|----------|
| **assistant** | General purpose, balanced | Daily tasks, mixed work |
| **engineer** | Technical depth, code-focused | Programming, debugging, architecture |
| **researcher** | Deep analysis, citations | Investigation, learning, documentation |

## Creating Custom Agents

1. Copy `template-agent.md`
2. Rename to `your-agent.md`
3. Customize the prompt sections
4. AI automatically discovers it!

## Agent Structure

Each agent file contains:

```markdown
# Agent Name

**Role**: One-line description
**Personality**: Key traits
**Strengths**: What this agent excels at
**Use When**: Situations to activate

## System Prompt

[Detailed instructions for the AI]

## Example Interactions

[Show how this agent behaves]
```

## Switching Agents

Just tell the AI:
- *"Use the engineer agent"*
- *"Switch to researcher mode"*
- *"Act as the assistant agent"*

The AI will load the appropriate personality and context.

## Tips

- **Be specific**: Agents work best for focused tasks
- **Mix and match**: Switch agents mid-conversation
- **Create your own**: Tailor agents to your workflow
- **Share**: Contribute useful agents back to the community

---

**Pro Tip**: Create agents for your common workflows (e.g., "writer", "analyst", "debugger") to speed up context switching.
