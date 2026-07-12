---
name: "rust-development"
description: "Write expert Rust code — ownership, borrowing, lifetimes, async, error handling, and systems programming."
---

# Rust Development

> Write expert Rust code — ownership, borrowing, lifetimes, async, error handling, and systems programming.

## When to use

Use this skill when writing, modifying, or reviewing Rust code: systems programming, CLI tools, libraries, FFI, or performance-critical code.

## Core principles

### Ownership and borrowing
- Prioritize safety, correctness, and performance in that order
- Adhere to ownership, borrowing, lifetimes, and zero-cost abstractions
- When using `unsafe`, justify necessity and ensure invariants are upheld
- Prefer safe abstractions from std or well-vetted crates

### Error handling
- Use `Result` and `Option` — avoid `unwrap`/`expect` in library code
- Prefer `thiserror` for library errors, `anyhow` for application errors
- Propagate errors with `?` operator

### Concurrency
- Use appropriate models: threads, async, channels, locks
- Be mindful of OS-specific primitives (epoll, kqueue, IOCP)
- Use `tokio` for async runtime, `rayon` for parallelism

### FFI
- Ensure correct ABI, use `#[repr(C)]`
- Handle safety at boundaries
- Prefer `bindgen` or `cbindgen`

### Performance
- Profile and benchmark before optimizing
- Use `#[inline]`, `const fn`, manual SIMD only when proven necessary
- Consider portability with platform-optimized paths when needed

### Idiomatic patterns
- Use `serde` for serialization
- Use `clap` for CLI argument parsing
- Use `tokio` for async I/O
- Use `rayon` for data parallelism
- Leverage the type system for correctness (newtypes, phantom data)

### Error context
- Provide doc comments explaining invariants, safety preconditions, and purpose
- Use meaningful error messages that help debugging

## What to do before coding

1. Read existing Rust code to understand patterns and conventions
2. Check Cargo.toml for existing dependencies and features
3. Understand the target OS and environment
4. Check if the project uses workspace structure
