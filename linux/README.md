## DNS

Change DNS via (not really working)

```
buro-dns-set-cloudfair.sh
```

Brute force way: change the file `/etc/systemd/resolved.conf.d/dns_servers.conf`
And restart resolver `resolvectl restart`

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
