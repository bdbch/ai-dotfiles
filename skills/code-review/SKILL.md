---
name: "code-review"
description: "Review Code and provide feedback around best practices, potential bugs or regression, and overall code quality."
---

# Code Review

> Review Code and provide feedback around best practices, potential bugs or regression, and overall code quality.

## When to use

Use this skill when you want to review code and provide feedback around best practices, potential bugs or regression, and overall code quality. This can be done after making changes to a codebase or when reviewing code from other team members. This skill can help ensure that the code is of high quality, maintainable, and follows best practices. It can also help identify potential issues early on, which can save time and resources in the long run.

## What to review

- **After a codechange is made**: Review the code changes to ensure that they are of high quality, maintainable, and follow best practices. This can help identify potential issues early on and ensure that the codebase remains healthy.
- **A Pull Request was linked**: Fetch the code changes via the Github CLI, API or WebFetch, read the PR and look at the code diff - review the code changes to ensure that they are of high quality, maintainable, and follow best practices. This can help identify potential issues early on and ensure that the codebase remains healthy.
- **A Commit was linked or mentioned**: Fetch the code changes via the Github CLI, API or WebFetch, read the commit message and look at the code diff - review the code changes to ensure that they are of high quality, maintainable, and follow best practices. This can help identify potential issues early on and ensure that the codebase remains healthy.
- **A local commit was referenced**: If the commit is local and not pushed to a remote repository, you can review the code changes by looking at the local commit history and the code diff. This can help ensure that the code changes are of high quality, maintainable, and follow best practices before they are pushed to a remote repository.
- **Other code changes were mentioned**: If other code changes were mentioned, you can review the code changes by looking at the relevant code files and the code diff. This can help ensure that the code changes are of high quality, maintainable, and follow best practices.

## What to look out for

When reviewing code, there are several things to look out for to ensure that the code is of high quality, maintainable, and follows best practices. Some of these include:

- **Code readability**: Is the code easy to read and understand? Are variable names descriptive? Is the code well-organized and structured?
- **Code maintainability**: Is the code easy to maintain and modify? Are there any potential issues that could arise in the future? Is the code modular and reusable?
- **Code performance**: Is the code efficient and performant? Are there any potential bottlenecks or performance issues? Are there any opportunities for optimization?
- **Code security**: Are there any potential security vulnerabilities in the code? Are there any best practices that should be followed to ensure that the code is secure?
- **Code consistency**: Does the code follow the established coding standards and conventions? Is the code consistent with the rest of the codebase? Are there any potential issues with code consistency that could arise in the future?
- **SOLID**: Does the code follow the SOLID principles of object-oriented design? Are there any potential issues with the code that could arise from not following these principles?
- **DRY**: Does the code follow the DRY (Don't Repeat Yourself) principle? Are there any potential issues with code duplication that could arise in the future?
- **Testing**: Are there any tests for the code changes? Are the tests comprehensive and effective? Are there any potential issues with the tests that could arise in the future?
- **Documentation**: Is the code well-documented? Are there any potential issues with the documentation that could arise in the future? Is the documentation clear and concise?
- **Potential bugs or regression**: Are there any potential bugs or regression that could arise from the code changes? Are there any edge cases that should be considered? Are there any potential issues with the code that could arise in the future?
- **Best practices**: Are there any best practices that should be followed to ensure that the code is of high quality, maintainable, and follows best practices? Are there any potential issues with the code that could arise from not following best practices?

## What to respond

Respond with a table of feedback that includes the following columns:

| File | Line Number | Issue Type | Description | Recommendation |
|------|-------------|------------|-------------|----------------|

- **File**: The name of the file where the issue was found.
- **Line Number**: The line number where the issue was found.
- **Issue Type**: The type of issue that was found (e.g. code readability issue, code maintainability issue, code performance issue, code security issue, code consistency issue, SOLID principle violation, DRY principle violation, testing issue, documentation issue, potential bug or regression, best practice violation).
- **Description**: A description of the issue that was found.
- **Recommendation**: A recommendation for how to fix the issue that was found.

Keep all descriptions and recommendations short and concise. Avoid filler words or unnecessary explanations. Focus on providing clear and actionable feedback that can help improve the code quality, maintainability, and adherence to best practices. Still explain the issue and recommendation clearly, but do so in a way that is easy to understand and implement.
