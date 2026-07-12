---
name: "react-development"
description: "Build, modify, and debug React 18/19+ applications — hooks, RSC, concurrent features, composition, and testing."
---

# React Development

> Build, modify, and debug React 18/19+ applications — hooks, RSC, concurrent features, composition, and testing.

## When to use

Use this skill when working with React-specific code: components, hooks, context, routes, Server Components, or React patterns.

## Core principles

### Hooks API
- Follow the rules of hooks by heart
- Understand closure capture in effects and callbacks
- Know timing: `useEffect` (passive, after paint), `useLayoutEffect` (sync, before paint), `useInsertionEffect` (CSS-in-JS)
- Use `useSyncExternalStore` for external stores that can tear
- Use `useDeferredValue` and `useTransition` for responsive UI during expensive renders
- Use `useId` for accessible SSR attribute generation

### Performance
- Evaluate memoization cost-benefit honestly
- `React.memo` compares props by reference — inline objects/functions break it
- `useMemo`/`useCallback` have allocation cost — only apply when child benefits
- Context triggers re-render of all consumers on value change — split by update frequency
- Use `React.lazy`, `next/dynamic`, and server components for code splitting

### Server Components (RSC)
- Server components run once on server, never hydrate
- Client components marked with `"use client"`, ship as normal bundles
- Never serialize functions, Dates, Maps across the boundary
- Push back when `"use client"` is placed too high or too deep
- Async server components can `await` data directly

### Concurrent Features
- Use `useTransition` for non-urgent, interruptible state updates
- Use `useDeferredValue` to defer stale values
- Use `startTransition` outside components (data loading libraries)
- Concurrent rendering is opt-in via transitions

### Composition patterns
- Prefer composition over inheritance or monolithic props
- Use compound components for tightly coupled UIs
- Use controlled vs uncontrolled with `defaultValue` for uncontrolled
- Use state reducers when consumers need fine-grained control

### State management hierarchy
1. Local `useState` / `useReducer`
2. Lifting state + props/children composition
3. Context with memoized values (tree-wide, low-frequency state)
4. External library (Zustand, Jotai, Redux) only when justified

### Testing
- Test behavior, not implementation
- Use React Testing Library: render, find by role/label/text, fire events, assert DOM
- Handle async with `waitFor` or `findBy*`
- For RSC, mock server component boundaries

### Styling
- Prefer zero-runtime solutions (CSS Modules, Tailwind, vanilla-extract)
- Flag runtime CSS-in-JS cost when it matters

## What to do before coding

1. Read existing React files to understand patterns (hooks, context, state management)
2. Check package.json for React version and existing dependencies
3. Understand if this is a client component, server component, or shared
