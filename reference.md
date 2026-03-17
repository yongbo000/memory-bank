# Memory Bank — Best Practices Reference

## Memory Lifecycle

```
Discovery → Evaluate → Categorize → Write → Index → Recall → Update
```

### 1. Discovery Phase
You encounter knowledge during normal work:
- Debugging a tricky bug and finding the root cause
- Understanding how components connect
- Learning a library's undocumented behavior
- Making an architecture decision with trade-offs

### 2. Evaluate Phase
Ask yourself: **"Will I need this again?"**

**Save if:**
- It took significant effort to figure out
- It's non-obvious or counterintuitive
- It's project-specific context that's hard to rediscover
- It affects how future work should be done
- It records *why* something was done, not just *what*

**Skip if:**
- It's easily found in official docs
- It's a one-off fix that won't recur
- It's common general programming knowledge

### 3. Categorize Phase
Choose the right category based on the knowledge type:

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

### 4. Write Phase
Follow the entry template. Key rules:
- **Title:** Specific and searchable (e.g., "Chrome CDP Connection Timeout Fix" not "Browser Bug")
- **Summary:** 1-2 sentences. Should be enough to decide if the full entry is relevant
- **Tags:** 3-5 keywords for searchability
- **Code examples:** Always include when applicable
- **"Why" over "What":** Record the reasoning, not just the facts

### 5. Index Phase
**Always update `.memory/index.md`** after creating/modifying an entry.

Format:
```markdown
### category-name
- [entry-title](category/filename.md) — One-line description
```

### 6. Recall Phase
At the start of a session or task:
1. Read `.memory/index.md` — scan for relevant prior knowledge
2. Read specific entries that match the current task domain
3. Use `search-memory.sh` for keyword-based lookup

### 7. Update Phase
Knowledge evolves. When you learn something new about an existing topic:
- Update the entry content
- Bump the "Last Updated" date
- Mark confidence level changes
- Update the index if the summary changed

## Naming Conventions

### File Names
Use kebab-case, descriptive names:
```
Good: react-loop-streaming.md, chrome-cdp-timeout.md, esm-import-rules.md
Bad:  notes.md, bug1.md, misc.md, temp.md
```

### Decision Records
Use sequential numbering:
```
001-chose-esm-over-cjs.md
002-playwright-over-puppeteer.md
003-streaming-architecture.md
```

## Confidence Levels

| Level | Meaning | When to Use |
|-------|---------|-------------|
| `high` | Verified, tested, reliable | Confirmed through implementation and testing |
| `medium` | Likely correct, partially verified | Based on documentation or limited testing |
| `low` | Hypothesis, needs verification | Initial understanding, may change |

Update confidence as knowledge is validated or invalidated.

## Cross-Referencing

Use relative links in the `## Related` section:

```markdown
## Related
- [Error Handling Pattern](../patterns/error-handling.md) — Related convention
- [ADR-002: Chose Playwright](../decisions/002-playwright.md) — Why we use this library
```

This creates a knowledge graph that helps you navigate between related concepts.

## Memory Maintenance

Periodically review your memory bank:

1. **Remove outdated entries** — Delete knowledge that's no longer accurate
2. **Merge duplicates** — Combine entries covering the same topic
3. **Update confidence** — Re-evaluate based on new experience
4. **Check links** — Ensure cross-references still work
5. **Prune tags** — Keep tags consistent and useful
