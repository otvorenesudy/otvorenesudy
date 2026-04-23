---
name: TypeScript
description: Instructions for general coding practices in TypeScript. Apply these rules anytime when you're writing or reviewing TypeScript code.
applyTo: "**/*.ts, **/*.tsx"
---

# Copilot TypeScript Coding Style

Use this skill whenever generating TypeScript code.

## General TypeScript & Formatting

- TypeScript 5.x with strict mode enabled (`"strict": true` in `tsconfig.json`).
- Two-space indentation, no tabs.
- Line width: 120 characters.
- Use single quotes for strings unless the project convention differs.
- Use template literals for string interpolation.
- Always use semicolons.
- Use `const` by default; use `let` only when reassignment is necessary; never use `var`.
- Use arrow functions for callbacks and short expressions; use named function declarations for top-level functions.
- Prefer `readonly` on properties and parameters that should not be reassigned.
- Use optional chaining (`?.`) and nullish coalescing (`??`) instead of manual null checks.
- Prefer the `...` spread operator for combining arrays and objects. For potentially very large collections (100k+ elements), use `Array.prototype.concat()` or `Object.assign()` instead to avoid stack overflow from excessive spread arguments.
- Use early returns and guard clauses to reduce nesting.
- Keep functions and methods short and focused; extract helpers.
- Use meaningful, intention-revealing names for types, functions, and variables.
- Prefer explicit return types on exported functions and public methods.
- Enable `noUncheckedIndexedAccess` for safer array/object access.

```typescript
// Bad
function getUser(id: any) {
  var user = users[id]
  if (user != null) {
    return user
  } else {
    return undefined
  }
}

// Good
function getUser(id: string): User | undefined {
  return users.get(id);
}
```

## Type System

- Prefer `interface` for object shapes that may be extended; use `type` for unions, intersections, mapped types, and computed types.
- Never use `any`; use `unknown` for truly unknown types and narrow with type guards.
- Use discriminated unions for state modeling and exhaustive pattern matching.
- Use `as const` for literal type inference.
- Use `satisfies` operator to validate types without widening.
- Use branded types or template literal types for domain-specific validation.
- Prefer generic constraints (`T extends Base`) over type assertions.
- Use `Record<K, V>` for dictionaries; use `Map<K, V>` when key ordering or non-string keys matter.
- Extract shared types into a `types.ts` or co-locate with the module that owns them.

```typescript
// Discriminated union for exhaustive handling
type Result<T> =
  | { status: 'success'; data: T }
  | { status: 'error'; error: Error };

function handle<T>(result: Result<T>): T {
  switch (result.status) {
    case 'success':
      return result.data;
    case 'error':
      throw result.error;
  }
}

// Branded type for domain safety
type UserId = string & { readonly __brand: unique symbol };

function createUserId(id: string): UserId {
  if (!id.match(/^usr_/)) throw new Error('Invalid user ID');
  return id as UserId;
}
```

## Error Handling

- Use typed error classes extending `Error` with a `readonly code` property.
- Use `Result<T>` or discriminated union types for expected failures instead of throwing.
- Reserve `throw` for truly exceptional, unrecoverable situations.
- Use `unknown` for caught errors and narrow with `instanceof`.
- Never silently swallow errors.

```typescript
class AppError extends Error {
  constructor(
    message: string,
    readonly code: string,
    readonly statusCode: number = 500,
  ) {
    super(message);
    this.name = 'AppError';
  }
}

class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super(`${resource} ${id} not found`, 'NOT_FOUND', 404);
  }
}
```

## Async Patterns

- Use `async`/`await` over raw Promises and `.then()` chains.
- Use `Promise.all()` for independent concurrent operations; use `Promise.allSettled()` when partial failure is acceptable.
- Use `AbortController` for cancellable operations.
- Always handle promise rejections; never fire-and-forget an async call.
- Prefer async iterators (`for await...of`) for streaming data.

## Modules and Imports

- Use ES modules (`import`/`export`); never use CommonJS (`require`/`module.exports`) in TypeScript.
- Use named exports; avoid default exports for better refactoring and import consistency.
- Use barrel files (`index.ts`) sparingly; only for stable public APIs.
- Group imports: built-in/Node, third-party, internal — separated by blank lines.
- Use path aliases configured in `tsconfig.json` (`@/`) for internal imports.

```typescript
import { readFile } from 'node:fs/promises';

import { z } from 'zod';

import { UserService } from '@/services/user-service';
import type { User } from '@/types';
```

## Zod and Runtime Validation

- Use `zod` for runtime validation of external data (API inputs, environment variables, config files).
- Infer TypeScript types from Zod schemas with `z.infer<typeof schema>`.
- Define schemas close to where they are used; co-locate with the handler or service.

```typescript
import { z } from 'zod';

const CreateUserSchema = z.object({
  name: z.string().min(1).max(200),
  email: z.string().email(),
  role: z.enum(['admin', 'member']).default('member'),
});

type CreateUserInput = z.infer<typeof CreateUserSchema>;
```

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

## React (when applicable)

- Use functional components with hooks; never use class components.
- Use `React.FC` sparingly; prefer explicit props typing.
- Use `useState`, `useReducer` for local state; prefer `useReducer` for complex state.
- Use `useMemo` and `useCallback` only when there is a measured performance need; avoid premature memoization.
- Co-locate components, hooks, and styles by feature.
- Extract custom hooks for reusable stateful logic.
- Use discriminated union props for component variants.

```typescript
interface ButtonProps {
  readonly variant: 'primary' | 'secondary';
  readonly label: string;
  readonly onClick: () => void;
  readonly disabled?: boolean;
}

function Button({ variant, label, onClick, disabled = false }: ButtonProps) {
  return (
    <button
      className={`btn btn-${variant}`}
      onClick={onClick}
      disabled={disabled}
    >
      {label}
    </button>
  );
}
```

## Node.js / Backend (when applicable)

- Use `node:` prefix for built-in modules (`node:fs`, `node:path`, `node:crypto`).
- Use `express`, `fastify`, or `hono` with typed middleware and route handlers.
- Use dependency injection (constructor injection or a DI container) for services.
- Validate environment variables at startup with Zod; fail fast on missing config.
- Use structured JSON logging (`pino`, `winston`).

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

```typescript
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

```typescript
import { Worker } from 'node:worker_threads';

function runCpuTask<T>(data: unknown): Promise<T> {
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

- Use **Vitest** or **Jest** as the test framework.
- Name test files `*.test.ts` or `*.spec.ts` adjacent to source files.
- Use `describe` for grouping, `it` for individual cases; use present tense descriptions.
- Use `vi.fn()` / `jest.fn()` for mocks; prefer dependency injection over module mocking.
- Use `expect(...).toEqual()` for deep equality; use `expect(...).toBe()` for reference/primitive equality.
- Use `beforeEach` for setup; avoid shared mutable state between tests.

```typescript
import { describe, it, expect } from 'vitest';
import { UserService } from './user-service';

describe('UserService', () => {
  const service = new UserService(new InMemoryUserRepository());

  it('creates a user with valid input', async () => {
    const user = await service.create({ name: 'Alice', email: 'alice@test.com' });

    expect(user.name).toBe('Alice');
    expect(user.email).toBe('alice@test.com');
  });

  it('rejects invalid email', async () => {
    await expect(
      service.create({ name: 'Alice', email: 'invalid' }),
    ).rejects.toThrow('Invalid email');
  });
});
```

## When Generating TypeScript Code

- Always enable strict mode and use explicit types on public API surfaces.
- Prefer `interface` for shapes, `type` for unions and utilities.
- Never use `any`; use `unknown` and narrow appropriately.
- Use modern syntax: optional chaining, nullish coalescing, `satisfies`, `using` for resource management.
- Use named exports over default exports.
- Validate external data at system boundaries with Zod or similar.
