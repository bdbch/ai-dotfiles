# Opencode Configuration

The opencode configuration lives in `.config/opencode/` and is the primary setup for this project.

## File Structure

```
.config/opencode/
├── opencode.json          # Main configuration
├── package.json           # Plugin dependencies
├── AGENTS.md              # Agent working style rules
├── agents/                # Agent definitions (symlinked from agents/)
├── skills/                # Skill bundles (symlinked from skills/)
└── node_modules/          # Installed dependencies
```

## opencode.json

```json
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "plan",
  "plugin": [],
  "mcp": {
    "Google Chrome MCP": {
      "type": "local",
      "command": ["npx", "chrome-devtools-mcp@latest"]
    },
    "Linear MCP": {
      "type": "local",
      "enabled": false,
      "command": ["npx", "-y", "mcp-remote", "https://mcp.linear.app/mcp"]
    },
    "Notion": {
      "type": "remote",
      "enabled": false,
      "url": "https://mcp.notion.com/mcp",
      "oauth": {}
    }
  }
}
```

### Key settings

- **default_agent**: `plan` — starts every conversation in planning mode
- **Google Chrome MCP**: enabled by default for browser automation
- **Linear MCP**: included but disabled — toggle via `/mcps` in opencode
- **Notion MCP**: included but disabled — requires OAuth login on first run via `opencode mcp auth Notion`

## Package Dependencies

```json
{
  "dependencies": {
    "@opencode-ai/plugin": "1.14.50"
  }
}
```

The opencode plugin system and Chrome DevTools MCP integration are installed via npm:

```bash
cd ~/.config/opencode && npm install
```

## MCP Configuration

Three MCP servers are configured:

| MCP | Status | Purpose |
|-----|--------|---------|
| Google Chrome MCP | Enabled | Browser automation, debugging, testing |
| Linear MCP | Disabled | Issue tracking integration |
| Notion MCP | Disabled | Documentation and notes |

Enable/disable MCPs at any time using `/mcps` in opencode.
