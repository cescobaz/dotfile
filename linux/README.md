## DNS

Change DNS via (not really working)

```
buro-dns-set-cloudfair.sh
```

Brute force way: change the file `/etc/systemd/resolved.conf.d/dns_servers.conf`
And restart resolver `resolvectl restart`

## GTK theme

UI config tool `nwg-look`.
Check arch wiki: config files in ~/.config/gtk-*
Sometimes the themes change name so they broke.

You can forse a theme by
```
GTK_THEME=Qogir-Round-Dark
```

Also check that GTK_THEME is set in the sway config with launcher.

## Driver

Use `modprobe` to enable or disable a driver, e.g.:

```bash
sudo modprobe -r 8821au
sudo modprobe 8821au
```

Sometimes "reloading" the driver will make the device working.

Driver options or blacklist could be stored in any file inside `/etc/modprobe.d/`

## Arch packages downgrade

Erlang example:

create a file with all packages from cache like:
```
file:///var/cache/pacman/pkg/erlang-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-asn1-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-common_test-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-core-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-debugger-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-dialyzer-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-diameter-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-edoc-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-eldap-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-erl_interface-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-et-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-eunit-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-ftp-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-inets-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-jinterface-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-megaco-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-mnesia-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-observer-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-odbc-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-os_mon-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-parsetools-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-public_key-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-reltool-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-runtime_tools-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-sasl-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-snmp-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-ssh-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-ssl-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-syntax_tools-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-tftp-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-tools-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-wx-27.3.4-1-x86_64.pkg.tar.zst
file:///var/cache/pacman/pkg/erlang-xmerl-27.3.4-1-x86_64.pkg.tar.zst
```

Then

```bash
cat erlang-27.txt | xargs -I % paru --noconfirm -U %
```

## Keyring auto unlock

To auto unlock the GNOME keyring at login (TTY login, no display manager),
change `/etc/pam.d/login` and add the `pam_gnome_keyring.so` lines:

```
#%PAM-1.0

auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start
password   include      system-local-login
```

- `auth ... pam_gnome_keyring.so` grabs the login password.
- `session ... pam_gnome_keyring.so auto_start` starts the daemon and unlocks the keyring with it.
- The `auth` line must be after `system-local-login`, the `session` line at the end of the session block.
- The keyring password (the `login` keyring) must be the same as the user password.
- The keyring must be named `login` (PAM only unlocks that one). Check it with:

```bash
ls ~/.local/share/keyrings/
# expect: login.keyring
```

  If it has another name (e.g. `Default_keyring.keyring`), rename it or create a new `login` keyring with `seahorse`.

Check: `sudo nvim /etc/pam.d/login`, then log out and log in again.
