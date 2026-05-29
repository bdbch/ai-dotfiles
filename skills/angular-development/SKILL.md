---
name: "Angular Development"
description: "Build Angular 17+ applications — standalone components, signals, RxJS, DI, change detection, and templates."
---

# Angular Development

> Build Angular 17+ applications — standalone components, signals, RxJS, DI, change detection, and templates.

## When to use

Use this skill when working with Angular-specific code: components, services, modules, routes, signals, RxJS, or Angular patterns.

## Core principles

### Standalone vs NgModules
- Prefer standalone components by default
- Keep NgModules only for lazy-loaded feature routing or library boundaries
- Use `bootstrapApplication` with `ApplicationConfig`
- Use `provideRouter`, `provideHttpClient`

### Signals (Angular 16+)
- `signal()` for writable state, `computed()` for derived, `effect()` for side effects
- Use `.set()`, `.update()`, `.mutate()` for updates
- Use `input()` and `output()` over `@Input()`/`@Output()` decorators
- Use `model()` for two-way binding
- `linkedSignal()` (Angular 19+) for writable derived signals

### RxJS
- Core: `Observable`, `Subject`, `BehaviorSubject`, `ReplaySubject`
- Essential operators: `map`, `filter`, `switchMap`, `mergeMap`, `concatMap`, `exhaustMap`, `catchError`, `takeUntil`, `debounceTime`, `combineLatest`, `forkJoin`
- Use `| async` pipe or `toSignal()` — avoid manual `.subscribe()` in components
- Use `takeUntilDestroyed()` or `takeUntil` + `Subject` for cleanup

### Change detection
- Push for `ChangeDetectionStrategy.OnPush` on every component
- Signals enable zoneless Angular — only components reading changed signals re-check
- Know `detectChanges()` vs `markForCheck()`

### Templates and control flow (Angular 17+)
- Use `@if`, `@for`, `@switch` over `*ngIf`/`*ngFor`/`*ngSwitch`
- `track` is mandatory in `@for`
- Avoid method calls in templates — they run on every CD cycle

### Dependency injection
- Use `providedIn: 'root'` for tree-shakeable singletons
- Use `inject()` instead of constructor injection for new code
- Use `@Self`, `@SkipSelf`, `@Optional`, `@Host` for resolution control
- Use `InjectionToken` for non-class dependencies

### Forms
- Prefer reactive forms for complex, template-driven for simple
- Never mix both in the same form
- Use typed forms: `FormGroup<{ name: FormControl<string> }>`

### Routing
- `loadComponent()` for lazy standalone components
- Prefer functional guards and resolvers
- Use `withComponentInputBinding()` for route params → inputs

### State management hierarchy
1. Signals + services for local to app-wide state
2. `toSignal` + RxJS for async state
3. External stores (NgRx, NgXS) only when justified by scale

## What to do before coding

1. Read existing Angular files to understand patterns (standalone vs NgModule, signals vs RxJS)
2. Check package.json for Angular version and existing dependencies
3. Understand the change detection strategy in use
