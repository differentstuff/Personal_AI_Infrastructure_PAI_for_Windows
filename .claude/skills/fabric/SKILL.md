---
Name: fabric
Description: Daniel Miessler's Fabric pattern system for AI prompting
Version: 1.0.0
Author: Daniel Miessler (integration by PAI)
Tags: [prompting, patterns, fabric, analysis]
Dependencies: [fabric-ai]
---

# Fabric Integration Skill

Integration with Daniel Miessler's [Fabric](https://github.com/danielmiessler/fabric) - a modular framework for solving specific problems using AI patterns.

## What is Fabric?

Fabric is a collection of **prompt patterns** (called "patterns") that solve specific problems:
- Extract wisdom from content
- Summarize meetings
- Create action items
- Analyze arguments
- Generate ideas
- And 50+ more patterns

## USE WHEN

- You need structured analysis of content
- You want to extract specific insights
- You're processing text/articles/transcripts
- You need consistent output formats
- You want proven prompt patterns

## INSTALLATION

```powershell
# Install fabric CLI
pip install fabric-ai

# Or with pipx (recommended)
pipx install fabric-ai

# Verify installation
fabric --version

# Setup (configure API keys)
fabric --setup
```

## USAGE

### Via AI Assistant

Just ask naturally:
- *"Extract wisdom from this article"*
- *"Summarize this meeting transcript"*
- *"Create action items from this discussion"*
- *"Analyze the argument in this text"*

The AI will automatically use the appropriate Fabric pattern.

### Direct CLI

```powershell
# Extract wisdom from a URL
fabric --pattern extract_wisdom --url https://example.com/article

# Summarize text from clipboard
fabric --pattern summarize | clip

# Create action items from file
Get-Content meeting.txt | fabric --pattern create_action_items

# List all patterns
fabric --listpatterns

# Get pattern details
fabric --pattern extract_wisdom --help
```

## AVAILABLE PATTERNS

### Analysis
- `extract_wisdom` - Extract key insights and wisdom
- `analyze_claims` - Evaluate truth claims
- `analyze_paper` - Summarize academic papers
- `analyze_presentation` - Break down presentations
- `check_agreement` - Find consensus and disagreement

### Summarization
- `summarize` - General summarization
- `summarize_meeting` - Meeting notes
- `summarize_newsletter` - Newsletter digest
- `create_summary` - Structured summary

### Action
- `create_action_items` - Extract actionable tasks
- `create_quiz` - Generate quiz questions
- `create_micro_summary` - Ultra-brief summary
- `create_keynote` - Generate presentation outline

### Writing
- `improve_writing` - Enhance text quality
- `write_essay` - Essay structure
- `write_micro_essay` - Short-form essay
- `explain_terms` - Define technical terms

### Creativity
- `create_idea_compass` - Explore ideas from multiple angles
- `create_visualization` - Suggest data visualizations
- `create_pattern` - Generate new patterns
- `extract_extraordinary_claims` - Find surprising ideas

### Technical
- `create_command` - Generate CLI commands
- `create_coding_project` - Project structure
- `explain_code` - Code explanation
- `review_code` - Code review

## INTEGRATION WITH PAI

The AI assistant automatically recognizes Fabric pattern requests and:
1. **Detects pattern intent** from your natural language
2. **Maps to appropriate pattern** (e.g., "extract wisdom" → `extract_wisdom`)
3. **Processes content** using Fabric
4. **Returns formatted results**

## EXAMPLES

### Extract Wisdom
```
User: Extract wisdom from this article about AI safety

AI: [Uses fabric --pattern extract_wisdom]
Returns:
- Key insights
- Quotes
- Recommendations
- References
```

### Summarize Meeting
```
User: Summarize this meeting transcript

AI: [Uses fabric --pattern summarize_meeting]
Returns:
- Main topics
- Decisions made
- Action items
- Participants
```

### Create Action Items
```
User: What are the action items from this discussion?

AI: [Uses fabric --pattern create_action_items]
Returns:
- Numbered action items
- Owners
- Deadlines
- Priority
```

## CONFIGURATION

In `settings.json`:
```json
{
  "integrations": {
    "fabric": {
      "enabled": true,
      "patterns_path": "${PAI_ROOT}/skills/fabric/patterns",
      "default_model": "gpt-4",
      "custom_patterns": []
    }
  }
}
```

## CUSTOM PATTERNS

You can create your own patterns:

1. **Create pattern directory**:
   ```powershell
   mkdir skills/fabric/patterns/my_pattern
   ```

2. **Create pattern file** (`system.md`):
   ```markdown
   # IDENTITY
   You are an expert at [specific task]
   
   # GOALS
   - Goal 1
   - Goal 2
   
   # STEPS
   1. Step 1
   2. Step 2
   
   # OUTPUT FORMAT
   [Specify format]
   ```

3. **Use it**:
   ```powershell
   fabric --pattern my_pattern
   ```

## RESOURCES

- [Fabric GitHub](https://github.com/danielmiessler/fabric)
- [Pattern Library](https://github.com/danielmiessler/fabric/tree/main/patterns)
- [Documentation](https://github.com/danielmiessler/fabric#readme)
- [Daniel's Blog](https://danielmiessler.com/)

## TIPS

✅ **DO:**
- Use patterns for repetitive analysis tasks
- Combine patterns (e.g., summarize → action items)
- Create custom patterns for your workflows
- Share useful patterns with the community

❌ **DON'T:**
- Use patterns for simple questions (overkill)
- Assume patterns work for every content type
- Forget to update fabric regularly (`pip install -U fabric-ai`)

## TROUBLESHOOTING

**Pattern not found:**
```powershell
# Update fabric
pip install -U fabric-ai

# List available patterns
fabric --listpatterns
```

**API errors:**
```powershell
# Reconfigure
fabric --setup

# Check API key in .env
echo $env:ANTHROPIC_API_KEY
```

**Performance issues:**
```powershell
# Use faster model
fabric --pattern extract_wisdom --model gpt-3.5-turbo
```

---

## INTEGRATION STATUS

✅ Fabric CLI integration ready  
✅ Pattern detection in natural language  
✅ Cross-platform support (Windows/Linux)  
⏳ Custom pattern library (coming soon)  
⏳ Pattern chaining (coming soon)
