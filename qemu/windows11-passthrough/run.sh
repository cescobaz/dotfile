#!/bin/sh
set -eu

cd "$(dirname "$0")"

DISK=/dev/sdb
ISO=Win11_25H2_EnglishInternational_x64_v2.iso

# Secure Boot OVMF (required by Win11). VARS file is local so changes
# made by the firmware stay isolated from your real machine's NVRAM.
OVMF_CODE=/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd
OVMF_VARS_SRC=/usr/share/edk2/x64/OVMF_VARS.4m.fd
OVMF_VARS=./OVMF_VARS-secboot.4m.fd

# TPM 2.0 via swtpm (required by Win11 install/upgrade).
TPM_DIR=./tpm

# QEMU runs as the invoking user (NOT root), so its GTK window is a normal
# user-owned GUI — no root-owned GTK/Wayland client. The only bits that need
# elevation are: rw access to the raw disk (/dev/sdb is root:disk and we're
# not in the disk group) and taking ownership of any state files left behind
# by earlier root-era runs. Collect those into a single sudo invocation.
#   - /dev/kvm and /dev/dri/renderD128 are already world-rw, so KVM and the
#     GL render node need no elevation.
#   - The disk ACL is cleared when the device node is recreated (reboot or
#     replug), so re-apply it whenever it's missing.
USER_NAME=$(id -un)
ROOT_CMDS=""
add_root_cmd() { ROOT_CMDS="${ROOT_CMDS}$1
"; }

{ [ -r "$DISK" ] && [ -w "$DISK" ]; } || add_root_cmd "setfacl -m u:$USER_NAME:rw $DISK"
for f in "$OVMF_VARS" "$TPM_DIR"; do
    [ -e "$f" ] && ! [ -O "$f" ] && add_root_cmd "chown -R $USER_NAME: $f"
done

if [ -n "$ROOT_CMDS" ]; then
    echo "One-time privilege setup (needs sudo):"
    printf '%s' "$ROOT_CMDS" | sed 's/^/  /'
    sudo sh -ec "$ROOT_CMDS"
fi

# Safety: refuse to start if the host has any sdb partition mounted —
# concurrent access from host + guest will corrupt the filesystem.
if awk '$1 ~ /^\/dev\/sdb/ {found=1} END {exit !found}' /proc/mounts; then
    echo "Refusing to run: a partition of $DISK is mounted on the host:" >&2
    awk '$1 ~ /^\/dev\/sdb/ {print "  " $1 " -> " $2}' /proc/mounts >&2
    exit 1
fi

[ -f "$OVMF_VARS" ] || cp "$OVMF_VARS_SRC" "$OVMF_VARS"

# (TPM 2.0 via swtpm — required by Win11 install/upgrade.)
# Install with:  sudo pacman -S swtpm
if ! command -v swtpm >/dev/null 2>&1; then
    echo "swtpm not found. Install it (sudo pacman -S swtpm) and rerun." >&2
    exit 1
fi
TPM_SOCK=$TPM_DIR/swtpm.sock
mkdir -p "$TPM_DIR"
if ! [ -S "$TPM_SOCK" ] || ! pgrep -af "swtpm .*$TPM_SOCK" >/dev/null; then
    swtpm socket --tpm2 \
        --tpmstate dir="$TPM_DIR" \
        --ctrl type=unixio,path="$TPM_SOCK" \
        --log level=20 \
        --daemon
fi

# QEMU opens its own GTK window (-display gtk,gl=on) and runs in the
# foreground as this user, so there's no separate viewer process to launch
# and no SPICE socket to manage. Just reap swtpm when QEMU exits.
trap 'pkill -f "swtpm .*'"$TPM_SOCK"'" 2>/dev/null || true' EXIT INT TERM

# Attach the install ISO only when WITH_ISO=1 (e.g. for repair / reinstall).
# Default: no CD drive, boot straight from the HDD.
ISO_ARGS=""
if [ -n "${WITH_ISO:-}" ]; then
    [ -f "$ISO" ] || { echo "WITH_ISO set but $ISO not found." >&2; exit 1; }
    ISO_ARGS="-drive id=cd0,if=none,media=cdrom,readonly=on,file=$ISO \
              -device ide-cd,drive=cd0,bus=ide.1,bootindex=2"
fi

# Half of the host's logical CPUs, exposed as cores on one socket.
CPUS=$(($(nproc) / 2))

qemu-system-x86_64 \
    -name win11 \
    -machine type=q35,accel=kvm,smm=on \
    -global driver=cfi.pflash01,property=secure,value=on \
    -global ICH9-LPC.disable_s3=1 \
    -enable-kvm \
    -cpu host,kvm=on,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_vendor_id=KVMKVMKVM \
    -smp "cpus=${CPUS},sockets=1,cores=${CPUS},threads=1" \
    -m 8G \
    -drive if=pflash,format=raw,readonly=on,file="$OVMF_CODE" \
    -drive if=pflash,format=raw,file="$OVMF_VARS" \
    -chardev socket,id=chrtpm,path="$TPM_SOCK" \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-crb,tpmdev=tpm0 \
    -drive id=hd0,if=none,format=raw,cache=none,aio=native,discard=unmap,file="$DISK" \
    -device ide-hd,drive=hd0,bus=ide.0,bootindex=1 \
    $ISO_ARGS \
    -netdev user,id=net0 \
    -device e1000e,netdev=net0 \
    -device virtio-vga-gl,xres=1920,yres=1080 \
    -device qemu-xhci \
    -device usb-tablet \
    -device usb-kbd \
    -device virtio-serial-pci \
    -chardev qemu-vdagent,id=vdagent,name=vdagent,clipboard=on \
    -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
    -rtc base=localtime,clock=host \
    -display gtk,gl=on \
    "$@"
