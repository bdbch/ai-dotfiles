# Windows Installation

Windows requires different setup steps because it doesn't support UNIX-style symlinks natively. Use **PowerShell** (not CMD) for the commands below.

> **Tip:** Windows 10/11 with **Developer Mode** enabled supports native symlinks without admin privileges. Otherwise, run PowerShell as Administrator.

## Option 1: Clone to the Right Path (No Symlinks)

Clone the repository directly where opencode expects its config. This avoids symlinks entirely.

```powershell
git clone https://github.com/bdbch/ai-dotfiles.git "$env:USERPROFILE\.config\opencode"
```

## Option 2: Directory Junctions (Recommended)

Use `mklink /J` (directory junction) — works on all modern Windows without Developer Mode, though PowerShell must be run as Administrator.

Clone the repo to a permanent location first:

```powershell
git clone https://github.com/bdbch/ai-dotfiles.git C:\dev\ai-dotfiles
```

Then create individual junctions for each config item:

```powershell
:: Create the opencode config directory
mkdir "%USERPROFILE%\.config\opencode"

:: Individual file junctions
mklink "%USERPROFILE%\.config\opencode\opencode.jsonc" "C:\dev\ai-dotfiles\opencode.jsonc"
mklink "%USERPROFILE%\.config\opencode\opencode.base.json" "C:\dev\ai-dotfiles\opencode.base.json"
mklink "%USERPROFILE%\.config\opencode\AGENTS.md" "C:\dev\ai-dotfiles\instructions\README.md"
mklink /J "%USERPROFILE%\.config\opencode\instructions" "C:\dev\ai-dotfiles\instructions"
mklink /J "%USERPROFILE%\.config\opencode\agents" "C:\dev\ai-dotfiles\agents"
mklink /J "%USERPROFILE%\.config\opencode\skills" "C:\dev\ai-dotfiles\skills"
```

Create your personal config from the base template:

```powershell
copy "$env:USERPROFILE\.config\opencode\opencode.base.json" "$env:USERPROFILE\.config\opencode\opencode.json"
```

Edit `opencode.json` freely — it's git-ignored and won't be overwritten.

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
