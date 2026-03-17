#!/bin/bash
# Initialize the .memory/ directory structure for a project
# Usage: ./init-memory.sh [project-name]

set -e

PROJECT_NAME="${1:-$(basename "$(pwd)")}"
DATE=$(date +%Y-%m-%d)

echo "[memory-bank] Initializing memory bank for: $PROJECT_NAME"

# Create category directories
CATEGORIES=(architecture patterns debugging api decisions dependencies workflows context)

for category in "${CATEGORIES[@]}"; do
    mkdir -p ".memory/$category"
done

echo "  Created category directories: ${CATEGORIES[*]}"

# Create index.md if it doesn't exist
if [ ! -f ".memory/index.md" ]; then
    cat > .memory/index.md << EOF
# Memory Bank Index

> **Project:** $PROJECT_NAME
> **Initialized:** $DATE
> **Last Updated:** $DATE
> **Total Entries:** 0

## Quick Reference

Use this index to quickly find relevant knowledge before starting a task.

## Categories

### architecture
<!-- System design, component relationships, data flow -->
_No entries yet._

### patterns
<!-- Code patterns, conventions, idioms used in this project -->
_No entries yet._

### debugging
<!-- Bug solutions, common errors, troubleshooting steps -->
_No entries yet._

### api
<!-- API contracts, endpoints, payload formats -->
_No entries yet._

### decisions
<!-- Architecture Decision Records (ADRs) -->
_No entries yet._

### dependencies
<!-- Third-party library usage, version notes, quirks -->
_No entries yet._

### workflows
<!-- Build, deploy, test workflows and commands -->
_No entries yet._

### context
<!-- Project-specific context, business logic, domain knowledge -->
_No entries yet._

---

*This index is auto-maintained. Update it every time you add, modify, or remove a memory entry.*
EOF
    echo "  Created .memory/index.md"
else
    echo "  .memory/index.md already exists, skipping"
fi

echo ""
echo "[memory-bank] Memory bank initialized!"
echo "  Location: .memory/"
echo "  Categories: ${#CATEGORIES[@]}"
echo ""
echo "  Tip: Add '.memory/' to .gitignore if you don't want to track memories in git."
echo "  Or commit them to share knowledge with your team."
