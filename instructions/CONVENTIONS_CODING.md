# Coding Conventions

## Clean Code

Code must be easy to read and understand at a glance. No long if/else
chains, no deeply nested conditionals, no mile-long switch cases.
Every function should do one thing and do it well — if a function
needs a scrollbar, split it.

## SOLID and DRY

Single responsibility, open/closed, Liskov substitution, interface
segregation, dependency inversion — as practical guidelines, not
dogma. Avoid meaningful duplication. Extract shared logic when the
abstraction has a clear name and purpose. Do not extract just because
two blocks look similar.

## File Length

No file should exceed **200 lines** of meaningful code (excluding blanks and comments).
If a file approaches this limit, split it. Extract related logic into a separate
module and import it. Long files are a sign that a module has too many
responsibilities — splitting forces better boundaries and keeps each unit
easy to read, test, and reason about.

## Modularity

Move things apart. Small files, focused utilities, narrow interfaces.
A module should be easy to delete or replace. Prefer composition over
inheritance. Make invalid states hard to represent.
