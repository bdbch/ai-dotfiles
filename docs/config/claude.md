# Claude Configuration

The Claude Desktop configuration lives in `.config/claude/` and mirrors the opencode agent setup.

## File Structure

```
.config/claude/
├── settings.json          # Plugin and behavior settings
├── AGENTS.md              # Agent working style rules
├── agents/                # Agent definitions (18 agents)
├── skills/                # Skill bundles
└── ...                    # Cache, sessions, telemetry, etc.
```

## settings.json

```json
{
  "enabledPlugins": {
    "superpowers@claude-plugins-official": true,
    "feature-dev@claude-plugins-official": true,
    "github@claude-plugins-official": true,
    "code-simplifier@claude-plugins-official": true,
    "pr-review-toolkit@claude-plugins-official": true
  },
  "alwaysThinkingEnabled": true,
  "effortLevel": "medium"
}
```

### Key settings

- **alwaysThinkingEnabled**: `true` — shows Claude's reasoning process
- **effortLevel**: `medium` — balanced between speed and quality
- **Plugins**: GitHub integration, code simplification, PR review toolkit, feature dev, and superpowers are enabled

## Agent Support

Claude supports the same 18 agents as opencode, defined as Markdown files in `.config/claude/agents/`. These are direct copies (not symlinks) of the agent definitions from `agents/`.

The shared working style is loaded from `AGENTS.md` at the Claude config root.
