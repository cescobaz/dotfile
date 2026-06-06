# Windows 11 on a physical disk, via QEMU

A QEMU VM that runs Windows 11 from a **real physical disk** (`/dev/sdb`)
rather than a disk image. The same `sdb` is also bootable bare metal, so
the host can dual-boot it directly when needed.

Two intended uses:

1. **Right now** — install Windows onto `sdb`. Doing the install through QEMU
   instead of off a USB stick keeps the host running and the host's NVRAM
   untouched.
2. **Ongoing** — boot Windows inside the VM whenever a Windows-only app is
   needed, without rebooting the host. For heavier work (or when the VM is
   too slow) reboot into bare metal instead.

The same `sdb` install is used in both modes — there's no separate VM disk
image to keep in sync.

A future variant of this folder will add **PCIe passthrough of a secondary
GPU** so the VM can run games at near-native performance. That's not wired
up yet; for now the config uses emulated graphics only. (The folder name is
aspirational, not current state.)

## Why a VM at all?

- The host stays usable during install and during ad-hoc Windows work.
- OVMF firmware variables stay in a **local file**
  (`OVMF_VARS-secboot.4m.fd`), isolated from the motherboard's real NVRAM,
  so VM boot order / Secure Boot enrollment doesn't pollute host firmware.
- The emulated TPM (swtpm) satisfies Win11's TPM 2.0 requirement
  independent of the host firmware's fTPM state.
- Windows sees the same disk in both VM and bare-metal contexts, so an
  install done here is the install you boot natively later.

## Layout

```
.
├── run.sh                          launcher; runs as your user (sudo only to grant disk access)
├── OVMF_VARS-secboot.4m.fd         VM NVRAM (Secure Boot, boot order, etc.)
├── tpm/                            swtpm state — emulated TPM 2.0 for the guest
└── Win11_25H2_EnglishInternational_x64_v2.iso   installer media
```

The ISO is not tracked in git; download a fresh one if you need to redo this.

## Requirements

Arch packages:

```
sudo pacman -S qemu-full edk2-ovmf swtpm virglrenderer acl
```

(`qemu-full` includes the GTK UI; `virglrenderer` backs the OpenGL display
(`gl=on`); `acl` provides `setfacl`, used to grant disk access — see below.)

The host needs KVM (CPU virtualization extensions enabled in BIOS) and a GPU
with a usable DRI render node (`/dev/dri/renderD128`) for the accelerated
display. QEMU runs as **your** user, not root — `run.sh` only uses `sudo`
once at startup to grant your user rw access to `/dev/sdb` (via an ACL) and
to adopt any state files left behind by older root-era runs.

## Usage

```
./run.sh
```

What it does:

1. Grants your user rw on `/dev/sdb` via `sudo setfacl` (and adopts any
   root-owned local state from older runs) — a single sudo prompt, only when
   needed. Everything after this runs as your unprivileged user.
2. Refuses to start if **any partition of `/dev/sdb` is currently mounted on
   the host** — concurrent host+guest writes would corrupt the filesystem.
3. Copies a clean `OVMF_VARS.4m.fd` template the first time, then reuses the
   local one on subsequent runs.
4. Starts `swtpm` as a daemon listening on `tpm/swtpm.sock` (auto-killed on
   exit via trap).
5. Launches QEMU (in the foreground) with:
   - q35 + KVM + Secure Boot OVMF
   - half of the host's logical CPUs, exposed as cores on one socket
   - 8 GiB RAM
   - `/dev/sdb` as the boot disk (`bootindex=1`)
   - `virtio-vga-gl` into a GTK window with OpenGL (`-display gtk,gl=on`),
     opened directly by QEMU as your user (no separate SPICE viewer)

By default **no install CD is attached** — the VM boots straight into the
Windows install on `sdb`. Pass `WITH_ISO=1` to re-attach the ISO at
`bootindex=2` for repair/reinstall:

```
WITH_ISO=1 ./run.sh
```

The ISO file itself stays on disk; it just isn't presented to the guest
unless asked for. Delete `Win11_*.iso` only if you're sure you'll never
need it again.

### Inside the VM

Standard Win11 install. On the "where do you want to install" screen, pick
the (single) disk shown — that's `/dev/sdb`. The installer will create the
usual UEFI/GPT layout:

- ~200 MB ESP (FAT32, contains `\EFI\Microsoft\Boot\bootmgfw.efi`)
- 16 MB MSR
- Remainder as NTFS (`C:`)

This is the correct, recommended layout. Don't try to skip the ESP.

### Skip the Microsoft account (local account only)

Win11 25H2 OOBE refuses to proceed past the "Sign in" screen without a
Microsoft account by default. The old `OOBE\BYPASSNRO` cmd trick was
removed; what currently works on 25H2:

1. Get to the "Let's connect you to a network" or "Sign in to your Microsoft
   account" screen.
2. Press **Shift + F10** to open a Command Prompt.
3. Run:

   ```
   start ms-cxh:localonly
   ```

   A small "Microsoft account" → "Create a local account" dialog appears on
   top of OOBE. Fill in username + password (or leave password blank) and
   click Next. OOBE continues into the privacy toggles with a local account.

Fallback if that ever stops working: build an `unattend.xml` with a
`<LocalAccounts>` block and stage it on a small FAT image attached as a
second CD; OOBE picks it up automatically. More fiddly, but Microsoft can't
patch it out short of breaking unattended deployments entirely.

You can later add a Microsoft account from Settings → Accounts if you ever
want one — this just avoids being forced into it during install.

## Display & clipboard (host ↔ guest)

The VM renders into a **GTK window opened directly by QEMU**
(`-display gtk,gl=on`), using `virtio-vga-gl` as the adapter. `gl=on` makes
the host composite the guest framebuffer as an OpenGL texture on your GPU,
which is lower-latency and lighter on CPU than the old SPICE path (SPICE
protocol + a separate `remote-viewer` process). There is no SPICE server,
socket, or external viewer anymore.

> **Performance note.** This is still emulated graphics. `gl=on` accelerates
> *presentation* on the host; it does **not** give the Windows guest 3D
> acceleration, because Windows has no production virtio-gpu 3D driver. The
> win is a snappier 2D desktop, not gaming performance — that requires GPU
> passthrough (see the intro and the bottom caveat).

Clipboard still works without SPICE: QEMU itself speaks the vdagent protocol
via `-chardev qemu-vdagent,clipboard=on` over the same `com.redhat.spice.0`
virtio-serial channel, bridged to the GTK window's clipboard. So:

- **Clipboard sync** — `Ctrl+C`/`Ctrl+V` move text between host and Windows
  (needs the guest agent — see below).
- **Seamless mouse** — the `usb-tablet` gives absolute pointing, so the
  cursor hops in and out of the window without an explicit release.
- **Dynamic resolution** — resizing the GTK window reflows the guest display
  once the virtio-gpu guest driver is installed.

**Drag-and-drop is gone.** File DnD was a SPICE/`remote-viewer` feature; the
GTK display doesn't provide it. Use the clipboard for small text, or the
bulk-transfer route below for files. The GTK window's own *View* menu offers
zoom / full-screen / scaling controls in its place.

### One-time guest setup

Clipboard needs the `spice-vdagent` service running in Windows, and the
adapter is happiest with the virtio-gpu display driver. Both come from the
SPICE Guest Tools:

1. Boot the VM with `./run.sh`. Networking works out of the box (NAT), so
   open Edge inside Windows.
2. Go to <https://www.spice-space.org/download.html> and grab
   **"spice-guest-tools-latest.exe"** under *Windows binaries*.
3. Run it. It installs the virtio/QXL guest drivers and the `spice-vdagent`
   service. Reboot the VM when prompted.

After reboot, clipboard sync works with no extra configuration on either
side. (If the display stays on a generic Microsoft Basic adapter, install
the virtio-gpu driver from the `virtio-win` ISO for proper 2D acceleration
and dynamic resolution.)

### If something doesn't work

- **Clipboard does nothing in either direction:** check that the
  `spice-vdagent` service is running inside Windows (`services.msc`). If
  it's stopped, start it; if it's missing, reinstall SPICE Guest Tools.
- **QEMU exits at startup with a GL/EGL or virgl error:** the host couldn't
  get an OpenGL context. Confirm `virglrenderer` is installed and
  `/dev/dri/renderD128` is readable by your user. As a fallback you can drop
  acceleration by editing `run.sh` to use `-display gtk` (no `gl=on`) and
  `-device virtio-vga` (no `-gl`).
- **Window is black or won't open on Wayland:** ensure you're running
  `run.sh` from within your graphical session (so `WAYLAND_DISPLAY` /
  `XDG_RUNTIME_DIR` are set); QEMU now runs as your user and inherits them.

### Bulk transfers

The clipboard is great for "a line or two." For dumping tens of GiB of
data either direction, it's faster to shut the VM down and `mount` `sdb`'s
NTFS partition directly on the host (`sudo mount /dev/sdb3 /mnt/win`) —
the install on `sdb` is a real Windows filesystem that Linux can read and
write via the kernel's NTFS3 driver.

## Networking: reaching host services from the guest

The VM uses QEMU **user-mode networking** (`-netdev user,id=net0` in
`run.sh`) — a built-in NAT. No addresses are configured explicitly, so QEMU
applies its hardcoded SLiRP defaults for the `10.0.2.0/24` network:

| Role | Address |
|------|---------|
| **Host (this Linux machine)** | **`10.0.2.2`** |
| Guest (Windows) — first DHCP lease | `10.0.2.15` |
| Virtual DNS | `10.0.2.3` |

So **to connect from Windows to a server running on the host, use `10.0.2.2`
plus the port** — e.g. `http://10.0.2.2:8080`. SLiRP originates the
connection from the host itself, so this reaches host services bound to
`127.0.0.1` as well as `0.0.0.0`; you usually don't need to rebind. If it
won't connect, check the host firewall (`firewalld`/`nftables`).

These numbers aren't in `run.sh` — they're QEMU defaults, documented under
`-netdev user` in `man qemu-system-x86_64`. Confirm them live from Windows
with `ipconfig` (IP + gateway) and `nslookup` (DNS). To change them, set
them explicitly, e.g.
`-netdev user,id=net0,net=192.168.76.0/24,host=192.168.76.9`.

Note the NAT is one-way: the guest can reach the host, but the host can't
initiate connections *into* the guest without a `hostfwd=` port forward. For
full LAN visibility (guest gets its own IP, reachable from other machines),
switch to a tap bridge — see the caveat below.

## Booting `sdb` bare metal

When you want the full machine (faster, real GPU), shut the VM down cleanly
and reboot the host.

The "Windows Boot Manager" NVRAM entry the installer wrote lives **in the
local `OVMF_VARS` file, not in your motherboard's NVRAM** — so the MSI
firmware won't list it as a saved boot option until it discovers `sdb`'s
`bootmgfw.efi` on its own. Two ways to handle that:

- **One-shot boot menu (recommended):** tap **F11** at the MSI splash screen.
  The firmware enumerates removable + fixed UEFI bootloaders and offers them
  as a one-shot pick. Choose the Windows entry; on first boot Windows will
  also register itself as a persistent NVRAM entry.
- **Boot order:** enter setup (DEL), put `UEFI: <sdb model>` first, save,
  reboot. Less convenient if you switch OSes often.

### About having two ESPs

Linux's ESP lives on `sda`, Windows's now lives on `sdb`. **That's the
recommended setup for two-disk dual-boot** — each disk is independently
bootable, and Windows Updates can't trample systemd-boot's files. There is
no benefit to consolidating them.

## Resetting state

To start over from a clean firmware/TPM state:

```
sudo rm -rf tpm/ OVMF_VARS-secboot.4m.fd
```

To wipe Windows from `sdb` itself, blow away its partition table from the
host (only when the VM is stopped and `sdb` is not mounted):

```
sudo sgdisk --zap-all /dev/sdb
```

## Dual use safety: never run VM and bare-metal Windows concurrently

Obvious but worth stating: this is the **same physical Windows install** in
both modes. Don't have the VM running while the host is also booted into
Windows (impossible from one machine, but worth remembering if you ever add
network shares of `sdb` from another box). The `run.sh` mount-check guards
against the host accidentally mounting an `sdb` partition while the VM is
running — it does not guard against you booting `sdb` natively.

Also: when you boot `sdb` bare metal, Windows will see the real motherboard,
real CPU, real GPU, real NICs. It will install drivers and may re-arm a
short activation grace period. This is normal and self-heals after a couple
of reboots between modes.

## Caveats

- `/dev/sdb` is hard-coded in `run.sh`. If the target disk's kernel name
  changes (drive added/removed, USB device plugged in at boot, etc.) the
  script will happily point QEMU at the wrong disk. Always double-check with
  `lsblk` before running.
- The VM uses `user` networking (NAT). Fine for activation, updates, and
  outbound traffic; no inbound connections from the host. Switch to a tap
  bridge later if you want LAN visibility.
- No GPU/PCIe passthrough yet — see the intro. When that variant lands it
  will likely live in a sibling folder or a separate `run-passthrough.sh`,
  not replace this one (the plain config is still useful for quick boots).
