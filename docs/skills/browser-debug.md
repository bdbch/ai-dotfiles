# Browser Debug

Open a website in the browser and use DevTools to diagnose console errors, network issues, performance regressions, accessibility problems, and other runtime issues.

## When to Use

- Investigating console errors or warnings
- Debugging network request failures or slow API calls
- Diagnosing performance regressions (slow load, jank, layout shifts)
- Identifying accessibility violations
- Understanding JavaScript runtime errors
- Analyzing memory leaks or heap usage
- Investigating CSS rendering issues

## Debug Process

1. **Get the URL** from the user
2. **Open the page** in a fresh tab (avoids stale state)
3. **Wait for full load** using text indicators
4. **Check console messages** — errors, warnings, assertions
5. **Inspect network requests** — filter by failures, slow requests, unexpected types
6. **Examine request details** — headers, payload, response body
7. **Run performance trace** for load or interaction issues
8. **Take memory snapshot** for leak investigation
9. **Check accessibility** for violations

## Output

- **Issue Summary** — what was found and where
- **Root Cause** — why the issue occurs
- **Evidence** — console logs, network data, trace screenshots
- **Fix Recommendation** — actionable next steps
