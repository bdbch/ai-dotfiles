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

$opencodeDir = Join-Path $env:USERPROFILE ".config" "opencode"
$backupBase = Join-Path $env:USERPROFILE ".backups"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

# Backup or remove existing opencode config
if (Test-Path $opencodeDir) {
    $item = Get-Item $opencodeDir
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Existing Opencode configuration is a junction. Removing it."
        Remove-Item $opencodeDir -Force
    } else {
        $backupDir = Join-Path $backupBase ".config" "opencode_backup_$timestamp"
        Write-Host "Existing Opencode configuration found. Backing up to $backupDir"
        New-Item -ItemType Directory -Path (Split-Path $backupDir -Parent) -Force | Out-Null
        Move-Item -Path $opencodeDir -Destination $backupDir
        Write-Host "Backup completed."
    }
}

# Create junction
Write-Host "Creating junction for Opencode configuration..."
$parentDir = Split-Path $opencodeDir -Parent
New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
New-Item -ItemType Junction -Path $opencodeDir -Target (Join-Path $repoRoot ".config" "opencode") | Out-Null

Write-Host "Opencode configuration has been set up successfully."
Write-Host "You can find the new configuration at $opencodeDir"
