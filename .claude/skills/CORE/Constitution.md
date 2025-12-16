# PAI Constitution: The 13 Founding Principles

**The architectural philosophy for building reliable AI infrastructure**

---

## Principle 1: Clear Thinking + Prompting is King

The quality of outcomes depends on the quality of thinking and prompts.

**Why**: AI is a thinking amplifier. Garbage thinking in → garbage results out.

**In Practice**:
- Define the problem clearly before seeking solutions
- Structure prompts with clear context, task, and desired output
- Use frameworks (STAR, OODA, etc.) to organize thinking
- Iterate on prompts based on results

---

## Principle 2: Scaffolding > Model

System architecture matters more than the underlying AI model.

**Why**: A well-structured system with Haiku will outperform a chaotic system with Opus.

**In Practice**:
- Build clear interfaces between components
- Use modular design (skills, agents, hooks)
- Document system architecture
- Make components swappable

---

## Principle 3: As Deterministic as Possible

Favor predictable, repeatable outcomes over flexibility.

**Why**: Same input → Same output = Reliable system

**In Practice**:
- Use structured outputs (JSON, YAML)
- Minimize randomness in prompts
- Test for consistency
- Version control prompts and code

---

## Principle 4: Code Before Prompts

Write code to solve problems, use prompts to orchestrate code.

**Why**: Code is deterministic, testable, and reusable. Prompts are for high-level reasoning.

**In Practice**:
- Use PowerShell/Python for logic
- Use prompts for planning and coordination
- Don't ask AI to do what code can do better
- Build tools, then orchestrate them

---

## Principle 5: Spec / Test / Evals First

Define expected behavior before writing implementation.

**Why**: If you can't specify it, you can't test it. If you can't test it, you can't trust it.

**In Practice**:
- Write specs before code
- Create test cases upfront
- Build eval systems for AI outputs
- Measure quality objectively

---

## Principle 6: UNIX Philosophy

Do one thing well. Compose tools through standard interfaces.

**Why**: Small, focused tools are easier to understand, test, and reuse.

**In Practice**:
- Each skill does one thing
- Use standard input/output formats
- Compose skills for complex operations
- Avoid monolithic systems

---

## Principle 7: ENG / SRE Principles

Apply software engineering and site reliability practices to AI systems.

**Why**: AI infrastructure IS infrastructure. Treat it with engineering rigor.

**In Practice**:
- Use version control
- Implement logging and monitoring
- Plan for failure modes
- Document everything
- Use CI/CD for skills

---

## Principle 8: CLI as Interface

Every operation should be accessible via command line.

**Why**: If there's no CLI, you can't script it, test it, or automate it.

**In Practice**:
- PowerShell scripts for all operations
- No GUI-only features
- Scriptable workflows
- Automation-first design

---

## Principle 9: Goal → Code → CLI → Prompts → Agents

The proper development pipeline for any new feature.

**Why**: Each layer builds on the previous. Skip a layer = shaky system.

**In Practice**:
1. **Goal**: Define what you want to achieve
2. **Code**: Write deterministic logic
3. **CLI**: Create command-line interface
4. **Prompts**: Add AI orchestration
5. **Agents**: Wrap in agent personality

---

## Principle 10: Meta / Self Update System

The system should be able to improve itself.

**Why**: A system that can't update itself will stagnate.

**In Practice**:
- Skills can create skills
- Self-testing capabilities
- Automatic documentation
- Feedback loops for improvement

---

## Principle 11: Custom Skill Management

Skills are the organizational unit for all domain expertise.

**Why**: Skills provide structure as the system grows. Each domain gets its own container.

**In Practice**:
- Skills in `skills/` directory
- Each skill self-contained
- Clear skill discovery mechanism
- Easy skill creation process

---

## Principle 12: Custom History System

Automatic capture and preservation of valuable work.

**Why**: Memory makes intelligence compound. Without history, every session starts from zero.

**In Practice**:
- UOCS (Unobtrusive Continuous State)
- Automatic session logging
- Artifact preservation
- Searchable history

---

## Principle 13: Custom Agent Personalities

Specialized agents with distinct personalities for different tasks.

**Why**: Personality isn't decoration—it's functional. Different tasks require different approaches.

**In Practice**:
- Engineer: Precise, technical, systematic
- Researcher: Thorough, analytical, citation-focused
- Writer: Creative, narrative, audience-aware
- Switch agents based on task

---

## Applying the Principles

When building any feature:

1. **Think clearly** about the problem (Principle 1)
2. **Design the scaffolding** first (Principle 2)
3. **Write specs and tests** (Principle 5)
4. **Build deterministic code** (Principles 3, 4)
5. **Create CLI interface** (Principle 8)
6. **Add AI orchestration** (Principle 9)
7. **Document everything** (Principle 7)
8. **Enable self-improvement** (Principle 10)

---

**These principles are not suggestions—they are the foundation of reliable AI infrastructure.**
