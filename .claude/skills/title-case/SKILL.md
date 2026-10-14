---
name: title-case
description: Capitalization of names, in title case. Use when naming something people read as a name — a CI workflow, job or step; a GitHub check or ruleset; a document title, heading or table column; a UI label such as a button, menu item, tab or page title — and when reviewing names like these. Also says when to use sentence case instead, and which names keep their own capitalization.
---

# Title Case

Write the names of things in **title case** (also called title-style or headline-style capitalization): the
first word, the last word and every word in between start with a capital letter, except a few short minor
words. "Upload Coverage to Codecov", not "Upload coverage to Codecov"; "Check Out the Data Submodule", not "Check
out the data submodule".

## The Rule

1. Capitalize the first and the last word, whatever they are: "What It Is", "Turn Spring Off".
2. Capitalize nouns, pronouns, verbs, adjectives, adverbs and subordinating conjunctions ("If", "Because",
   "When", "That"): "Reindex the Decrees If They Changed".
3. Lowercase these minor words when they are neither first nor last:
   - articles: a, an, the;
   - coordinating conjunctions: and, but, or, nor, for, so, yet;
   - "to" in an infinitive, and "as";
   - prepositions of four letters or fewer: at, by, for, from, in, into, of, off, on, onto, out, over, per, to,
     up, via, with.
4. Capitalize longer prepositions ("About", "After", "Against", "Before", "Between", "Through", "Without"),
   and a short word that belongs to a verb rather than acting as a preposition: "Set Up Ruby", "Sign In",
   "Check Out Repository", "Log In to the Server". The verb is two words ("Set Up Ruby"); the noun is one ("Database
   Setup").
5. In a hyphenated compound, case each part as if it stood alone: "End-to-End", "Built-In", "Up-to-Date".
6. After a colon, start again as at the beginning: "Phase 1: The Rails Upgrade".

## Names That Keep Their Own Capitalization

Title case never changes a word that already has a fixed form:

- acronyms and initialisms: CI, API, JSON, PDF, ECLI, PR;
- product, brand and tool names as their owners write them: GitHub, macOS, PostgreSQL, Elasticsearch, RuboCop,
  RSpec, npm;
- anything literal, in code formatting or not: commands, paths, file names, branch names, environment names,
  identifiers and arguments (`bin/test`, `main.yml`, `main`, `production`, `spec/models`, `--fix`).

So: "Run bin/lint --fix" keeps the command and its argument as they are typed.

## Where It Applies

Use title case for things people read as names:

- CI: workflow, job and step names, composite action names.
- GitHub: check names, ruleset names, release titles.
- Documents: titles, headings and table column headings, in READMEs, `AGENTS.md`, guides, skills and rules.
- Product UI: button titles, menu items, tabs, and window, page and dialog titles. Use it for labels you add or
  change; leave product copy you are not otherwise changing as it is. Slovak UI text follows Slovak rules, which
  capitalize only the first word and proper names: "Súdne rozhodnutia", not "Súdne Rozhodnutia".

## Where It Doesn't

Use **sentence case** (only the first word and proper names capitalized) for anything that reads as a
sentence: descriptions, help text and tooltips, error and log messages, comments, test names, list items and
prose.

Formats with rules of their own keep them: Conventional Commits subjects and pull request titles
(`fix(search): keep the court facet when the query is empty`), branch names, file names and identifiers.
