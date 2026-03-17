# memory-bank

A persistent knowledge memory system for AI coding agents. Stores and retrieves useful discoveries, patterns, architecture decisions, and debugging solutions across sessions.

## The Problem

Your AI agent's context window is like RAM -- volatile and limited. Every new session starts from scratch. Knowledge discovered during one session (bug fixes, architecture insights, code patterns) is lost forever.

## The Solution

`memory-bank` gives your agent a persistent `.memory/` directory in each project -- like a disk for its brain.

```
Your brain (context window) = RAM -- volatile, limited
.memory/ directory           = Disk -- persistent, searchable

→ Anything worth remembering goes into .memory/
```

## Design Philosophy

### Memory Lifecycle

Knowledge flows through a structured pipeline, not dumped randomly:

```
Discovery → Evaluate → Categorize → Write → Index → Recall → Update
```

1. **Discovery** -- Knowledge emerges naturally during work: debugging a tricky bug, understanding how components connect, learning a library's undocumented behavior
2. **Evaluate** -- Not everything is worth saving. The core question: *"Will I need this again?"*
3. **Categorize** -- Route knowledge to the right domain (see categories below)
4. **Write** -- Structured entries with summary, details, code examples, and tags
5. **Index** -- Every entry is registered in a master index for fast lookup
6. **Recall** -- At session start or on demand, load relevant prior knowledge
7. **Update** -- Knowledge evolves; entries get refined as understanding deepens

### What to Remember (and What Not To)

The skill is selective by design. Quality over quantity.

**Save if:**
- It took significant effort to figure out
- It's non-obvious or counterintuitive
- It's project-specific context that's hard to rediscover
- It records *why* something was done, not just *what*

**Skip if:**
- It's easily found in official docs
- It's a one-off fix that won't recur
- It's common general programming knowledge
- It contains secrets or credentials (NEVER save these)

### Knowledge Quality Rules

These rules are baked into the skill's instructions so the agent follows them automatically:

**1. Be specific, not generic**
```
Bad:  "Error handling is important"
Good: "ToolExecutor wraps all errors into ToolResult with isError: true.
       Tool execute() functions should try/catch with err: any and
       return JSON.stringify({ success: false, error: err.message })"
```

**2. Record the "Why", not just the "What"**
```
Bad:  "Use ESM imports"
Good: "Use ESM imports with .js extensions because the project is ESM-only
       (type: module in package.json). TypeScript compiles .ts to .js but
       doesn't rewrite import paths, so source must use .js extensions."
```

**3. Include code examples** -- Abstract descriptions are forgettable. Concrete code sticks.

**4. Keep entries focused** -- One topic per entry. If a file covers too many things, split it.

**5. Cross-reference related entries** -- Build a knowledge graph, not isolated notes.

### Categorized Storage

Knowledge is organized into 8 domain-specific categories, each answering a different question:

```
"How do components connect?"       → architecture/
"What code conventions do we use?" → patterns/
"How did I fix this bug?"          → debugging/
"What does this API expect?"       → api/
"Why did we choose X over Y?"      → decisions/
"What's tricky about library X?"   → dependencies/
"How do I build/deploy/test?"      → workflows/
"What does this domain term mean?" → context/
```

This structure prevents the "junk drawer" problem -- knowledge has a clear home, making it findable across sessions.

### Structured Entry Format

Every memory entry follows a consistent template:

```markdown
# [Title]

> **Category:** [category]
> **Created:** [YYYY-MM-DD]
> **Last Updated:** [YYYY-MM-DD]
> **Tags:** [tag1, tag2, tag3]
> **Confidence:** [high | medium | low]

## Summary
[1-2 sentence distilled summary]

## Details
[Full explanation with code examples]

## Related
- [Links to related memory entries]
```

The **Confidence** field tracks how verified the knowledge is -- entries start at `low` or `medium` and graduate to `high` as they're validated through use.

### Auto-triggered Hooks

The skill integrates into the agent's workflow through lifecycle hooks:

- **Session start**: Reads `.memory/index.md` if it exists, loading prior context automatically
- **After file edits**: Reminds the agent to consider saving discoveries
- **Session end**: Prompts to review if any new knowledge should be saved

This means the agent doesn't need to be told to use memory -- it's part of the natural workflow.

## Install

### One-line install (recommended)

```bash
# Install to both OpenCode and Claude Code
curl -fsSL https://raw.githubusercontent.com/<user>/memory-bank/main/install.sh | bash

# Install to OpenCode only
INSTALL_TARGET=opencode curl -fsSL https://raw.githubusercontent.com/<user>/memory-bank/main/install.sh | bash

# Install to Claude Code only
INSTALL_TARGET=claude curl -fsSL https://raw.githubusercontent.com/<user>/memory-bank/main/install.sh | bash
```

### Manual install

Clone the repo and copy the skill to your agent's skill directory:

```bash
git clone https://github.com/<user>/memory-bank.git

# For OpenCode
cp -r memory-bank ~/.config/opencode/skills/memory-bank

# For Claude Code
cp -r memory-bank ~/.claude/skills/memory-bank
```

### Verify installation

After installing, start a new agent session. You should see the skill listed in the available skills. Type `/memory-bank` to confirm it's working.

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `/memory-bank` | Show help and current status |
| `/memory-bank init` | Initialize `.memory/` directory for current project |
| `/memory-bank save <category/title>` | Save a new memory entry |
| `/memory-bank recall <query>` | Search and load relevant memories |
| `/memory-bank recall all` | Load the full index |
| `/memory-bank list` | List all memory entries |
| `/memory-bank stats` | Show memory bank statistics |

### Example workflow

```
# 1. Initialize memory bank for your project
/memory-bank init

# 2. While working, the agent discovers a tricky bug fix
#    and saves it automatically (or you ask it to)
/memory-bank save debugging/webpack-hmr-fix

# 3. Next session, the agent loads the index at startup
#    and can recall specific knowledge on demand
/memory-bank recall webpack
```

### What gets generated

After initialization, your project gets a `.memory/` directory:

```
.memory/
├── index.md              # Master index of all memories
├── architecture/         # System design, component relationships
├── patterns/             # Code conventions, idioms
├── debugging/            # Bug solutions, troubleshooting
├── api/                  # Endpoint contracts, payload formats
├── decisions/            # Architecture Decision Records (ADRs)
├── dependencies/         # Library tips, version quirks
├── workflows/            # Build, deploy, test procedures
└── context/              # Domain knowledge, business logic
```

## Project structure

```
memory-bank/
├── SKILL.md               # Skill definition (frontmatter + full instructions)
├── reference.md           # Best practices and naming conventions
├── templates/
│   ├── index.md           # Memory bank index template
│   ├── entry.md           # Knowledge entry template
│   └── decision.md        # Architecture Decision Record template
├── scripts/
│   ├── init-memory.sh     # Initialize .memory/ directory
│   ├── search-memory.sh   # Search memories by keyword
│   └── memory-stats.sh    # Show memory bank statistics
├── install.sh             # One-line installer
├── LICENSE                # MIT License
└── README.md              # This file
```

## Compatibility

- [OpenCode](https://opencode.ai) -- via `~/.config/opencode/skills/memory-bank/`
- [Claude Code](https://claude.ai) -- via `~/.claude/skills/memory-bank/`
- Any agent supporting the `SKILL.md` convention

All data stays local in your project. No cloud, no sync, no external services.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

[MIT](LICENSE)
