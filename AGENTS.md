# Coding Guidelines for Agents

## Rules

- Agents should only write comments where they are absolutely needed, specifically where a non-AI developer would struggle to understand the code or its purpose.
  - Code lines must never exceed 2 lines.
  - English should be simple and easy to read.
  - Good example:
    ```
    // We need to verify that window.DOMParser exists here,
    // otherwise server-side solutions will run into issues.
    ```

