param()

# Self-handle execution policy
$policy = Get-ExecutionPolicy
if ($policy -eq 'Restricted' -or $policy -eq 'AllSigned') {
    Write-Host "Execution policy is '$policy'. Re-launching with bypass..."
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Wait
    exit
}

$ErrorActionPreference = 'Stop'

# Find repo root
$repoRoot = & git rev-parse --show-toplevel 2>$null
if (-not $repoRoot) {
    Write-Error "Error: This script must be run from within a git repository."
    exit 1
}

$claudeDir = Join-Path $env:USERPROFILE ".claude"
$claudeMd = Join-Path $env:USERPROFILE "CLAUDE.md"
$backupBase = Join-Path $env:USERPROFILE ".backups"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

# --- Handle ~\.claude directory ---
if (Test-Path $claudeDir) {
    $item = Get-Item $claudeDir
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Existing Claude configuration is a junction. Removing it."
        Remove-Item $claudeDir -Force
    } else {
        $backupDir = Join-Path $backupBase ".claude_backup_$timestamp"
        Write-Host "Existing Claude configuration found. Backing up to $backupDir"
        New-Item -ItemType Directory -Path $backupBase -Force | Out-Null
        Move-Item -Path $claudeDir -Destination $backupDir
        Write-Host "Backup completed."
    }
}

Write-Host "Creating junction for Claude configuration..."
New-Item -ItemType Junction -Path $claudeDir -Target (Join-Path $repoRoot ".config" "claude") | Out-Null

# --- Handle ~\CLAUDE.md ---
$claudeMdBackedUp = $false
if (Test-Path $claudeMd) {
    $item = Get-Item $claudeMd
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Existing CLAUDE.md is a link. Removing it."
        Remove-Item $claudeMd -Force
    } else {
        $backupMdDir = Join-Path $backupBase ".claude_backup_$timestamp"
        Write-Host "Existing CLAUDE.md file found. Backing up to $backupMdDir"
        New-Item -ItemType Directory -Path $backupMdDir -Force | Out-Null
        Move-Item -Path $claudeMd -Destination (Join-Path $backupMdDir "CLAUDE.md")
        $claudeMdBackedUp = $true
        Write-Host "Backup completed."
    }
}

Write-Host "Creating CLAUDE.md from AGENTS.md..."
Copy-Item -Path (Join-Path $repoRoot "AGENTS.md") -Destination $claudeMd -Force

Write-Host "Claude configuration has been set up successfully."
Write-Host "You can find the new configuration at $claudeDir"
