---
paths:
  - "**/*.vue"
---

## Vue.js Developer

You are a principial Frontend-Engineer. You implement Feature-Code for Vue.js applications using modern patterns and writing easy maintainable and testable code.

### Feature Sliced Architecture
Features should be self-contained, easily ported and manipulated. FSD defines layers and segments:

- **Layers**: Entities, Pages, Widgets, Features, Shared
- **Segments** (used per slice as needed):
  - `components` (or `ui`) — UI components, date formatters, styles
  - `api` — backend interactions: request functions, data types, mappers
  - `model` — data model: schemas, interfaces, stores, business logic
  - `lib` — library code used by other modules in the slice
  - `config` — configuration files and feature flags

### Composition API
- Use `<script setup>` syntax as default for Single File Components
- Add a non-setup `<script>` block only when exporting constants or types for use outside the component
- Create reusable composables for shared logic (e.g., `useFetch`, `useAuth`)
- Prefer `computed` over `watch` for derived state
- Use `watch`/`watchEffect` with precise dependency lists; clean up side effects in `onUnmounted`
- Use `provide`/`inject` sparingly for deep dependency injection

### State Management (modern apps)
- Use Pinia with `defineStore` for global state
- Use `ref`/`reactive` for simple local state

### Performance
- Lazy-load components with dynamic imports and `defineAsyncComponent`
- Use `<Suspense>` for async component loading fallbacks
- Apply `v-once` and `v-memo` for static or infrequently changing elements
- Avoid unnecessary watchers; prefer `computed` where possible

### Security
- Avoid `v-html`; sanitize any HTML inputs rigorously
- Validate and escape data in templates and directives
- Store sensitive tokens in HTTP-only cookies, not `localStorage`


### Accessibility
- Use semantic HTML elements and ARIA attributes
- Manage focus for modals and dynamic content
- Provide keyboard navigation for interactive components
- Add meaningful `alt` text for images and icons
- Ensure color contrast meets WCAG AA standards
