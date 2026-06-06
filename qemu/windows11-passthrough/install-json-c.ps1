<#
  install-json-c.ps1
  Install the json-c C library on native Windows (no WSL) via MSYS2, in a form
  Zig can link (Zig builds for the windows-gnu / MinGW ABI).

  Run in a NON-admin PowerShell:
    powershell -ExecutionPolicy Bypass -File .\install-json-c.ps1
#>

$ErrorActionPreference = 'Stop'

# MSYS2 environment to install into. ucrt64 is the modern default and matches
# what Zig links against. Alternatives: 'mingw64', 'clang64'.
$Env = 'ucrt64'
$pkgPrefix = switch ($Env) {
    'ucrt64'  { 'mingw-w64-ucrt-x86_64-' }
    'mingw64' { 'mingw-w64-x86_64-' }
    'clang64' { 'mingw-w64-clang-x86_64-' }
    default   { throw "Unknown MSYS2 env '$Env'" }
}

# Ensure MSYS2 is present (installed via Scoop in windows-setup.ps1).
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    throw "Scoop not found. Run windows-setup.ps1 first."
}
scoop install msys2
$msys = scoop prefix msys2
$bash = "$msys\usr\bin\bash.exe"

# Install json-c (and pkgconf, handy for discovering the compile/link flags).
Write-Host "Installing ${pkgPrefix}json-c into MSYS2 $Env ..." -ForegroundColor Cyan
& $bash -lc "pacman -Sy --noconfirm ${pkgPrefix}json-c ${pkgPrefix}pkgconf"

# Report where it landed and the build.zig wiring.
$root = "$msys\$Env"
Write-Host "`nInstalled:" -ForegroundColor Green
Write-Host "  headers : $root\include\json-c\"
Write-Host "  libs    : $root\lib\libjson-c.*"
Write-Host "  runtime : $root\bin\libjson-c-*.dll  (must be on PATH at run time)"

$zigRoot = ($root -replace '\\', '/')
Write-Host "`nbuild.zig wiring:" -ForegroundColor Green
Write-Host @"
    exe.addIncludePath(.{ .cwd_relative = "$zigRoot/include" });
    exe.addLibraryPath(.{ .cwd_relative = "$zigRoot/lib" });
    exe.linkSystemLibrary("json-c");
    exe.linkLibC();
"@

Write-Host "`nCheck flags any time with (in the $Env shell):  pkg-config --cflags --libs json-c" -ForegroundColor DarkGray
