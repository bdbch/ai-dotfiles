---
name: "svelte-development"
description: "Build Svelte 5 applications — runes, compiler model, fine-grained reactivity, and SvelteKit."
---

# Svelte Development

> Build Svelte 5 applications — runes, compiler model, fine-grained reactivity, and SvelteKit.

## When to use

Use this skill when working with Svelte-specific code: components, stores, reactivity, transitions, SvelteKit routing, or Svelte patterns.

## Core principles

### Runes (Svelte 5+)
- `$state` for reactive state — mutations are reactive by default
- `$derived` for derived value — lazy, recomputes on dependency change
- `$effect` for side effects with auto-tracking
- `$props()` for component props as reactive object
- `$bindable()` for two-way binding props
- Runes work in `.svelte.js` and `.svelte.ts` modules

### Classic Svelte (Svelte 4)
- `$:` for reactive declarations
- `export let` for props
- Migration: `$:` → `$derived`, `export let` → `$props()`, reactive assignments → `$state`

### Derived state
- `$derived` for values depending on reactive state
- `$derived.by` for multi-statement derivations
- Never use `$effect` for derived state — use `$derived` instead
- Never use `$effect` for computed values in templates

### Props and component API
- Destructure props from `$props()`
- `$bindable()` for bindable props via `bind:`
- `{#snippet}` and `{@render}` instead of `<slot>` (Svelte 5)

### Stores (legacy, still valid)
- Store contract: object with `subscribe` method
- `writable`, `derived`, `readable`
- `$store` auto-subscription in `.svelte` files
- Prefer runes for new code, don't force-migrate stores

### Control flow
- `{#if}`, `{:else if}`, `{:else}` for conditionals
- `{#each items as item, index (key)}` with keyed iteration
- `{#await promise}` for promises
- `{#key expression}` to destroy/recreate on change

### SvelteKit conventions
- File-based routing: `+page.svelte`, `+layout.svelte`, `+server.js`
- `load` functions for data loading (client and server)
- Server load: `+page.server.js` — runs on server only
- Form actions: `export const actions = { ... }` in `+page.server.js`
- `use:enhance` for progressive form enhancement
- `$page` store for reactive page data
- `$lib/server` for server-only modules

### Transitions and animations
- `transition:fade`, `transition:slide`, `transition:scale`
- `in:fly`, `out:fly` for separate in/out
- `animate:flip` for list reorder animations

### Scoped CSS
- Styles scoped by default in `.svelte` files
- `:global()` to escape scoping intentionally

## What to do before coding

1. Read existing Svelte files to understand patterns (runes vs legacy, stores usage)
2. Check if using SvelteKit or standalone Svelte
3. Check Svelte version (5 runes vs 4 legacy syntax)
