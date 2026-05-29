---
name: "Solid.js Development"
description: "Build Solid.js applications — fine-grained reactivity, signals, effects, stores, and SolidStart."
---

# Solid.js Development

> Build Solid.js applications — fine-grained reactivity, signals, effects, stores, and SolidStart.

## When to use

Use this skill when working with Solid.js-specific code: signals, effects, components, stores, or SolidStart.

## Core principles

### Reactivity model
- Fine-grained reactivity — no virtual DOM, no diffing, no re-rendering
- Components run once to set up reactive subscriptions
- `createSignal` returns `[get, set]` — getter is reactive
- `createMemo` for derived state with lazy evaluation and caching
- `createEffect` runs after DOM updates, auto-tracks dependencies

### Signals and state
- `createSignal` — setting to same value doesn't trigger unless `equal: false`
- `createStore` for deeply nested reactive objects — path-level granularity
- Use `setStore` with path syntax for specific updates
- `produce` for immutable-style updates with mutable syntax

### Effects and lifecycles
- `createEffect` for post-DOM side effects with auto-tracking
- `createRenderEffect` for synchronous effects (before paint)
- `onMount` runs once after initial render
- `onCleanup` for disposal in components, effects, and handlers
- `onError` to catch errors in reactive boundaries

### Control flow
- Use built-in: `<For>`, `<Show>`, `<Switch>/<Match>`, `<Index>`, `<Dynamic>`
- `<For>` uses reference-based keying, `<Index>` for index-based
- Compiler marks control flow boundaries for fine-grained updates

### Resources and Suspense
- `createResource` for async data — returns `[data, { mutate, refetch, loading, error }]`
- Resources are keyed by source signal and refetch on source change
- `<Suspense>` with fallback — simpler than React's Suspense

### Composition patterns
- Use `children` prop and slot-like patterns
- Context via `createContext`/`useContext` for DI, not state management
- Use `splitProps` for passthrough props
- Never create components inside reactive scopes

### Performance
- Think in subscription granularity, not re-renders
- Split coarse signals into finer-grained ones
- Use `createMemo` to narrow reactive dependencies
- Prefer local signals over context for non-global state

### Styling
- `classList` for conditional classes
- `style` as object for dynamic styles
- Zero runtime CSS-in-JS cost — no re-renders to trigger recomputation

## What to do before coding

1. Read existing Solid.js files to understand patterns (signals vs stores, context usage)
2. Check package.json for Solid version and existing dependencies
3. Never think in "re-renders" — Solid doesn't re-render components
