---
name: memory-bank
version: "1.0.0"
description: "Project-level knowledge memory system. Stores and retrieves useful knowledge discovered during task execution into .memory/ directory. Use when you discover important patterns, architecture decisions, debugging solutions, or any reusable knowledge. Also use at session start to recall prior knowledge, or invoke with /memory-bank."
license: MIT
compatibility: opencode
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
hooks:
  SessionStart:
    - hooks:
        - type: command
          command: |
            if [ -d ".memory" ] && [ -f ".memory/index.md" ]; then
              echo "[memory-bank] Existing memory bank detected. Reading index..."
              cat .memory/index.md
            else
              echo "[memory-bank] No memory bank found for this project. Use /memory-bank to initialize, or it will auto-initialize when you save your first memory."
            fi
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "echo '[memory-bank] File modified. If you discovered something reusable (pattern, gotcha, decision rationale), consider saving it to memory.'"
  Stop:
    - hooks:
        - type: command
          command: |
            if [ -d ".memory" ]; then
              echo "[memory-bank] Session ending. Review if any new knowledge should be saved."
              echo "Quick stats:"
              find .memory -name "*.md" ! -name "index.md" 2>/dev/null | wc -l | xargs echo "  Total memory entries:"
              ls .memory/ 2>/dev/null | grep -v index.md | grep -v "^$" | xargs echo "  Categories:" 2>/dev/null || echo "  Categories: (none)"
            fi
---

# Memory Bank

A project-level knowledge memory system that persists useful discoveries, patterns, and decisions across sessions.

## Core Concept

```
Your brain (context window) = RAM — volatile, limited
.memory/ directory           = Disk — persistent, searchable

→ Anything worth remembering goes into .memory/
```

## Memory Bank Structure

All memory files live in the project's `.memory/` directory:

```
.memory/
├── index.md                    # Master index of all memories (auto-maintained)
├── architecture/               # System design, component relationships, data flow
│   ├── component-overview.md
│   └── data-flow.md
├── patterns/                   # Code patterns, conventions, idioms used in this project
│   ├── error-handling.md
│   └── naming-conventions.md
├── debugging/                  # Bug solutions, common errors, troubleshooting steps
│   ├── build-errors.md
│   └── runtime-gotchas.md
├── api/                        # API contracts, endpoints, payload formats
│   └── external-services.md
├── decisions/                  # Architecture Decision Records (ADRs)
│   └── 001-chose-esm.md
├── dependencies/               # Third-party library usage, version notes, quirks
│   └── playwright-tips.md
├── workflows/                  # Build, deploy, test workflows and commands
│   └── build-pipeline.md
└── context/                    # Project-specific context, business logic, domain knowledge
    └── domain-terms.md
```

## How to Use

### Invoking the Skill

- **Manual:** Type `/memory-bank` to open the memory management interface
- **With arguments:** `/memory-bank save patterns/streaming-pattern` or `/memory-bank recall architecture`
- **Auto-prompted:** After file modifications, you'll be reminded to save discoveries

### Commands (via $ARGUMENTS)

When invoked with `/memory-bank <command>`, the following commands are available:

| Command | Description | Example |
|---------|-------------|---------|
| `init` | Initialize .memory/ directory | `/memory-bank init` |
| `save <category/title>` | Save a new memory entry | `/memory-bank save patterns/react-loop` |
| `recall <query>` | Search and load relevant memories | `/memory-bank recall error handling` |
| `recall all` | Load the full index | `/memory-bank recall all` |
| `list` | List all memory entries | `/memory-bank list` |
| `stats` | Show memory bank statistics | `/memory-bank stats` |
| (no args) | Show help and current status | `/memory-bank` |

## Operations

### 1. Initialize Memory Bank

Before first use, create the `.memory/` directory structure:

```bash
mkdir -p .memory/{architecture,patterns,debugging,api,decisions,dependencies,workflows,context}
```

Then create `index.md` using [templates/index.md](templates/index.md).

> **Tip:** Add `.memory/` to `.gitignore` if you don't want to track memories in version control, or commit them if you want to share knowledge across the team.

### 2. Save a Memory

When you discover something worth remembering:

1. **Decide the category** — Which domain does this knowledge belong to?
2. **Create or update the file** — Use [templates/entry.md](templates/entry.md) as the format
3. **Update the index** — Add an entry to `.memory/index.md`

#### Memory Entry Format

Every memory entry follows this structure:

```markdown
# [Title]

> **Category:** [category]
> **Created:** [YYYY-MM-DD]
> **Last Updated:** [YYYY-MM-DD]
> **Tags:** [tag1, tag2, tag3]

## Summary
[1-2 sentence summary of the knowledge]

## Details
[Full explanation, code examples, context]

## Related
- [Links to related memory entries]
```

### 3. Recall Memories

Before starting work or when you need context:

1. **Read the index** — `Read .memory/index.md` for an overview
2. **Search by category** — Browse `.memory/<category>/` for domain-specific knowledge
3. **Search by keyword** — Use Grep to find specific topics across all memories

### 4. Update Existing Memories

Knowledge evolves. When you learn something new about an existing topic:

1. Read the existing entry
2. Update/append the new information
3. Update the "Last Updated" date
4. Update the index if the summary changed

## When to Save Memories

### ALWAYS Save These:

| Discovery | Category | Why |
|-----------|----------|-----|
| How components connect | `architecture/` | Hard to rediscover, critical for understanding |
| Why a decision was made | `decisions/` | Rationale gets lost, prevents re-debating |
| Bug fix after long debugging | `debugging/` | Saves hours next time |
| Non-obvious API behavior | `api/` | Docs don't always cover edge cases |
| Project code conventions | `patterns/` | Consistency across sessions |
| Library gotchas | `dependencies/` | Version-specific quirks are easy to forget |
| Build/deploy steps | `workflows/` | Reproducibility |
| Domain-specific terms | `context/` | Business logic clarification |

### DON'T Save These:

- Trivial/obvious information (e.g., "JavaScript uses `const` for constants")
- Temporary debugging output
- Session-specific scratchpad notes (use `planning-with-files` for those)
- Secrets, API keys, credentials (NEVER)

## Knowledge Quality Rules

### 1. Be Specific, Not Generic
```
Bad:  "Error handling is important"
Good: "ToolExecutor wraps all errors into ToolResult with isError: true. 
       Tool execute() functions should try/catch with err: any and 
       return JSON.stringify({ success: false, error: err.message })"
```

### 2. Include Code Examples
Abstract descriptions are forgettable. Concrete code sticks.

### 3. Record the "Why", Not Just the "What"
```
Bad:  "Use ESM imports"
Good: "Use ESM imports with .js extensions because the project is ESM-only 
       (type: module in package.json). TypeScript compiles .ts to .js but 
       doesn't rewrite import paths, so source must use .js extensions."
```

### 4. Keep Entries Focused
One topic per entry. If a file covers too many things, split it.

### 5. Cross-Reference Related Entries
Use `## Related` section to link entries that inform each other.

## Index Maintenance

The `.memory/index.md` file is the master catalog. It must be kept in sync with actual files.

Format:
```markdown
# Memory Bank Index

## Categories

### architecture
- [component-overview](architecture/component-overview.md) — How major components connect
- [data-flow](architecture/data-flow.md) — Request lifecycle and data transformations

### patterns  
- [error-handling](patterns/error-handling.md) — Error handling conventions in this project
```

**Update the index every time you create, rename, or delete a memory entry.**

## Category Reference

| Category | What Goes Here | Examples |
|----------|---------------|----------|
| `architecture/` | System design, component maps, data flow | "How the ReAct loop works", "Tool loading pipeline" |
| `patterns/` | Code conventions, idioms, standard approaches | "Streaming pattern", "Error return format" |
| `debugging/` | Bug solutions, error resolutions, troubleshooting | "Fix: ENOENT on tool load", "Chrome CDP connection issues" |
| `api/` | Endpoint contracts, payload schemas, auth | "Anthropic streaming API format", "Tool call protocol" |
| `decisions/` | ADRs — why we chose X over Y | "Why Playwright over Puppeteer", "ESM-only rationale" |
| `dependencies/` | Library tips, version notes, migration | "Playwright CDP quirks", "tsup config gotchas" |
| `workflows/` | Build, test, deploy procedures | "Build pipeline steps", "Chrome debug launch" |
| `context/` | Domain knowledge, business logic, terminology | "Agent terminology", "Tool definition schema" |

## Custom Categories

You can create additional categories as needed. Just:
1. Create the directory: `mkdir -p .memory/<category-name>`
2. Add entries following the standard template
3. Add the category to the index

## Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Dump raw logs into memory | Distill the key insight, then save |
| Save without updating index | Always update `.memory/index.md` |
| Create vague entries ("misc notes") | Use specific titles and categories |
| Duplicate info across entries | Cross-reference with `## Related` links |
| Store secrets or credentials | Never save sensitive data |
| Forget to update stale entries | Review and update when knowledge changes |
| Save everything | Be selective — quality over quantity |

## Templates

- [templates/index.md](templates/index.md) — Master index template
- [templates/entry.md](templates/entry.md) — Memory entry template
- [templates/decision.md](templates/decision.md) — Architecture Decision Record template

## Scripts

- `scripts/init-memory.sh` — Initialize `.memory/` directory structure
- `scripts/search-memory.sh` — Search memories by keyword
- `scripts/memory-stats.sh` — Show memory bank statistics
