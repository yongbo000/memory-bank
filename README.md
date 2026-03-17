# memory-bank

A persistent knowledge memory system for AI coding agents. Stores and retrieves useful discoveries, patterns, architecture decisions, and debugging solutions across sessions.

## The Problem

Your AI agent's context window is like RAM -- volatile and limited. Every new session starts from scratch. Knowledge discovered during one session (bug fixes, architecture insights, code patterns) is lost.

## The Solution

`memory-bank` gives your agent a persistent `.memory/` directory in each project -- like a disk for its brain. Anything worth remembering gets saved, categorized, and indexed for future recall.

```
Your brain (context window) = RAM -- volatile, limited
.memory/ directory           = Disk -- persistent, searchable
```

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

### Auto-triggers

- **Session start**: Automatically reads `.memory/index.md` if it exists
- **After file edits**: Reminds you to save discoveries
- **Session end**: Prompts to review if any new knowledge should be saved

### Categories

| Category | What Goes Here |
|----------|---------------|
| `architecture/` | System design, component maps, data flow |
| `patterns/` | Code conventions, idioms, standard approaches |
| `debugging/` | Bug solutions, error resolutions, troubleshooting |
| `api/` | Endpoint contracts, payload schemas, auth |
| `decisions/` | Architecture Decision Records (ADRs) |
| `dependencies/` | Library tips, version notes, migration |
| `workflows/` | Build, test, deploy procedures |
| `context/` | Domain knowledge, business logic, terminology |

### Example workflow

```
# 1. Initialize memory bank for your project
/memory-bank init

# 2. While working, save discoveries
/memory-bank save debugging/webpack-hmr-fix

# 3. Next session, recall relevant knowledge
/memory-bank recall webpack
```

## Project structure

```
memory-bank/
├── SKILL.md              # Skill definition (frontmatter + instructions)
├── reference.md           # Best practices reference
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

## How it works

The skill teaches the agent to:

1. **Initialize** a `.memory/` directory in your project with categorized subdirectories
2. **Save** knowledge entries using structured templates (title, summary, tags, code examples)
3. **Index** all entries in a master `.memory/index.md` for fast lookup
4. **Recall** relevant memories at session start or on demand
5. **Update** entries as knowledge evolves

All data stays local in your project. No cloud, no sync, no external services.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

[MIT](LICENSE)
