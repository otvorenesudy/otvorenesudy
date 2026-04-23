---
name: JavaScript
description: Instructions for general coding practices in JavaScript. Apply these rules anytime when you're writing or reviewing JavaScript code.
applyTo: "**/*.js, **/*.mjs, **/*.cjs, **/*.jsx"
---

# Copilot JavaScript Coding Style

Use this skill whenever generating JavaScript code.

## General JavaScript & Formatting

- Target ES2024+ for modern environments; specify compatibility targets in project config when supporting older runtimes.
- Two-space indentation, no tabs.
- Line width: 120 characters.
- Use single quotes for strings unless the project convention differs.
- Use template literals for string interpolation.
- Always use semicolons.
- Use `const` by default; use `let` only when reassignment is necessary; never use `var`.
- Use arrow functions for callbacks and short expressions; use named function declarations for top-level functions.
- Use optional chaining (`?.`) and nullish coalescing (`??`) instead of manual null/undefined checks.
- Use early returns and guard clauses to reduce nesting.
- Keep functions short and focused; extract helpers.
- Use meaningful, intention-revealing names.
- Use strict equality (`===` and `!==`); never use loose equality (`==`).
- Use `structuredClone()` for deep cloning; avoid `JSON.parse(JSON.stringify())` hacks.
- Use `Object.groupBy()` and `Map.groupBy()` for grouping operations.
- Use `Array.prototype.at()` for negative indexing.

```javascript
// Bad
var items = getItems()
for (var i = 0; i < items.length; i++) {
  if (items[i] != null) {
    process(items[i])
  }
}

// Good
const items = getItems();

for (const item of items) {
  if (item == null) continue;
  process(item);
}
```

## Modules and Imports

- Use ES modules (`import`/`export`) for all new code; use `.mjs` extension or `"type": "module"` in `package.json`.
- Use named exports; avoid default exports for better refactoring and import consistency.
- Use `node:` prefix for built-in Node.js modules (`node:fs`, `node:path`).
- Group imports: built-in/Node, third-party, internal — separated by blank lines.

```javascript
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';

import express from 'express';

import { UserService } from './services/user-service.js';
```

## Functions and Patterns

- Use destructuring for function parameters and object access.
- Use rest/spread operators for variadic functions and object composition.
- Prefer the `...` spread operator for combining arrays and objects. For potentially very large collections (100k+ elements), use `Array.prototype.concat()` or `Object.assign()` instead to avoid stack overflow from excessive spread arguments.
- Use `Object.freeze()` for constant object values.
- Avoid classes when simple functions and closures suffice; use classes for stateful abstractions.
- Use `#` private class fields for true encapsulation.
- Use iterators and generators for lazy sequences.

```javascript
// Destructured parameters with defaults
function createUser({ name, email, role = 'member' }) {
  return { name, email, role, createdAt: new Date() };
}

// Private fields
class Counter {
  #count = 0;

  increment() {
    this.#count += 1;
  }

  get value() {
    return this.#count;
  }
}
```

## Error Handling

- Catch specific error types; avoid bare `catch` that silently swallows.
- Use custom error classes extending `Error` with a `code` property.
- Use `cause` property (ES2022) to chain errors.
- Let unexpected errors propagate; do not suppress exceptions.

```javascript
class AppError extends Error {
  constructor(message, code, options = {}) {
    super(message, options);
    this.code = code;
    this.name = 'AppError';
  }
}

class NotFoundError extends AppError {
  constructor(resource, id, options = {}) {
    super(`${resource} ${id} not found`, 'NOT_FOUND', options);
  }
}

// Chaining errors
try {
  await fetchUser(id);
} catch (err) {
  throw new NotFoundError('User', id, { cause: err });
}
```

## Async Patterns

- Use `async`/`await` over raw Promises and `.then()` chains.
- Use `Promise.all()` for independent concurrent operations; use `Promise.allSettled()` when partial failure is acceptable.
- Use `AbortController` and `AbortSignal` for cancellable operations and timeouts.
- Always handle promise rejections; never fire-and-forget.
- Use `for await...of` for async iteration.
- Use `Promise.withResolvers()` for deferred promise patterns.

## Formatting and Linting

- Use **Biome** or **ESLint + Prettier** for formatting and linting.
- Run formatting with:
  ```bash
  npx biome format --write .
  ```
  or:
  ```bash
  npx prettier --write .
  ```
- Run linting with:
  ```bash
  npx biome lint .
  ```
  or:
  ```bash
  npx eslint .
  ```

## JSDoc (when not using TypeScript)

- Use JSDoc annotations for function signatures, parameters, and return types.
- Use `@typedef` for complex object shapes.
- Use `@param`, `@returns`, and `@throws` consistently.
- Enable `// @ts-check` at the top of files for editor-level type checking without TypeScript compilation.

```javascript
// @ts-check

/** @typedef {{ name: string, email: string, role?: 'admin' | 'member' }} CreateUserInput */

/**
 * @param {CreateUserInput} input
 * @returns {Promise<User>}
 * @throws {ValidationError}
 */
async function createUser(input) {
  // ...
}
```

## React (when applicable)

- Use functional components with hooks; never use class components.
- Use `prop-types` or JSDoc for prop validation when not using TypeScript.
- Use `useState`, `useReducer` for local state.
- Co-locate components, hooks, and styles by feature.
- Extract custom hooks for reusable stateful logic.
- Use `React.memo()` only when there is a measured performance need.

## Node.js / Backend (when applicable)

- Use `node:` prefix for built-in modules.
- Set `"type": "module"` in `package.json` for ESM.
- Validate environment variables at startup; fail fast on missing config.
- Use structured JSON logging (`pino`).
- Use `express`, `fastify`, or `hono` with route-level error handling middleware.
- Validate request input at API boundaries with `zod`, `joi`, or `ajv`.

### Event Loop & Worker Pool

Node.js uses a single-threaded Event Loop for JavaScript execution and a Worker Pool (libuv thread pool) for expensive I/O and CPU tasks. Blocking either degrades throughput for all clients and can enable denial-of-service attacks.

#### Keep the Event Loop fast

- Every callback, `await`, and `Promise.then` must complete quickly. Reason about the computational complexity of your handlers — `O(1)` or `O(n)` with bounded `n` is safe; unbounded `O(n²)` or worse is not.
- Bound input sizes and reject inputs that are too large before processing them.

#### Avoid vulnerable regular expressions (ReDoS)

- Never use nested quantifiers (`(a+)*`), OR clauses with overlapping alternatives (`(a|a)*`), or backreferences (`(a.*) \1`) on untrusted input.
- Use `indexOf` or `includes` for simple string matching instead of regex.
- Validate regexps with `safe-regex` or use Google RE2 via the `re2` module for untrusted patterns.
- Prefer well-tested regex from npm (e.g., `ip-regex`) over hand-rolled patterns.

```javascript
// Bad — vulnerable to ReDoS on crafted paths
if (userInput.match(/(\/.+)+$/)) { /* ... */ }

// Good — use a purpose-built parser or simple check
if (userInput.startsWith('/') && !userInput.includes('\0')) { /* ... */ }
```

#### Never use synchronous APIs in server code

- Do not call `fs.readFileSync`, `fs.writeFileSync`, `crypto.randomBytes` (sync overload), `crypto.pbkdf2Sync`, `crypto.randomFillSync`, `zlib.inflateSync`, `zlib.deflateSync`, `child_process.execSync`, `child_process.spawnSync`, or `child_process.execFileSync` in request handlers.
- Synchronous file and crypto APIs are for CLI scripts and application startup only.

#### Guard against JSON DoS

- `JSON.parse` and `JSON.stringify` are `O(n)` but expensive for large payloads. Limit request body sizes (e.g., `express.json({ limit: '1mb' })`).
- For very large JSON, use streaming parsers (`JSONStream`, `stream-json`) or offload to a worker.

#### Offload expensive work

- Use `worker_threads` for CPU-intensive tasks (image processing, hashing, compression). Keep the Event Loop focused on orchestration.
- For I/O-heavy work, rely on async APIs — the Worker Pool handles them automatically.
- Never spawn a child process per request — use a bounded pool.

```javascript
import { Worker } from 'node:worker_threads';

function runCpuTask(data) {
  return new Promise((resolve, reject) => {
    const worker = new Worker('./cpu-task.js', { workerData: data });
    worker.on('message', resolve);
    worker.on('error', reject);
  });
}
```

#### Partition long-running tasks

- If you must run a loop on the Event Loop, break it into chunks with `setImmediate()` between iterations to yield to other pending callbacks.
- Use `ReadStream` instead of `fs.readFile()` for large files to avoid blocking a Worker Pool thread.

#### Evaluate npm module costs

- Before adopting an npm module, check whether its APIs might block the Event Loop or a Worker. Review source code or documentation for computational cost.
- Even async APIs can block if each partition does too much work internally.

## Testing

- Use **Vitest**, **Jest**, or **Node.js built-in test runner** (`node:test`).
- Name test files `*.test.js` or `*.spec.js` adjacent to source files.
- Use `describe` for grouping, `it` for individual cases; use present tense descriptions.
- Prefer dependency injection over module mocking.
- Use `beforeEach` for setup; avoid shared mutable state between tests.
- Use `assert` from `node:assert/strict` with the built-in test runner.

```javascript
import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { UserService } from './user-service.js';

describe('UserService', () => {
  it('creates a user with valid input', async () => {
    const service = new UserService(new InMemoryUserRepository());

    const user = await service.create({ name: 'Alice', email: 'alice@test.com' });

    assert.equal(user.name, 'Alice');
    assert.equal(user.email, 'alice@test.com');
  });

  it('rejects invalid email', async () => {
    const service = new UserService(new InMemoryUserRepository());

    await assert.rejects(
      () => service.create({ name: 'Alice', email: 'invalid' }),
      { message: /invalid email/i },
    );
  });
});
```

## When Generating JavaScript Code

- Use modern ES2024+ syntax: optional chaining, nullish coalescing, private fields, `structuredClone`, `Object.groupBy`.
- Use ES modules with named exports.
- Use strict equality exclusively.
- Add JSDoc type annotations when not in a TypeScript project.
- Validate external data at system boundaries.
- Prefer `const` and immutable patterns; avoid mutation where practical.
