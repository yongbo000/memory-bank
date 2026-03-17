#!/bin/bash
# Search memories by keyword across the entire .memory/ directory
# Usage: ./search-memory.sh <keyword> [category]
#
# Examples:
#   ./search-memory.sh "error handling"
#   ./search-memory.sh "streaming" patterns
#   ./search-memory.sh "playwright" dependencies

set -e

KEYWORD="${1:-}"
CATEGORY="${2:-}"

if [ -z "$KEYWORD" ]; then
    echo "Usage: search-memory.sh <keyword> [category]"
    echo ""
    echo "Examples:"
    echo "  search-memory.sh 'error handling'"
    echo "  search-memory.sh 'streaming' patterns"
    exit 1
fi

if [ ! -d ".memory" ]; then
    echo "[memory-bank] No .memory/ directory found in current project."
    echo "Run init-memory.sh first."
    exit 1
fi

SEARCH_PATH=".memory"
if [ -n "$CATEGORY" ]; then
    SEARCH_PATH=".memory/$CATEGORY"
    if [ ! -d "$SEARCH_PATH" ]; then
        echo "[memory-bank] Category '$CATEGORY' not found."
        echo "Available categories:"
        ls -1 .memory/ | grep -v index.md | grep -v "^$"
        exit 1
    fi
fi

echo "[memory-bank] Searching for '$KEYWORD' in $SEARCH_PATH/"
echo "=========================================="
echo ""

# Search with context, showing filename and line numbers
RESULTS=$(grep -rl "$KEYWORD" "$SEARCH_PATH" --include="*.md" 2>/dev/null || true)

if [ -z "$RESULTS" ]; then
    echo "No matches found for '$KEYWORD'"
    echo ""
    echo "Tips:"
    echo "  - Try a broader search term"
    echo "  - Check available categories: ls .memory/"
    echo "  - Search without category filter"
    exit 0
fi

MATCH_COUNT=0
for file in $RESULTS; do
    if [ "$file" = ".memory/index.md" ]; then
        continue
    fi
    MATCH_COUNT=$((MATCH_COUNT + 1))
    echo "--- $file ---"
    # Show the Summary section if it exists, otherwise first 5 lines
    SUMMARY=$(sed -n '/^## Summary/,/^## /p' "$file" 2>/dev/null | head -5)
    if [ -n "$SUMMARY" ]; then
        echo "$SUMMARY"
    else
        head -8 "$file"
    fi
    echo ""
done

echo "=========================================="
echo "Found matches in $MATCH_COUNT file(s)"
