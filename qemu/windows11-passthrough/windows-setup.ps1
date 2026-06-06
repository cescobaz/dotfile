<#
  Native Windows dev environment bootstrap (no WSL).

  Installs, as real Windows binaries:
    git, neovim, zig, rsync, wget, starship, fzf, ripgrep, fd  (via Scoop)
    PowerShell 7 + Windows Terminal                            (via winget)
    a Nerd Font for the prompt / nvim icons
  ssh CLIENT and curl are already built into Windows.
  ssh SERVER needs admin — see the commented block at the bottom.

  HOW TO RUN (in a NON-admin PowerShell window):
    powershell -ExecutionPolicy Bypass -File .\windows-setup.ps1
  or, if you already have pwsh 7:
    pwsh     -ExecutionPolicy Bypass -File .\windows-setup.ps1
#>

$ErrorActionPreference = 'Stop'

function Update-SessionPath {
    # Scoop/winget edit the persisted PATH; pull it into THIS session so the
    # newly-installed shims (e.g. `scoop`, `pwsh`) are callable immediately.
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'User') + ';' +
                [Environment]::GetEnvironmentVariable('Path', 'Machine')
}

# --- Guard: Scoop refuses to install from an elevated prompt ---
$isAdmin = ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($isAdmin) {
    Write-Error "Run this in a NON-admin PowerShell. Scoop will not install when elevated."
    exit 1
}

# --- 1. Scoop (user-scoped package manager) ---
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..." -ForegroundColor Cyan
    # No Set-ExecutionPolicy needed: this script only runs at all when the
    # policy already permits it (you launch it with -ExecutionPolicy Bypass),
    # and the install below runs in-session, so the persisted policy is moot.
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    Update-SessionPath
}
scoop --version

# --- 2. Buckets (2>$null swallows the harmless "already added") ---
foreach ($bucket in 'main', 'extras', 'nerd-fonts') {
    scoop bucket add $bucket 2>$null
}

# --- 3. CLI tools ---
scoop install git neovim zig wget starship fzf ripgrep fd
scoop install FiraCode-NF      # Nerd Font (prompt glyphs + nvim icons)
Update-SessionPath

# rsync is no longer packaged standalone in Scoop's main bucket (the old
# 'rsync'/'cwrsync' manifests were dropped over broken upstream URLs). Get it
# from MSYS2 instead - native Windows, no WSL - and shim it onto PATH.
scoop install msys2
$msys = scoop prefix msys2
# Install rsync AND the Cygwin openssh: rsync-over-ssh needs the matching
# Cygwin ssh, not Windows' native ssh.exe (the native one breaks the rsync
# protocol stream). Force it at call time with: rsync -e /usr/bin/ssh ...
& "$msys\usr\bin\bash.exe" -lc "pacman -Sy --noconfirm rsync openssh"
scoop shim add rsync "$msys\usr\bin\rsync.exe" 2>$null
Update-SessionPath

# --- 4. Microsoft first-party apps (winget) ---
if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install -e --id Microsoft.PowerShell `
        --accept-source-agreements --accept-package-agreements
    winget install -e --id Microsoft.WindowsTerminal `
        --accept-source-agreements --accept-package-agreements
    Update-SessionPath
}
else {
    Write-Warning "winget not found - install PowerShell 7 + Windows Terminal from the Microsoft Store manually."
}

# --- 5. Starship prompt -> PowerShell 7 profile ---
# Target pwsh 7's profile (not the 5.1 one this script may be running under).
$starshipLine = 'Invoke-Expression (&starship init powershell)'
try {
    $pwshProfile = (& pwsh -NoProfile -Command '$PROFILE.CurrentUserCurrentHost').Trim()
}
catch {
    $pwshProfile = $PROFILE   # fallback: current shell's profile
}
if ($pwshProfile) {
    $dir = Split-Path $pwshProfile -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    if (-not (Test-Path $pwshProfile)) { New-Item -ItemType File -Path $pwshProfile -Force | Out-Null }
    if (-not (Select-String -Path $pwshProfile -SimpleMatch $starshipLine -Quiet)) {
        Add-Content $pwshProfile $starshipLine
        Write-Host "Added Starship init to $pwshProfile" -ForegroundColor Green
    }
}

Write-Host "`nDone." -ForegroundColor Green
Write-Host "Next: open a NEW Windows Terminal tab running PowerShell 7," -ForegroundColor Green
Write-Host "and set its font to 'FiraCode Nerd Font' (Settings > Profile > Appearance)." -ForegroundColor Green

<#
  ----------------------------------------------------------------------------
  SSH SERVER (optional) - run these in an ADMIN PowerShell:

    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Start-Service sshd
    Set-Service sshd -StartupType Automatic
    # make incoming SSH land in pwsh instead of cmd.exe:
    New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell `
        -Value "$env:ProgramFiles\PowerShell\7\pwsh.exe" -PropertyType String -Force

  To reach this guest's sshd FROM the Linux host, the VM's user-mode NAT needs
  a port-forward. Add to the -netdev line in run.sh:
      -netdev user,id=net0,hostfwd=tcp::2222-:22
  then from the host:  ssh -p 2222 <winuser>@localhost
  ----------------------------------------------------------------------------
#>
