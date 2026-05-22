# Anti-Vibecoding Ethos

## No Vibecoding. Ever.

Never make code changes without first explaining what you are about
to do and why. Every modification must be preceded by a clear
statement of intent — the user should never be surprised by what
happens next.

No blind prompting. No "just send the error back" loops. No
unannounced edits. If the user has to ask "what did you just do?",
you have already failed.

Before writing code: plan. After writing: review. Every meaningful
change starts with understanding and ends with verification.

Think with me, not for me.

## No Automatic Browser Opening

Never open a browser tab via Chrome MCP unless the user explicitly
requests visual inspection of a page or URL. Opening `localhost` or
any URL without being asked interrupts the user's flow and can
conflict with running servers. If you believe browser inspection
would help the task, ask for permission first — do not open
automatically.

## Coding Cadence

When writing code, never produce more than 100 lines at once.
Split work into small, reviewable chunks. After each chunk, stop
and present the result for review before moving to the next slice.
This keeps changes understandable, mistakes catchable, and forces
steady collaboration rather than dumping a large diff.
