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
├── run.sh                          launcher; must run as root (re-execs via sudo)
├── OVMF_VARS-secboot.4m.fd         VM NVRAM (Secure Boot, boot order, etc.)
├── tpm/                            swtpm state — emulated TPM 2.0 for the guest
└── Win11_25H2_EnglishInternational_x64_v2.iso   installer media
```

The ISO is not tracked in git; download a fresh one if you need to redo this.

## Requirements

Arch packages:

```
sudo pacman -S qemu-full edk2-ovmf swtpm virt-viewer
```

(`virt-viewer` provides `remote-viewer`, the SPICE client that pops up as
the VM window — see "Clipboard & drag-and-drop" below.)

The host needs KVM (CPU virtualization extensions enabled in BIOS) and the
user running `run.sh` needs sudo — `/dev/sdb` is a raw block device and only
root can open it.

## Usage

```
./run.sh
```

What it does:

1. Re-execs itself under `sudo` if not root.
2. Refuses to start if **any partition of `/dev/sdb` is currently mounted on
   the host** — concurrent host+guest writes would corrupt the filesystem.
3. Copies a clean `OVMF_VARS.4m.fd` template the first time, then reuses the
   local one on subsequent runs.
4. Starts `swtpm` as a daemon listening on `tpm/swtpm.sock` (auto-killed on
   exit via trap).
5. Launches QEMU with:
   - q35 + KVM + Secure Boot OVMF
   - half of the host's logical CPUs, exposed as cores on one socket
   - 8 GiB RAM
   - `/dev/sdb` as the boot disk (`bootindex=1`)
   - virtio-vga + SPICE display, launched separately as your user

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

## Clipboard & drag-and-drop (host ↔ guest)

The VM uses SPICE for its display (`-display spice-app`) and runs a
`vdagent` virtio-serial channel that the SPICE guest agent talks over. With
the guest agent installed, you get:

- **Clipboard sync** — `Ctrl+C` on the host and `Ctrl+V` inside Windows
  (and vice versa) move text between sides automatically. Most rich content
  works too.
- **Drag-and-drop** — drag files from a host file manager onto the
  `remote-viewer` window; they land in the focused Explorer folder (or on
  the Desktop) inside Windows.
- **Dynamic resolution** — resize the SPICE window and Windows reflows the
  display.
- **Seamless mouse** — no need to "release" the cursor; it hops in and out
  of the VM window as you'd expect.

### One-time guest setup

This only works once the SPICE Guest Tools are installed in Windows.
Otherwise the SPICE window still functions but clipboard and DnD do
nothing.

1. Boot the VM with `./run.sh`. Networking works out of the box (NAT), so
   open Edge inside Windows.
2. Go to <https://www.spice-space.org/download.html> and grab
   **"spice-guest-tools-latest.exe"** under *Windows binaries*.
3. Run it. It installs the QXL/virtio guest drivers, the `spice-vdagent`
   service, and a USB redirector. Reboot the VM when prompted.

After reboot, clipboard and drag-and-drop should both work immediately —
no extra configuration on either side.

### If something doesn't work

- **Clipboard does nothing in either direction:** check that the
  `spice-vdagent` service is running inside Windows (`services.msc`). If
  it's stopped, start it; if it's missing, reinstall SPICE Guest Tools.
- **Drag-and-drop into the VM does nothing:** make sure you're using
  `remote-viewer` ≥ 9.0 (`remote-viewer --version`). Older versions
  support clipboard but not file DnD.
- **No SPICE window opens at all:** `-display spice-app` needs
  `remote-viewer`; `run.sh` checks for it before launching.

### Bulk transfers

Clipboard + DnD is great for "a file or two." For dumping tens of GiB of
data either direction, it's faster to shut the VM down and `mount` `sdb`'s
NTFS partition directly on the host (`sudo mount /dev/sdb3 /mnt/win`) —
the install on `sdb` is a real Windows filesystem that Linux can read and
write via the kernel's NTFS3 driver.

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
