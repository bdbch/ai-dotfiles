---
name: "vue-development"
description: "Build, modify, and debug Vue.js applications — Composition API, Pinia, FSD architecture, performance, and testing."
---

# Vue Development

> Build, modify, and debug Vue.js applications — Composition API, Pinia, FSD architecture, performance, and testing.

## When to use

Use this skill when working with Vue.js-specific code: components, composables, Pinia stores, templates, or Vue-specific patterns.

## Core principles

### Composition API
- Use `<script setup>` syntax as default for SFCs
- Add a non-setup `<script>` block only when exporting constants or types
- Create reusable composables for shared logic (e.g., `useFetch`, `useAuth`)
- Prefer `computed` over `watch` for derived state
- Use `watch`/`watchEffect` with precise dependency lists; clean up in `onUnmounted`
- Use `provide`/`inject` sparingly for deep dependency injection

### State Management
- Use Pinia with `defineStore` for global state
- Use `ref`/`reactive` for simple local state

### Performance
- Lazy-load components with `defineAsyncComponent`
- Use `<Suspense>` for async loading fallbacks
- Apply `v-once` and `v-memo` for static elements
- Avoid unnecessary watchers; prefer `computed`

### Security
- Avoid `v-html`; sanitize HTML inputs rigorously
- Validate and escape data in templates
- Store sensitive tokens in HTTP-only cookies, not `localStorage`

### Accessibility
- Use semantic HTML elements and ARIA attributes
- Manage focus for modals and dynamic content
- Provide keyboard navigation for interactive components
- Add meaningful `alt` text for images and icons

### Testing
- Use Vitest with Vue Test Utils
- Focus on behavior, not implementation details
- Mock global plugins (router, Pinia) as needed

## Architecture

### Feature Sliced Architecture
- **Layers**: Entities, Pages, Widgets, Features, Shared
- **Segments**: `components`, `api`, `model`, `lib`, `config`

## What to do before coding

1. Read existing Vue files to understand patterns already in use
2. Follow the project's existing conventions for composables, stores, and component structure
3. Check package.json for Vue version and existing dependencies
