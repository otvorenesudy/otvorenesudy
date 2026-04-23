---
name: engineering
description: Skill for applying engineering principles when writing or reviewing code, inspired by Russ Cox's worknotes. Apply this skill anytime you're writing, editing, or reviewing any code.
---

# Engineering Principles

Use these instructions whenever generating or reviewing code.

## Core principles

- Make the smallest valuable change that moves the work forward.
- Prefer small, reviewable diffs over broad rewrites.
- For larger work, begin with the goal, key risks, and an iteration plan before implementing.
- Favor simple, maintainable solutions over clever, overly flexible, or short-term easy ones.
- Optimize for long-term efficiency, clarity, and ease of change.
- Treat reliability, security, correctness, and performance as core requirements.
- Maintain velocity by reducing unnecessary process, not by lowering quality.
- Cut scope before cutting quality.
- Ship production-ready code only.

## Style and consistency

- Match the existing file and repository style exactly before applying personal preferences.
- Use idiomatic constructs for the language and codebase.
- Prefer conventional naming and the most natural expression of common patterns.
- When unsure, copy the conventions already used nearby.

## Iteration

- Implement the minimal valuable change on the direct path to the goal.
- Break large features into safe, useful increments that can be reviewed and validated independently.
- For complex work, identify core design problems and risks early, then reduce uncertainty before scaling implementation.
- Use prototypes or proof-of-concepts only when they help de-risk the design or validate an approach.
- Avoid speculative abstraction and future-proofing that is not justified by current needs.

## Efficiency and simplicity

- Prefer simple, direct solutions over clever ones.
- Choose the simplest solution that solves the problem well.
- Prefer maintainable, boring, well-understood patterns over clever or highly customized designs.
- Keep code readable enough that it needs few comments; rewrite confusing code instead of explaining it with comments.
- Refactor toward clarity, easier modification, and lower cognitive load.
- Build useful abstractions only when they reduce duplication or improve changeability.
- Optimize only when there is clear evidence the code is measurably slow.
- When performance matters, improve data structures and overall design before chasing minor tweaks.
- Automate repetitive work when it meaningfully improves developer efficiency or reduces error-prone manual steps.
- Prefer productized, reusable solutions over one-off hacks, local patches, or throwaway side tools.
- Aim for engineering excellence, not engineering perfection.

## Reliability and predictability

- Prioritize availability, security, and data safety over feature speed.
- Do not introduce avoidable operational risk for the sake of faster delivery.
- Make failure modes, edge cases, and rollback paths explicit in the implementation.
- Favor designs that are observable, testable, and easy to reason about in production.
- Use established project patterns, conventions, and safeguards when they reduce risk and improve consistency.
- When changing behavior that could impact production, prefer controlled rollout strategies such as feature flags, isolation, or incremental adoption.

## Velocity

- Keep momentum by delivering small changes continuously.
- Reduce review latency: write code that is easy to review, and avoid unnecessary complexity in a single change.
- Avoid unnecessary process, ceremony, or coordination overhead when it does not improve outcomes.
- Be pragmatic: choose the lightest process that still preserves safety and quality.
- Balance feature delivery with maintenance, cleanup, and refactoring.
- Be proactive about removing or improving processes that slow delivery without adding enough value.

## Quality

- Everything committed should be production-ready.
- Do not leave behind partially integrated, fragile, or knowingly low-quality implementations.
- Validate behavior with appropriate tests for the level of change.
- Preserve code quality and consistency with existing project conventions and development guides.
- Prefer code that is easy to understand and easy to change over code optimized for hypothetical future reuse.
- Release when the work is ready; do not rush implementation only to fit an arbitrary date.

## Application guidance

- Keep classes and methods focused, with one clear responsibility.
- Prefer explicit, intention-revealing code over metaprogramming or indirection unless there is strong justification.
- Keep controllers thin and move business logic into models, services, or query objects as appropriate.
- Keep background jobs small and deterministic; delegate non-trivial logic to reusable application code.
- Prefer plain objects for domain logic that does not need to live in controllers or models.
- Use framework conventions when they improve consistency, readability, and maintainability.
- Reuse existing application patterns, shared components, and established abstractions before introducing new ones.
- When changing existing code, leave it clearer, safer, or easier to extend than you found it.

## Comments and communication

- Add short comments above functions when the intent is not obvious.
- Put comments on their own lines before the code they explain.
- Use comments to explain why something is surprising, constrained, or hard to understand.
- Keep change summaries brief and factual.

## Review expectations

- Generate code that is easy to review in small increments.
- Highlight notable risks, tradeoffs, and assumptions when they affect implementation choices.
- When a change is large or architectural, structure the code so the migration path is clear.
- Avoid unrelated cleanup in the same change unless it directly supports the work.
- Prefer follow-up iterations over bundling multiple concerns into one large change.
- Treat review feedback as refinement: many suggested changes usually mean the code is worth improving.