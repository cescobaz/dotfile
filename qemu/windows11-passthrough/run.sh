#!/bin/sh
set -eu

# /dev/sdb is root-owned (group: disk) — re-exec under sudo if we're not root.
[ "$(id -u)" -eq 0 ] || exec sudo -E -- "$0" "$@"

cd "$(dirname "$0")"

DISK=/dev/sdb
ISO=Win11_25H2_EnglishInternational_x64_v2.iso

# Safety: refuse to start if the host has any sdb partition mounted —
# concurrent access from host + guest will corrupt the filesystem.
if awk '$1 ~ /^\/dev\/sdb/ {found=1} END {exit !found}' /proc/mounts; then
    echo "Refusing to run: a partition of $DISK is mounted on the host:" >&2
    awk '$1 ~ /^\/dev\/sdb/ {print "  " $1 " -> " $2}' /proc/mounts >&2
    exit 1
fi

# Secure Boot OVMF (required by Win11). VARS file is local so changes
# made by the firmware stay isolated from your real machine's NVRAM.
OVMF_CODE=/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd
OVMF_VARS_SRC=/usr/share/edk2/x64/OVMF_VARS.4m.fd
OVMF_VARS=./OVMF_VARS-secboot.4m.fd
[ -f "$OVMF_VARS" ] || cp "$OVMF_VARS_SRC" "$OVMF_VARS"

# TPM 2.0 via swtpm (required by Win11 install/upgrade).
# Install with:  sudo pacman -S swtpm
if ! command -v swtpm >/dev/null 2>&1; then
    echo "swtpm not found. Install it (sudo pacman -S swtpm) and rerun." >&2
    exit 1
fi
TPM_DIR=./tpm
TPM_SOCK=$TPM_DIR/swtpm.sock
mkdir -p "$TPM_DIR"
if ! [ -S "$TPM_SOCK" ] || ! pgrep -af "swtpm .*$TPM_SOCK" >/dev/null; then
    swtpm socket --tpm2 \
        --tpmstate dir="$TPM_DIR" \
        --ctrl type=unixio,path="$TPM_SOCK" \
        --log level=20 \
        --daemon
fi
# SPICE client (remote-viewer) is launched by this script — NOT by QEMU's
# -display spice-app — so we can run it as the unprivileged user. Running
# remote-viewer as root tends to break GTK4's sandboxed SVG icon loader
# (glycin + bwrap) on themes that use SVG icons.
# Install with:  sudo pacman -S virt-viewer
if ! command -v remote-viewer >/dev/null 2>&1; then
    echo "remote-viewer not found. Install virt-viewer (sudo pacman -S virt-viewer) and rerun." >&2
    exit 1
fi

SPICE_SOCK="$(pwd)/spice.sock"
rm -f "$SPICE_SOCK"

trap '
    kill "${QEMU_PID:-0}" 2>/dev/null || true
    pkill -f "swtpm .*'"$TPM_SOCK"'" 2>/dev/null || true
    rm -f "'"$SPICE_SOCK"'"
' EXIT INT TERM

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
    -device virtio-vga,xres=1920,yres=1080 \
    -device qemu-xhci \
    -device usb-tablet \
    -device usb-kbd \
    -device virtio-serial-pci \
    -chardev spicevmc,id=spicechannel0,name=vdagent \
    -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
    -rtc base=localtime,clock=host \
    -display none \
    -spice unix=on,addr="$SPICE_SOCK",disable-ticketing=on \
    "$@" &
QEMU_PID=$!

# Wait for QEMU to open the SPICE socket (slow with Secure Boot OVMF).
for _ in $(seq 1 200); do
    [ -S "$SPICE_SOCK" ] && break
    kill -0 "$QEMU_PID" 2>/dev/null || {
        echo "QEMU exited before opening the SPICE socket." >&2
        exit 1
    }
    sleep 0.1
done

# Hand the socket to the unprivileged user so remote-viewer can connect
# without needing root (which breaks GTK4's glycin/bwrap on SVG themes).
if [ -n "${SUDO_USER:-}" ]; then
    chown "$SUDO_USER:" "$SPICE_SOCK"
    sudo -u "$SUDO_USER" -- remote-viewer "spice+unix://$SPICE_SOCK"
else
    remote-viewer "spice+unix://$SPICE_SOCK"
fi

# Viewer closed → stop QEMU and reap it.
kill "$QEMU_PID" 2>/dev/null || true
wait "$QEMU_PID" 2>/dev/null || true
