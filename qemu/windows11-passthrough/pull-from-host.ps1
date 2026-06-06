# pull-from-host.ps1
# Pull (download, read-only) a folder from the Linux HOST into the CURRENT
# directory, over SSH, using the MSYS2 rsync installed via Scoop.
#
# 10.0.2.2 is the host as seen from this QEMU user-mode-networking guest.
# Run this from the Windows folder you want the files copied INTO.

$RemoteUser = "buro"                  # your Linux host username
$RemoteHost = "10.0.2.2"              # the QEMU host (leave as-is for this VM)
$RemotePath = "/home/buro/projects/FullControlX"  # folder on the host to read FROM

# Patterns to skip. rsync matching: a bare name (e.g. "node_modules") matches
# at ANY depth; a trailing "/" matches directories only; a leading "/" anchors
# to the transfer root; "*" stays within one path segment, "**" crosses "/".
$Exclude = @(
    ".git/"
    "node_modules/"
    "target/"          # rust/zig/maven build output
    "build/"
    "dist/"
    "*.log"
    ".venv/"
    "__pycache__/"
    "deps"
    "zig-out/"
    ".zig-cache/"
)
$excludeArgs = $Exclude | ForEach-Object { "--exclude=$_" }

# Flags: -a archive (recursive + preserve attrs), -v verbose, -z compress,
#        -h human-readable sizes, --progress per-file progress.
# Trailing slash on the SOURCE copies its CONTENTS into '.'; remove it to copy
# the folder itself as a subdirectory.
# Destination is '.' (current dir). Avoid Windows-style absolute paths like
# C:\dest here -- rsync reads the ':' as a remote host. Use /c/dest instead.
#
# -e "/usr/bin/ssh" forces the MSYS2 (Cygwin) ssh. WITHOUT this, the Cygwin
# rsync spawns Windows' native ssh.exe and the protocol stream breaks with
# "connection unexpectedly closed (0 bytes received)". Requires MSYS2 openssh:
#   & "$(scoop prefix msys2)\usr\bin\bash.exe" -lc "pacman -S --noconfirm openssh"
# --filter=':- .gitignore' also honors each directory's .gitignore as rsync
# walks the tree, so the sync skips whatever git ignores (on top of $Exclude).
rsync -avzh --progress -e "/usr/bin/ssh" --filter=':- .gitignore' $excludeArgs "${RemoteUser}@${RemoteHost}:${RemotePath}/" ./

# Options you may want:
#   -n            dry run: show what WOULD transfer, change nothing (test first)
#   --delete      mirror: delete local files that no longer exist on the host
#   -e "ssh -p N" use a non-default SSH port on the host
