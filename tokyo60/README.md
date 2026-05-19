# Tokyo60 keyboard

Notes, requirements, and procedures for keeping the **Tokyo60** firmware
healthy on this machine.

## What this keyboard is

A custom 60% mechanical keyboard built on the QMK firmware platform.
The kernel sees it as four separate HID interfaces:

| event node | Name                                       | What it is |
|------------|--------------------------------------------|------------|
| event2     | `Tokyo Keyboard tokyo60`                   | Default HID device |
| event3     | `Tokyo Keyboard tokyo60 System Control`    | HID *System Control* page — power/sleep/wake codes |
| event4     | `Tokyo Keyboard tokyo60 Consumer Control`  | HID *Consumer* page — media/volume keys |
| event5     | `Tokyo Keyboard tokyo60 Keyboard`          | Regular typing keys |

USB identity:

```
VID:PID = feed:6060
ID_VENDOR = Tokyo_Keyboard
ID_MODEL  = tokyo60
```

The matching QMK config on this system is in `~/.config/qmk/qmk.ini`
(`keyboard = buro`, pointing at a `qmk_firmware` checkout under
`~/projects/external/qmk_firmware`).

## Why this folder exists

The keyboard's firmware can emit raw HID *System Control* codes (e.g.
`KC_SYSTEM_POWER`). On Linux those reach `systemd-logind`, which by
default reacts to `KEY_POWER` by shutting the machine down
(`HandlePowerKey=poweroff`).

In practice that means a stray firmware mapping (for example **Fn+Esc =
`KC_SYSTEM_POWER`**) will *silently shut the computer off* with no
breadcrumbs in sway, hyprland, or any X/Wayland config — because the
binding doesn't live in any of those. It lives **inside the keyboard's
firmware**.

This folder is the place to record that, plus the procedure to fix it.

## Requirements

Toolchain (QMK CLI, AVR/ARM compilers, flashing tools) and the Vial
GUI are installed via the dedicated playbook:

- [`ansible/playbook/install-qmk-vial.yml`](../ansible/playbook/install-qmk-vial.yml)

Run it against this host with:

```sh
ansible-playbook --inventory ansible/inventory.yml \
  --limit arch-tower \
  --extra-vars 'ansible_connection=local' \
  --ask-vault-pass \
  ansible/playbook/install-qmk-vial.yml
```

(Substitute your hostname for `arch-tower` if you're running against a
different machine in the inventory.)

The playbook also installs `/etc/udev/rules.d/99-vial.rules`
(source: [`ansible/files/99-vial.rules`](../ansible/files/99-vial.rules))
so Vial can open the keyboard's hidraw node without root.

## Picking the right procedure

```
                  Is the firmware on the keyboard Vial-enabled?
                                 │
                  ┌──────────────┴──────────────┐
                 yes                            no
                  │                              │
            Use Vial GUI                   Rebuild & reflash
       (no recompile needed)              the QMK firmware
```

You can check by plugging the keyboard in and running:

```sh
vial
```

If the GUI shows the keyboard, it's Vial-enabled. If it says "No
devices detected" but the keyboard works for typing, the firmware is
stock QMK and you'll need to flash a Vial-QMK build (or just rebuild
stock QMK with the binding changed).

## Procedure A — Live remap with Vial (preferred when firmware is Vial)

1. Plug the keyboard in.
2. Launch `vial`.
3. Select the keyboard in the device list. Pick the layer where the
   misbehaving binding lives (Fn+Esc is on the Fn layer).
4. Click the offending key in the on-screen layout and assign a safe
   keycode — e.g. `KC_GRV` if you want Fn+Esc to type a backtick
   (macOS-style fake Esc), or `KC_NO` to disable it outright.
5. Vial writes the change to the keyboard's EEPROM immediately. Verify
   by tapping Fn+Esc — no shutdown.

If you ever need to wipe back to defaults: *Security → Reset EEPROM* in
Vial.

## Procedure B — Rebuild and flash QMK

Use this when the firmware is not Vial, or when you want the change to
be the new permanent default rather than an EEPROM override.

1. Make sure the QMK CLI is set up (installed by the playbook above).

2. Clone the firmware tree if it isn't already present:

   ```sh
   mkdir -p ~/projects/external
   git clone --recursive https://github.com/qmk/qmk_firmware.git \
     ~/projects/external/qmk_firmware
   ```

   `~/.config/qmk/qmk.ini` is already configured to use this path with
   `keyboard = buro` and `keymap = default`.

3. Edit the keymap to remove the dangerous binding. Open the keymap
   file for the `buro` keyboard:

   ```sh
   $EDITOR ~/projects/external/qmk_firmware/keyboards/buro/keymaps/default/keymap.c
   ```

   Find the Fn-layer entry that's currently `KC_PWR` or
   `KC_SYSTEM_POWER` in the Esc position and replace it with
   `KC_GRV` (backtick), `KC_TRNS` (fall through), or `KC_NO`.

4. Build:

   ```sh
   qmk compile
   ```

5. Put the keyboard into bootloader mode (usually a reset button on
   the PCB, or a `RESET`/`QK_BOOT` keycode in the current keymap).

6. Flash. The exact flasher depends on the MCU bootloader — `qmk flash`
   will normally pick the right one automatically:

   ```sh
   qmk flash
   ```

   Manual fallbacks if needed:
   - Caterina (Pro Micro / ATmega32U4): `avrdude`
   - Atmel DFU: `dfu-programmer`
   - STM32 DFU: `dfu-util`

   All three are installed as dependencies of the `qmk` package.

7. Once flashing finishes the keyboard re-enumerates. Verify Fn+Esc no
   longer triggers a shutdown.

## Procedure C — OS-level safety nets (workarounds, not fixes)

If the keyboard cannot be reflashed right now, you can blunt the impact
at the OS level. These are workarounds — they don't fix the firmware.

### C1. Neuter `KEY_POWER` in logind (global)

Drop this file as root:

```ini
# /etc/systemd/logind.conf.d/00-ignore-powerkey.conf
[Login]
HandlePowerKey=ignore
HandlePowerKeyLongPress=ignore
```

Then:

```sh
sudo systemctl restart systemd-logind
```

**Caveat:** this also disables the case/laptop power button. You'll
need a long-hold (firmware-level shutdown) or `systemctl poweroff` from
a terminal.

### C2. Drop `KEY_POWER` only from the tokyo60 (targeted)

A hwdb override that remaps `KEY_POWER` to `KEY_RESERVED` for
`VID feed:PID 6060` only. Leaves the real power button untouched. Not
included in this repo by default — ask if you want it added.

## Verifying after any change

Quick smoke test:

```sh
# Watch for KEY_POWER events from the System Control endpoint.
sudo evtest /dev/input/by-id/usb-Tokyo_Keyboard_tokyo60_0-event-if01
```

Press Fn+Esc. If no `KEY_POWER` event appears, the firmware fix took.
If `KEY_POWER` still appears but the machine stays up, the OS-level
workaround is in effect (and the firmware still needs fixing).

## Related files in this repo

- [`ansible/playbook/install-qmk-vial.yml`](../ansible/playbook/install-qmk-vial.yml) — installs the toolchain and udev rule
- [`ansible/files/99-vial.rules`](../ansible/files/99-vial.rules) — udev rule for non-root hidraw access
