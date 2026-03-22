---
name: document-idea
description: Workflow for documenting a new product idea or feature proposal in CaliDay. Use when a new idea appears — records the idea in ARCHITECTURE.md backlog and elaborates implementation design in DEV_NOTES.md.
---

# Document Idea Workflow

**All documentation must be written in English** (ARCHITECTURE.md, DEV_NOTES.md, specs, memory).

Ideas are recorded in two places with different levels of detail:
- **ARCHITECTURE.md** — the idea itself (one line in the backlog)
- **DEV_NOTES.md** — implementation elaboration (detailed spec)

## Step 1 — Add to ARCHITECTURE.md backlog

Find the "Feature Backlog" section in `docs/ARCHITECTURE.md` and add a row to the table:

```markdown
| v?.? | Feature name | 💡 idea |
```

Statuses:
- `💡 idea` — idea, not yet elaborated
- `📐 designed` — has a detailed spec in DEV_NOTES
- `🔒 waiting` — waiting for assets, decisions, or external conditions
- `✅` — implemented

## Step 2 — Create a spec in DEV_NOTES.md

If the idea is elaborated or requires planning — add a section to `docs/DEV_NOTES.md`
in the "Active Specs" section.

Spec structure:
```markdown
### v?.? — Feature name — designed / idea

#### Concept
[1-2 paragraphs: what it is, why, key principles]

#### UX / Mechanics
[How it looks and works for the user]

#### Technical Tasks
| # | Task |
|---|------|
| 1 | ... |

#### Technical Details
[Data models, algorithms, packages]

#### When to tackle
[Conditions/priority]
```

Don't describe what is obvious from the code or already in ARCHITECTURE.md.
Focus on: non-trivial technical decisions, UX scenarios, dependencies.

## Step 3 — Update status in ARCHITECTURE.md

If the elaboration level increased (idea → designed):
```markdown
| v?.? | Feature name | 📐 designed |
```

## After implementing a feature

When a feature is implemented:
1. In ARCHITECTURE.md: status → `✅`, add final decisions to relevant sections
2. In DEV_NOTES.md: remove spec from "Active Specs", add entry to "Change History"
3. Run the `pre-commit` skill