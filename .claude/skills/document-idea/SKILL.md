---
name: document-idea
description: Workflow for documenting a new product idea or feature proposal in CaliDay. Use when a new idea appears — records the idea in internal_docs/STATUS.md and, when it needs planning, a spec file in internal_docs/specs/.
---

# Document Idea Workflow

**All documentation is written in English** (the notes, specs, memory).

Ideas are recorded in two places with different levels of detail:
- **`internal_docs/STATUS.md` § Ideas, open** — the idea itself, one row with a link
- **`internal_docs/specs/<idea>.md`** — the elaboration, when the idea needs planning

## Step 1 — A row in STATUS.md

Add a row to the "Ideas, open" table: the idea in a few words, who asked and when, and the link to its spec (or "—"). Parked ideas go under "Parked, do not propose"; their research, if any, to `internal_docs/research/`.

## Step 2 — A spec in specs/ (if the idea needs planning)

One file per idea, `internal_docs/specs/<short-name>.md`, starting with the line
`> Part of the project notes — the index is [internal_docs/README.md](../README.md).`

```markdown
# <Idea> — idea / designed (who, date)

**The wish:** [what and why, in the owner's words]

**Options / design:** [how it could look and work; what is decided and what is open for the owner]

**Technical notes:** [data, packages to check with Context7, what it touches, risks]

**Done when:** [what the owner will see]
```

Don't describe what is obvious from the code or already in `internal_docs/reference/`. Focus on non-trivial decisions, UX scenarios, dependencies and the questions for the owner.

## After implementing an idea

1. The spec moves to `internal_docs/specs/done/` with a line on top saying what was built and where it is described.
2. STATUS.md: the row leaves "Ideas, open".
3. The final decisions go into the `reference/` files and `decisions/README.md`; the version's entry in `CHANGELOG.md` tells what was done.
4. Run the `pre-commit` skill.
