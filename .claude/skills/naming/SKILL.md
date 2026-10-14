---
name: naming
description: Skill for choosing variable names and identifiers. Use this skill when asked to choose names for variables, functions, classes, or any other identifiers in code, and whenever you name or rename them while writing or reviewing code.
---

# Naming

Choose names whose length matches their information content.

Prefer short, precise names over long, explanatory ones.

Use short names for small, local scope:
- Use `i`, `j` for simple loop/index variables.
- Do not expand obvious locals to `index`, `count`, `value`, or similar unless clarity genuinely improves.

Use more descriptive names as scope grows:
- Parameters, exported symbols, fields, globals, and public APIs should carry enough meaning to be clear out of context.
- Favor precise nouns and verbs over vague or padded names.

Avoid:
- Redundant abbreviations and filler words.
- Long-winded names that restate the type or obvious context.
- Near-duplicate names like `i1`/`i2` when clearer pairs like `i`/`j` work.

Rule of thumb: every name should tell, but no name should be longer than necessary.

Names people read rather than code uses (CI workflows, jobs and steps, headings, table columns, UI labels) are
capitalized in title case: "Deploy to Production", not "Deploy to production". The `title-case` skill has the rule
and the exceptions.
