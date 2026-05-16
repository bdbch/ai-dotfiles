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

$codexDir = Join-Path $env:USERPROFILE ".codex"
$agentsDir = Join-Path $env:USERPROFILE ".agents"
$skillsDir = Join-Path $agentsDir "skills"
$backupBase = Join-Path $env:USERPROFILE ".backups"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

# Validate source directories
$codexSource = Join-Path $repoRoot ".config" "codex"
$skillsSource = Join-Path $repoRoot "skills"

if (-not (Test-Path $codexSource)) {
    Write-Error "Error: Codex source directory not found at $codexSource"
    exit 1
}

if (-not (Test-Path $skillsSource)) {
    Write-Error "Error: Skills source directory not found at $skillsSource"
    exit 1
}

# --- Handle ~\.codex directory ---
if (Test-Path $codexDir) {
    $item = Get-Item $codexDir
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Existing Codex configuration is a junction. Removing it."
        Remove-Item $codexDir -Force
    } else {
        $codexBackupDir = Join-Path $backupBase ".codex_backup_$timestamp"
        Write-Host "Existing Codex configuration found. Backing up to $codexBackupDir"
        New-Item -ItemType Directory -Path $backupBase -Force | Out-Null
        Move-Item -Path $codexDir -Destination $codexBackupDir
        Write-Host "Backup completed."
    }
}

Write-Host "Creating junction for Codex configuration..."
New-Item -ItemType Junction -Path $codexDir -Target $codexSource | Out-Null

# --- Handle ~\.agents\skills directory ---
New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null

if (Test-Path $skillsDir) {
    $item = Get-Item $skillsDir
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Existing Codex skills link is a junction. Removing it."
        Remove-Item $skillsDir -Force
    } else {
        $skillsBackupDir = Join-Path $backupBase ".agents_skills_backup_$timestamp"
        Write-Host "Existing Codex skills directory found. Backing up to $skillsBackupDir"
        New-Item -ItemType Directory -Path $backupBase -Force | Out-Null
        Move-Item -Path $skillsDir -Destination $skillsBackupDir
        Write-Host "Backup completed."
    }
}

Write-Host "Creating junction for Codex skills..."
New-Item -ItemType Junction -Path $skillsDir -Target $skillsSource | Out-Null

Write-Host "Codex configuration has been set up successfully."
Write-Host "You can find the new configuration at $codexDir"
Write-Host "You can find the linked skills at $skillsDir"
