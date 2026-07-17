---
description: TypeScript development — generics, utility types, conditional types, template literals, module resolution, and advanced type patterns
mode: subagent
hidden: true
permission:
  edit: allow
  bash: allow
temperature: 0.2
---

# TypeScript Development

> Write robust TypeScript — generics, utility types, conditional types, template literals, module resolution, tsconfig patterns, declaration files, and advanced type patterns.

## When to use

Use this skill when writing TypeScript code. Covers the type system in depth — not framework-specific (use React/Vue/Angular skills for those). This skill focuses on TypeScript itself: type design, configuration, and advanced patterns.

## Core principles

- **TypeScript is about modeling data, not just adding types** — good types make illegal states unrepresentable
- **Prefer `interface` for public APIs (extensible), `type` for unions and complex composed types**
- **Strict mode is not optional** — `strict: true` catches real bugs
- **Types are documentation that the compiler enforces** — invest time in good type design

## Configuration

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "exactOptionalPropertyTypes": true,
    "isolatedModules": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "skipLibCheck": false
  },
  "include": ["src"]
}
```

| Key option | What it does |
|------------|-------------|
| `strict: true` | Enables all strict checks (`strictNullChecks`, `noImplicitAny`, etc.) |
| `noUncheckedIndexedAccess` | Adds `undefined` to indexed access types |
| `exactOptionalPropertyTypes` | `?` means property can be absent, not `undefined` |
| `moduleResolution: "bundler"` | Modern resolution (for Vite, esbuild, etc.) |
| `isolatedModules: true` | Ensures each file can be transpiled independently |

## Generics

### Basic generics

```typescript
function identity<T>(value: T): T {
  return value;
}

// Constraints
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}
```

### Type parameters with defaults

```typescript
function createArray<T = string>(length: number, value: T): T[] {
  return Array(length).fill(value);
}
```

### Generic constraints with conditional types

```typescript
type IsString<T> = T extends string ? true : false;
type A = IsString<"hello">;  // true
type B = IsString<42>;       // false
```

### `infer` keyword

```typescript
// Extract return type from a function type
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never;

// Extract element type from an array
type ElementType<T> = T extends (infer U)[] ? U : never;
type E = ElementType<string[]>;  // string

// Extract Promise value
type Awaited<T> = T extends Promise<infer U> ? U : T;
```

## Utility types

```typescript
// Partial: make all properties optional
Partial<{ a: string; b: number }>  // { a?: string; b?: number }

// Required: make all properties required
Required<{ a?: string; b?: number }>  // { a: string; b: number }

// Readonly: make all properties readonly
Readonly<{ a: string }>  // { readonly a: string }

// Pick: select specific properties
Pick<{ a: string; b: number; c: boolean }, 'a' | 'c'>
// { a: string; c: boolean }

// Omit: remove specific properties
Omit<{ a: string; b: number; c: boolean }, 'b'>
// { a: string; c: boolean }

// Extract: get matching types from a union
Extract<'a' | 'b' | 'c', 'a' | 'c'>  // 'a' | 'c'

// Exclude: remove matching types from a union
Exclude<'a' | 'b' | 'c', 'a'>  // 'b' | 'c'

// Record: object type with specific keys and values
Record<'id' | 'name', string>  // { id: string; name: string }

// NonNullable: remove null and undefined
NonNullable<string | null | undefined>  // string

// Parameters: extract parameter types from a function
Parameters<(a: string, b: number) => void>  // [string, number]

// ConstructorParameters: extract constructor parameter types
ConstructorParameters<new (name: string) => any>  // [string]

// ThisType: set `this` type in an object
type MyObj = { fn: () => void } & ThisType<{ x: number }>;
```

## Conditional types

```typescript
// Basic conditional
type IsNumber<T> = T extends number ? 'yes' : 'no';

// Chained conditionals
type TypeName<T> =
  T extends string ? 'string' :
  T extends number ? 'number' :
  T extends boolean ? 'boolean' :
  T extends undefined ? 'undefined' :
  T extends Function ? 'function' :
  'object';

// Distributive conditional types (for unions)
type ToArray<T> = T extends unknown ? T[] : never;
type Result = ToArray<string | number>;  // string[] | number[]
// (not (string | number)[])
```

## Template literal types

```typescript
type EventName = `on${Capitalize<string>}`;
// 'onClick' | 'onChange' | 'onSubmit' | ...

type Color = 'red' | 'green' | 'blue';
type Size = 'sm' | 'md' | 'lg';
type ColorSize = `${Color}-${Size}`;
// 'red-sm' | 'red-md' | 'red-lg' | 'green-sm' | ...

// Intrinsic string types
Uppercase<'hello'>     // 'HELLO'
Lowercase<'HELLO'>     // 'hello'
Capitalize<'hello'>    // 'Hello'
Uncapitalize<'Hello'>  // 'hello'
```

## Mapped types

```typescript
// Make all properties nullable
type Nullable<T> = {
  [K in keyof T]: T[K] | null;
};

// Make all properties promise-returning
type Promisify<T> = {
  [K in keyof T]: () => Promise<T[K]>;
};

// Rename keys with a prefix
type Prefixed<T, P extends string> = {
  [K in keyof T as `${P}${Capitalize<string & K>}`]: T[K];
};

// Filter keys by value type
type KeysOfType<T, V> = {
  [K in keyof T]: T[K] extends V ? K : never;
}[keyof T];
```

## Branded types

```typescript
// Nominal typing via brand
type UserId = string & { readonly __brand: 'UserId' };
type ProductId = string & { readonly __brand: 'ProductId' };

function createUserId(id: string): UserId {
  return id as UserId;
}

function getUser(id: UserId): User { /* ... */ }
// getUser("abc") — type error ✓
// getUser(createUserId("abc")) — works ✓

// Alternative: branded type with class
class Brand<T extends string> {
  private readonly __brand!: T;
}

type Email = string & Brand<'Email'>;
```

## Discriminated unions

```typescript
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

function handleResult(result: Result<User>) {
  if (result.success) {
    result.data;  // User — narrowed
  } else {
    result.error;  // Error — narrowed
  }
}

// Exhaustive check
function assertNever(value: never): never {
  throw new Error(`Unexpected value: ${value}`);
}
```

## Declaration files (.d.ts)

```typescript
// Module augmentation
declare module 'some-library' {
  export interface Options {
    newOption?: boolean;
  }
}

// Global augmentation
declare global {
  interface Window {
    myApp: { version: string };
  }
}

// Ambient module declarations
declare module '*.svg' {
  const content: string;
  export default content;
}

// Ambient types
interface ProcessEnv {
  NODE_ENV: 'development' | 'production' | 'test';
  API_KEY: string;
}
```

## Module resolution

| Strategy | When to use |
|----------|-------------|
| `node` | Legacy Node.js (CommonJS) |
| `node16` | Node.js with ESM (`.mjs`, `package.json` `"type": "module"`) |
| `nodenext` | Latest Node.js ESM support |
| `bundler` | Vite, esbuild, Webpack (modern, permissive) |
| `classic` | Legacy — avoid |

```json
// Recommended for new projects using Vite/Next/tsup
{
  "compilerOptions": {
    "module": "ESNext",
    "moduleResolution": "bundler"
  }
}

// Recommended for Node.js libraries
{
  "compilerOptions": {
    "module": "NodeNext",
    "moduleResolution": "NodeNext"
  }
}
```

## Advanced patterns

### Builder pattern

```typescript
class QueryBuilder<T extends Record<string, any>> {
  private conditions: Partial<T> = {};

  where<K extends keyof T>(key: K, value: T[K]): this {
    this.conditions[key] = value;
    return this;
  }

  build(): Partial<T> {
    return { ...this.conditions };
  }
}
```

### Type-safe event emitter

```typescript
type EventMap = {
  click: { x: number; y: number };
  focus: { element: HTMLElement };
  data: { payload: unknown };
};

class TypedEmitter {
  private listeners = new Map<string, Set<Function>>();

  on<K extends keyof EventMap>(
    event: K,
    handler: (data: EventMap[K]) => void
  ): void {
    // ...
  }

  emit<K extends keyof EventMap>(event: K, data: EventMap[K]): void {
    // ...
  }
}
```

### Fluent API with `this` typing

```typescript
class Pipeline<T> {
  constructor(private value: T) {}

  pipe<U>(fn: (value: T) => U): Pipeline<U> {
    return new Pipeline(fn(this.value));
  }

  getValue(): T {
    return this.value;
  }
}
```

## Common pitfalls

- **`any` is not a solution**: It disables type checking entirely. Use `unknown` and narrow it, or `@ts-expect-error` for unavoidable cases.
- **`as` casts hide real bugs**: Prefer type narrowing (`typeof`, `instanceof`, discriminated unions) over type assertions.
- **`!` non-null assertion**: `x!.foo` — use only when you're certain and the checker can't prove it. Prefer early returns or guards.
- **`{}` type is not `object`**: `{}` is "anything except null/undefined". Use `Record<string, never>` or `object`.
- **`ts-ignore` vs `ts-expect-error`**: Use `@ts-expect-error` — it errors if the line *stops* having an error, preventing stale suppressions.
- **`enum` vs `as const`**: Prefer `const` objects with `as const` for better tree-shaking and type narrowing.
- **Excess property checks**: They only apply when assigning an object literal directly. Assigning a variable bypasses them.
- **`keyof` without `string` constraint**: `keyof` includes `symbol | string | number`. Use `keyof T & string` for string-only keys.

## Reference

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/)
- [TypeScript Playground](https://www.typescriptlang.org/play/)
- [Type Challenges](https://github.com/type-challenges/type-challenges) — practice advanced types
- [tsconfig.json Reference](https://www.typescriptlang.org/tsconfig/)
- [TypeScript Release Notes](https://devblogs.microsoft.com/typescript/)
