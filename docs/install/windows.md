# Windows Installation

Windows requires different setup steps because it doesn't support UNIX-style symlinks natively. Use **PowerShell** (not CMD) for the commands below.

> **Tip:** Windows 10/11 with **Developer Mode** enabled supports native symlinks without admin privileges. Otherwise, run PowerShell as Administrator.

## Option 1: Clone to the Right Path (No Symlinks)

Clone the repository directly where each tool expects its config to live. This avoids symlinks entirely but means you have separate clones if you use multiple tools.

```powershell
# opencode
git clone https://github.com/bdbch/ai-dotfiles.git "$env:USERPROFILE\.config\opencode"
```

For Claude or Codex, clone the whole repo and point the tool at the relevant subdirectory.

## Option 2: Directory Junctions (Recommended)

Use `mklink /J` (directory junction) — works on all modern Windows without Developer Mode, though PowerShell must be run as Administrator.

Clone the repo to a permanent location first:

```powershell
git clone https://github.com/bdbch/ai-dotfiles.git C:\dev\ai-dotfiles
```

Then create junctions for each tool:

### opencode

```powershell
mklink /J "%USERPROFILE%\.config\opencode" "C:\dev\ai-dotfiles\.config\opencode"
```

After creating the junction, copy the base config to create your editable config:

```powershell
copy "$env:USERPROFILE\.config\opencode\opencode.base.json" "$env:USERPROFILE\.config\opencode\opencode.json"
```

Edit `opencode.json` freely — it's git-ignored and won't be overwritten.

### Claude

```powershell
mklink /J "%USERPROFILE%\.claude" "C:\dev\ai-dotfiles\.config\claude"
mklink "%USERPROFILE%\CLAUDE.md" "C:\dev\ai-dotfiles\AGENTS.md"
```

### Codex

```powershell
mklink /J "%USERPROFILE%\.codex" "C:\dev\ai-dotfiles\.config\codex"
mkdir "%USERPROFILE%\.agents" 2>$null
mklink /J "%USERPROFILE%\.agents\skills" "C:\dev\ai-dotfiles\skills"
```

### Copilot

```powershell
mklink /J "%USERPROFILE%\.copilot" "C:\dev\ai-dotfiles\.config\copilot"
```

## Dependencies

After installing, install the opencode plugin dependencies:

```powershell
cd "$env:USERPROFILE\.config\opencode"
npm install
```

This installs the opencode plugin system and Chrome DevTools MCP integration.

## Verify

```powershell
dir "$env:USERPROFILE\.config\opencode"
dir "$env:USERPROFILE\.config\opencode\node_modules\.package-lock.json"
```
