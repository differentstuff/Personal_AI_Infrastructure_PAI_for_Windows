# Templates System

**Status**: 🚧 Placeholder - Coming in future version

## What Are Templates?

Templates are **meta-prompting structures** with variable substitution, inspired by Daniel Miessler's templating system. Think "Fabric, but with variables."

## Planned Features

### Variable Substitution
```markdown
Hello {{USER_NAME}}, today is {{CURRENT_DATE}}.

Your task: {{TASK_DESCRIPTION}}
```

### Template Types

| Type | Purpose | Example |
|------|---------|---------|
| **Analysis** | Structured analysis | Market analysis, code review |
| **Research** | Research workflows | Literature review, investigation |
| **Creation** | Content generation | Blog posts, documentation |
| **Workflow** | Process automation | Deploy pipeline, testing |

### How They'll Work

1. **Create template** with variables
2. **AI detects template need** from context
3. **Substitute variables** with current values
4. **Execute templated prompt**
5. **Return formatted results**

## Example Template

```markdown
---
name: code-review
description: Comprehensive code review template
variables: [LANGUAGE, CODE, FOCUS_AREA]
---

# Code Review: {{LANGUAGE}}

## Code to Review
{{CODE}}

## Focus Area
{{FOCUS_AREA}}

## Analysis

1. **Correctness**: Does it work as intended?
2. **Performance**: Are there bottlenecks?
3. **Security**: Any vulnerabilities?
4. **Maintainability**: Is it readable and documented?
5. **Best Practices**: Does it follow {{LANGUAGE}} conventions?

## Recommendations

[Provide specific, actionable improvements]
```

## Configuration

Will be configured in `settings.json`:
```json
{
  "meta_prompting": {
    "enabled": true,
    "template_variables": {
      "USER_NAME": "{{identity.user_name}}",
      "CURRENT_DATE": "{{date.now}}",
      "TIMEZONE": "{{preferences.timezone}}"
    }
  }
}
```

## Future Implementation

When ready, templates will:
- Support Jinja2-style syntax
- Allow nested templates
- Enable template chaining
- Provide template library
- Support custom functions

---

**For now**: This directory is a placeholder. Templates will be added in a future version.

**Want to help design it?** Share your ideal template use cases!
