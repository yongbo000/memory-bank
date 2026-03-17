#!/bin/bash
# Show memory bank statistics
# Usage: ./memory-stats.sh

if [ ! -d ".memory" ]; then
    echo "[memory-bank] No .memory/ directory found in current project."
    exit 1
fi

echo "=========================================="
echo "  Memory Bank Statistics"
echo "=========================================="
echo ""

# Total entries (excluding index.md)
TOTAL=$(find .memory -name "*.md" ! -name "index.md" 2>/dev/null | wc -l | tr -d ' ')
echo "Total memory entries: $TOTAL"
echo ""

# Per-category breakdown
echo "By category:"
echo "  ─────────────────────────────"

for dir in .memory/*/; do
    if [ -d "$dir" ]; then
        CATEGORY=$(basename "$dir")
        COUNT=$(find "$dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$COUNT" -gt 0 ]; then
            printf "  %-20s %s entries\n" "$CATEGORY" "$COUNT"
        else
            printf "  %-20s (empty)\n" "$CATEGORY"
        fi
    fi
done

echo ""

# Recently modified
echo "Recently updated (last 5):"
echo "  ─────────────────────────────"
find .memory -name "*.md" ! -name "index.md" -exec stat -f "%m %N" {} \; 2>/dev/null | sort -rn | head -5 | while read -r timestamp file; do
    DATE=$(date -r "$timestamp" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "unknown")
    printf "  %-20s %s\n" "$DATE" "$file"
done

echo ""

# Disk usage
SIZE=$(du -sh .memory 2>/dev/null | cut -f1)
echo "Total size: $SIZE"
echo ""

# Tags analysis (if any entries exist)
if [ "$TOTAL" -gt 0 ]; then
    echo "Most common tags:"
    echo "  ─────────────────────────────"
    grep -rh "^> \*\*Tags:\*\*" .memory/ --include="*.md" 2>/dev/null | \
        sed 's/> \*\*Tags:\*\* //' | \
        tr ',' '\n' | \
        sed 's/^[[:space:]]*//' | \
        sed 's/[[:space:]]*$//' | \
        sort | uniq -c | sort -rn | head -10 | \
        while read -r count tag; do
            if [ -n "$tag" ]; then
                printf "  %-20s (%s)\n" "$tag" "$count"
            fi
        done
fi

echo ""
echo "=========================================="
